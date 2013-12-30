From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxtables: Call ipaddr_to_network before
 ipaddr_to_host.
Date: Mon, 30 Dec 2013 18:46:03 +0100
Message-ID: <20131230174603.GA21372@localhost>
References: <20131209200223.GC2970@Inspiron-3521>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hani Benhabiles <kroosec@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab3L3RqH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:46:07 -0500
Content-Disposition: inline
In-Reply-To: <20131209200223.GC2970@Inspiron-3521>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 09, 2013 at 09:02:23PM +0100, Hani Benhabiles wrote:
> Call ipaddr_to_network before ipaddr_to_host.
> 
> This saves waiting for a reverse DNS lookup query when the entry is present in
> /etc/networks. This also follows the same order as in rules creation.

This saves time and it makes sense to me to check local file before
name resolution via network, but...

> Signed-off-by: Hani Benhabiles <kroosec@gmail.com>
> ---
>  libxtables/xtables.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index fb60c01..bb25262 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1207,8 +1207,8 @@ const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
>  {
>  	const char *name;
>  
> -	if ((name = ipaddr_to_host(addr)) != NULL ||
> -	    (name = ipaddr_to_network(addr)) != NULL)
> +	if ((name = ipaddr_to_network(addr)) != NULL ||
> +	    (name = ipaddr_to_host(addr)) != NULL)

My only concern is the remote case in which you may have a network
name that overlaps with some existing host name, in that case the
expected output different.

