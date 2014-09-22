From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl] socket: creating a struct mnl_socket from a
 pre-existing socket
Date: Mon, 22 Sep 2014 12:24:32 +0200
Message-ID: <20140922102432.GA6074@salvia>
References: <20140920060536.GA15209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaIVKX0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:23:26 -0400
Content-Disposition: inline
In-Reply-To: <20140920060536.GA15209@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 20, 2014 at 03:05:37PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch defines a new function mnl_socket_fdopen() which
> creates a struct mnl_socket object from a pre-existing netlink
> socket obtained from other process. Now I think of the socket
> is obtained from child process via send/recvmsg().

OK, you can also use this to send netlink messages using different
domain/type sockets from the same process too, I'm going to attach
this to the description.

> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  include/libmnl/libmnl.h |  1 +
>  src/libmnl.map          |  1 +
>  src/socket.c            | 20 ++++++++++++++++++++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> index 223709c..0de6678 100644
> --- a/include/libmnl/libmnl.h
> +++ b/include/libmnl/libmnl.h
> @@ -22,6 +22,7 @@ extern "C" {
>  struct mnl_socket;
>  
>  extern struct mnl_socket *mnl_socket_open(int type);
> +extern struct mnl_socket *mnl_socket_fdopen(int fd);
>  extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
>  extern int mnl_socket_close(struct mnl_socket *nl);
>  extern int mnl_socket_get_fd(const struct mnl_socket *nl);
> diff --git a/src/libmnl.map b/src/libmnl.map
> index dbc332e..1ea8b8e 100644
> --- a/src/libmnl.map
> +++ b/src/libmnl.map
> @@ -71,4 +71,5 @@ local: *;
>  
>  LIBMNL_1.1 {
>    mnl_attr_parse_payload;
> +  mnl_socket_fdopen;

I'm going to fix this and apply. mnl_socket_fdopen doesn't belong
here.
