From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libmnl: Add filtering support to library as a
 convienience
Date: Fri, 19 Apr 2013 04:20:02 +0200
Message-ID: <20130419022002.GA5882@localhost>
References: <1364307643-21747-1-git-send-email-nhorman@tuxdriver.com>
 <20130326205028.GA7117@localhost>
 <5152B9FF.7050705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
	netfilter-devel@vger.kernel.org, Hushan Jia <hushan.jia@gmail.com>
To: Florian Weimer <fweimer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60041 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967156Ab3DSCUH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:20:07 -0400
Content-Disposition: inline
In-Reply-To: <5152B9FF.7050705@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 27, 2013 at 10:21:03AM +0100, Florian Weimer wrote:
[...]
> From 2a6246b9158df6c4ef1000a5a92b599a1f393f7f Mon Sep 17 00:00:00 2001
> From: Florian Weimer <fweimer@redhat.com>
> Date: Wed, 27 Mar 2013 10:10:01 +0100
> Subject: [PATCH 1/2] Functions which modify state should not take const
>  arguments
> 
> Sending and receiving packets and changing socket options
> modify the internal socket state, which was not reflected in the
> prototype.  mnl_socket_get_fd provides access to the underlying
> file descriptor, which indirectly allows modification.
> 
> Signed-off-by: Florian Weimer <fweimer@redhat.com>
> ---
>  include/libmnl/libmnl.h | 8 ++++----
>  src/socket.c            | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> index a647fd9..5145ba5 100644
> --- a/include/libmnl/libmnl.h
> +++ b/include/libmnl/libmnl.h
> @@ -29,11 +29,11 @@ struct mnl_socket;
>  extern struct mnl_socket *mnl_socket_open(int type);
>  extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
>  extern int mnl_socket_close(struct mnl_socket *nl);
> -extern int mnl_socket_get_fd(const struct mnl_socket *nl);
> +extern int mnl_socket_get_fd(struct mnl_socket *nl);
>  extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
> -extern ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
> -extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
> -extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
> +extern ssize_t mnl_socket_sendto(struct mnl_socket *nl, const void *req, size_t siz);
> +extern ssize_t mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t siz);
> +extern int mnl_socket_setsockopt(struct mnl_socket *nl, int type, void *buf, socklen_t len);
>  extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
>  
>  /*
> diff --git a/src/socket.c b/src/socket.c
> index 6d54563..c77af91 100644
> --- a/src/socket.c
> +++ b/src/socket.c
> @@ -82,7 +82,7 @@ struct mnl_socket {
>   *
>   * This function returns the file descriptor of a given netlink socket.
>   */
> -int mnl_socket_get_fd(const struct mnl_socket *nl)
> +int mnl_socket_get_fd(struct mnl_socket *nl)
>  {
>  	return nl->fd;
>  }
> @@ -178,7 +178,7 @@ EXPORT_SYMBOL(mnl_socket_bind);
>   * returns the number of bytes sent.
>   */
>  ssize_t
> -mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
> +mnl_socket_sendto(struct mnl_socket *nl, const void *buf, size_t len)
>  {
>  	static const struct sockaddr_nl snl = {
>  		.nl_family = AF_NETLINK
> @@ -203,7 +203,7 @@ EXPORT_SYMBOL(mnl_socket_sendto);
>   * message without truncating it.
>   */
>  ssize_t
> -mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
> +mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t bufsiz)
>  {
>  	ssize_t ret;
>  	struct sockaddr_nl addr;
> @@ -276,7 +276,7 @@ EXPORT_SYMBOL(mnl_socket_close);
>   *
>   * On error, this function returns -1 and errno is appropriately set.
>   */
> -int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
> +int mnl_socket_setsockopt(struct mnl_socket *nl, int type,
>  			  void *buf, socklen_t len)
>  {
>  	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
> -- 
> 1.8.1.4
> 

> From 7da5a365c9908972726243b12b91666352c1ee31 Mon Sep 17 00:00:00 2001
> From: Florian Weimer <fweimer@redhat.com>
> Date: Wed, 27 Mar 2013 10:19:35 +0100
> Subject: [PATCH 2/2] mnl_socket_peer_address: Add function to retrieve the
>  sender address
> 
> This allows callers of mnl_socket_recvfrom to examine the address,
> for instance, to give special treatment to messages sent by the kernel.
> 
> Signed-off-by: Florian Weimer <fweimer@redhat.com>
> ---
>  include/libmnl/libmnl.h |  1 +
>  src/libmnl.map          |  4 ++++
>  src/socket.c            | 24 ++++++++++++++++++++----
>  3 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> index 5145ba5..74995fa 100644
> --- a/include/libmnl/libmnl.h
> +++ b/include/libmnl/libmnl.h
> @@ -33,6 +33,7 @@ extern int mnl_socket_get_fd(struct mnl_socket *nl);
>  extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
>  extern ssize_t mnl_socket_sendto(struct mnl_socket *nl, const void *req, size_t siz);
>  extern ssize_t mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t siz);
> +extern struct sockaddr_nl *mnl_socket_peer_address(struct mnl_socket *nl);
>  extern int mnl_socket_setsockopt(struct mnl_socket *nl, int type, void *buf, socklen_t len);
>  extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
>  
> diff --git a/src/libmnl.map b/src/libmnl.map
> index dbc332e..626ea87 100644
> --- a/src/libmnl.map
> +++ b/src/libmnl.map
> @@ -69,6 +69,10 @@ global:
>  local: *;
>  };
>  
> +LIBMNL_1.0.3 {
> +  mnl_socket_peer_address;
> +};
> +
>  LIBMNL_1.1 {
>    mnl_attr_parse_payload;
>  } LIBMNL_1.0;
> diff --git a/src/socket.c b/src/socket.c
> index c77af91..1d956a0 100644
> --- a/src/socket.c
> +++ b/src/socket.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <libmnl/libmnl.h>
> +#include <string.h>
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <stdlib.h>
> @@ -69,6 +70,7 @@
>  struct mnl_socket {
>  	int 			fd;
>  	struct sockaddr_nl	addr;
> +	struct sockaddr_nl	peer;
>  };
>  
>  /**
> @@ -206,14 +208,13 @@ ssize_t
>  mnl_socket_recvfrom(struct mnl_socket *nl, void *buf, size_t bufsiz)

I prefer if you send me a patch to add a new recvfrom function (with
new name) that allows you to pass the sockaddr_nl:

mnl_socket_recvfrom_addr

I prefer not to deconstify all those functions and not to increase the
size of mnl_socket.
