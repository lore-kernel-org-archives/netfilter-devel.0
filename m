From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 2/2] ipset: add userspace support for forceadd
Date: Fri, 28 Feb 2014 10:25:14 +0100
Message-ID: <20140228092514.GA4011@localhost>
References: <1393542286-20955-1-git-send-email-johunt@akamai.com>
 <1393542286-20955-3-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53260 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaB1JZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:25:24 -0500
Content-Disposition: inline
In-Reply-To: <1393542286-20955-3-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 06:04:46PM -0500, Josh Hunt wrote:
> The userspace side of the forceadd changes.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  Make_global.am              |    2 +-
>  include/libipset/data.h     |    4 +-
>  lib/data.c                  |    6 ++
>  lib/ipset_hash_ip.c         |  123 +++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipmark.c     |  142 ++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipport.c     |  147 +++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipportip.c   |  158 ++++++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipportnet.c  |  169 +++++++++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_net.c        |  119 ++++++++++++++++++++++++++++++
>  lib/ipset_hash_netiface.c   |  125 ++++++++++++++++++++++++++++++++
>  lib/ipset_hash_netnet.c     |  125 ++++++++++++++++++++++++++++++++
>  lib/ipset_hash_netport.c    |  132 +++++++++++++++++++++++++++++++++
>  lib/ipset_hash_netportnet.c |  149 ++++++++++++++++++++++++++++++++++++++
>  src/ipset.8                 |    7 ++
>  14 files changed, 1406 insertions(+), 2 deletions(-)
> 
> diff --git a/Make_global.am b/Make_global.am
> index f931618..1151714 100644
> --- a/Make_global.am
> +++ b/Make_global.am
> @@ -69,7 +69,7 @@
>  # interface. 
>  
>  #            curr:rev:age
> -LIBVERSION = 5:0:3
> +LIBVERSION = 6:0:1

I think this should be:

6:0:4 if you just added somes interfaces while retaining backward
compatibility.

or

6:0:0 if you removed interfaces (thus, backward compatibility is not
retained).
