From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] xtables: Add locking to prevent concurrent instances
Date: Wed, 29 May 2013 14:59:03 +0200
Message-ID: <20130529125903.GA6390@localhost>
References: <20130527162311.GA1366@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45272 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507Ab3E2M7J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 08:59:09 -0400
Content-Disposition: inline
In-Reply-To: <20130527162311.GA1366@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

Thanks for looking at this old issue and bring it back to discussion.

On Mon, May 27, 2013 at 12:23:11PM -0400, Phil Oester wrote:
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
> terminates.  This is the locking solution I chose to implement in xtables-multi.
> As an added bonus, since each network namespace has its own socket pool, an
> iptables instance running in one namespace will not lock out an iptables
> instance running in another namespace.  A filesystem approach would have
> to recognize and handle multiple network namespaces.
> 
> Phil
> 
> Signed-off-by: Phil Oester <kernel@linuxace.com>
> 
> ---
> 
> v2: Addressed Patrick's comments - locking attempts will be made indefinitely until successful
> v3: Update warning message to more closely resemble locking output from yum
> 

> diff --git a/iptables/xtables-multi.c b/iptables/xtables-multi.c
> index 8014d5f..56d2c91 100644
> --- a/iptables/xtables-multi.c
> +++ b/iptables/xtables-multi.c
> @@ -1,8 +1,12 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <sys/socket.h>
> +#include <sys/un.h>
> +#include <unistd.h>
>  #include "xshared.h"
>  
> +#include "xtables.h"
>  #include "xtables-multi.h"
>  
>  #ifdef ENABLE_IPV4
> @@ -35,7 +39,32 @@ static const struct subcommand multi_subcommands[] = {
>  	{NULL},
>  };
>  
> +#define XTMSOCKET_NAME "xtables_multi"
> +#define XTMSOCKET_LEN 14
> +
>  int main(int argc, char **argv)
>  {
> +	int i = 0, ret, xtm_socket;
> +	struct sockaddr_un xtm_addr;
> +
> +	memset(&xtm_addr, 0, sizeof(xtm_addr));
> +	xtm_addr.sun_family = AF_UNIX;
> +	strcpy(xtm_addr.sun_path+1, XTMSOCKET_NAME);
> +	xtm_socket = socket(AF_UNIX, SOCK_STREAM, 0);
> +	/* If we can't even create a socket, just revert to prior (lockless) behavior */
> +	if (xtm_socket < 0)
> +		return subcmd_main(argc, argv, multi_subcommands);
> +
> +	while (1) {
> +		ret = bind(xtm_socket, (struct sockaddr*)&xtm_addr,
> +			   offsetof(struct sockaddr_un, sun_path)+XTMSOCKET_LEN);
> +		if (ret == 0)
> +			break;
> +		if (++i % 5 == 0)
> +			fprintf(stderr, "Another app is currently holding the xtables lock; "
> +				"waiting for it to exit...\n");
> +		sleep(1);
> +	}
> +

I think we can:

* Add a new option to explicitly request this behaviour, just as a way
  to assert that you really want iptables to retry. Harald was rising
  some concerns on the expected results in case of clash that sound
  reasonable to me.

* Limit this to ip[6]tables. All bug reports refer to it.

Regards.
