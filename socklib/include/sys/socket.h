#ifndef __SOCKET_H__
#define __SOCKET_H__

/*
 * socket.h
 *
 * Routines that call the Spectranet ROM socket library.
 *
 * 2008-05-03 Dylan Smith
 */

/* Definitions */
#define AF_INET		0
#define SOCK_STREAM	1
#define SOCK_DGRAM	2
#define SOCK_RAW	3

/* Much of this should ultimately end up in sys/types.h */
#define in_addr_t	unsigned long

/* Structures */

/* As defined in http://tools.ietf.org/html/draft-ietf-sip-bsd-systems-00 */
struct sockaddr_in	/* internet socket address structure */
{
	int sin_family;			/* offset 0 */
	unsigned int sin_port;		/* offset 2 */
	struct in_addr sin_addr;	/* offset 4 */
	char sin_zero[8];		/* offset 8 */
};

struct in_addr
{
	in_addr_t s_addr;		/* 32 bits */
};

#define sockaddr sockaddr_in
#define socklen_t int

/* CALLER and FASTCALL linkage calls */
extern int __LIB__	socket(int domain, int type, int protocol);
extern int __LIB__ __FASTCALL__ sockclose(int fd);
extern int __LIB__	bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen);
extern int __LIB__	connect(int sockfd, struct sockaddr *serv_addr, socklen_t addrlen);
extern int __LIB__	send(int sockfd, void *buf, int len, int flags);
extern int __LIB__	recv(int sockfd, void *buf, int len, int flags);
extern int __LIB__	accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

/* CALLEE linkage calls */
extern int __LIB__ __CALLEE__	socket_callee(int domain, int type, int proto);
extern int __LIB__ __CALLEE__	bind_callee(int sockfd, struct sockaddr *my_addr, socklen_t addrlen);
extern int __LIB__ __CALLEE__	connect_callee(int sockfd, struct sockaddr *serv_addr, socklen_t addrlen);
extern int __LIB__ __CALLEE__	send_callee(int sockfd, void *buf, int len, int flags);
extern int __LIB__ __CALLEE__	recv_callee(int sockfd, void *buf, int len, int flags);
extern int __LIB__ __CALLEE__	accept_callee(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

/* Make CALLEE default */
#define socket(a,b,c)		socket_callee(a,b,c)
#define bind(a,b,c)		bind_callee(a,b,c)
#define connect(a,b,c)		connect_callee(a,b,c)
#define send(a,b,c,d)		send_callee(a,b,c,d)
#define recv(a,b,c,d)		recv_callee(a,b,c,d)
#define accept(a,b,c)		accept_callee(a,b,c)

/* htons is a no-op, since all the calls convert machine byte order to
 * network byte order. The macro is provided for compatibility */
#define htons(a)		(a)
#define ntohs(a)		(a)

#endif
