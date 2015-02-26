From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ebtables: Cache a copy of the v3.16 kernel headers in
 the ebtables tree
Date: Thu, 26 Feb 2015 20:30:54 +0100
Message-ID: <20150226193054.GA5142@salvia>
References: <54EF4BE4.4020002@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35105 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbbBZT1U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 14:27:20 -0500
Content-Disposition: inline
In-Reply-To: <54EF4BE4.4020002@codethink.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 26, 2015 at 04:37:56PM +0000, Pedro Alvarez wrote:
> Hi everyone.
> 
> I've had some problems trying to build ebtables with the v3.19 kernels headers,
> failing to build with the following error:
> 
> gcc -Wall -Wunused -Werror -fPIC -O3 -DPROGVERSION=\"2.0.10-4\"
> -DPROGNAME=\"ebtables\" -DPROGDATE=\"December\ 2011\"
> -D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50
> -DEBTD_CMDLINE_MAXLN=2048 -DLOCKFILE=\"/var/lib/ebtables/lock\"
> -DLOCKDIR=\"/var/lib/ebtables/\" -c -o extensions/ebt_ulog.o
> extensions/ebt_ulog.c -Iinclude/
> extensions/ebt_ulog.c:17:45: fatal error: linux/netfilter_bridge/ebt_ulog.h: No
> such file or directory
>  #include <linux/netfilter_bridge/ebt_ulog.h>
>                                              ^
> 
> After some discussion on IRC we agreed there were 2 possible solutions:
> 
>  -1: Disable 'ulog' in the extensions/Makefile
> 
>  -2: Cache the headers needed in the ebtables tree.
> 
> I decided to go for 2, and here is the patch:

Yes, we have to go 2 as we did in iptables.

>   Repo: git://git.baserock.org/delta/ebtables.git
>   Branch: baserock/pedroalvarez/ebt_ulog-fix
>   Sha1: 13747a56890cc710b2b4d420edc03a6c2714f40e
> 
> NOTE: I didn't want to send a diff, since it would be big and nonsense, but I
> can do that if needed.

OK, but it should be sufficient to include netfilter_bridge headers
for each supported extension, including types.h and filter.h as we do
in iptables.
