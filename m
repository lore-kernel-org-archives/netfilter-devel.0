From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netlink: do not SIGSEGV when socket() fails
Date: Thu, 5 Dec 2013 10:03:41 +0100
Message-ID: <20131205090341.GA4785@localhost>
References: <20131204203030.GE2767@breakpoint.cc>
 <1386213533-2149-1-git-send-email-shawn@churchofgit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shawn Landden <shawn@churchofgit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab3LEJDu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:03:50 -0500
Content-Disposition: inline
In-Reply-To: <1386213533-2149-1-git-send-email-shawn@churchofgit.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 04, 2013 at 07:18:53PM -0800, Shawn Landden wrote:
> Program received signal SIGSEGV, Segmentation fault.
> mnl_socket_close (nl=0x0) at socket.c:248
> 248        int ret = close(nl->fd);
> (gdb) bt
>  #0  mnl_socket_close (nl=0x0) at socket.c:248
>  #1  0x0000000000410f79 in netlink_close_sock () at src/netlink.c:45
>  #2  0x00007ffff7de9fcf in _dl_fini () at dl-fini.c:253
>  #3  0x00007ffff717fa91 in __run_exit_handlers (status=2, listp=0x7ffff74ec5c8
> <__exit_funcs>,
>     run_list_atexit=run_list_atexit@entry=true) at exit.c:77
>  #4  0x00007ffff717fb15 in __GI_exit (status=<optimized out>) at exit.c:99
>  #5  0x0000000000419b60 in memory_allocation_error () at src/utils.c:24
>  #6  0x0000000000410f3a in netlink_open_sock () at src/netlink.c:37
>  #7  0x00000000004291cd in __libc_csu_init ()
>  #8  0x00007ffff7167925 in __libc_start_main (main=0x405219 <main>, argc=1,
>     ubp_av=0x7fffffffe738, init=0x429170 <__libc_csu_init>, fini=<optimized
> out>,
>     rtld_fini=<optimized out>, stack_end=0x7fffffffe728) at libc-start.c:235
>  #9  0x0000000000404d49 in _start ()
> 
> The include of <nftables.h> is wierd so I can't use NFT_EXIT_NOMEM in this file.

Please, add NFT_EXIT_NONL.

> Signed-off-by: Shawn Landden <shawn@churchofgit.com>
> ---
>  src/netlink.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 533634a..5240633 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -33,8 +33,11 @@ static struct mnl_socket *nf_sock;
>  static void __init netlink_open_sock(void)
>  {
>  	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
> -	if (nf_sock == NULL)
> +	if (nf_sock == NULL) {
> +		dprintf(STDERR_FILENO,
> +			"Could not open AF_NETLINK socket: %m\n");
>  		memory_allocation_error();
> +	}

Better add this function to utils.c

void __noreturn netlink_error(void)
{
        fprintf(stderr, "Netlink failure: %s\n", strerror(errno));
        exit(NFT_EXIT_NONL);
}

And call it from there. Thanks.
