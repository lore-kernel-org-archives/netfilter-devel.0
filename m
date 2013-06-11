From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] xtables: Add locking to prevent concurrent instances
Date: Tue, 11 Jun 2013 12:56:23 +0200
Message-ID: <20130611105623.GA20649@localhost>
References: <20130531130704.GA20357@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40642 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab3FKK41 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:56:27 -0400
Content-Disposition: inline
In-Reply-To: <20130531130704.GA20357@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 31, 2013 at 09:07:04AM -0400, Phil Oester wrote:
> There have been numerous complaints and bug reports over the years when admins
> attempt to run more than one instance of iptables simultaneously.  Currently
> open bug reports which are related:
> 
> 325: Parallel execution of the iptables is impossible
> 758: Retry iptables command on transient failure
> 764: Doing -Z twice in parallel breaks counters
> 822: iptables shows negative or other bad packet/byte counts
> 
> As Patrick notes in 325:  "Since this has been a problem people keep running
> into, I'd suggest to simply add some locking to iptables to catch the most
> common case."
> 
> I started looking into alternatives to add locking, and of course the most
> common/obvious solution is to use a pidfile.  But this has various downsides,
> such as if the application is terminated abnormally and the pidfile isn't
> cleaned up.  And this also requires a writable filesystem.  Using a UNIX domain
> socket file (e.g. in /var/run) has similar issues.
> 
> Starting in 2.2, Linux added support for abstract sockets.  These sockets
> require no filesystem, and automatically disappear once the application
> terminates.  This is the locking solution I chose to implement in ip[6]tables.
> As an added bonus, since each network namespace has its own socket pool, an
> ip[6]tables instance running in one namespace will not lock out an ip[6]tables
> instance running in another namespace.  A filesystem approach would have
> to recognize and handle multiple network namespaces.

Applied, thanks.

I made some minor change:

> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index c8d34e2..3877d2f 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
[...]
> @@ -1724,6 +1731,14 @@ int do_command6(int argc, char *argv[], char **table, struct xtc_handle **handle
>  			   "chain name `%s' too long (must be under %u chars)",
>  			   chain, XT_EXTENSION_MAXNAMELEN);
>  
> +	/* Attempt to acquire the xtables lock */
> +	if (!xtables_lock(wait)) {
> +		fprintf(stderr, "Another app is currently holding the xtables lock. "
> +			"Perhaps you want to use the -w option?\n");
> +		xtables_free_opts(1);
> +		exit(1);

exit(RESOURCE_PROBLEM)

Just to make sure that scripts don't break for people that are relying
on that return value.
