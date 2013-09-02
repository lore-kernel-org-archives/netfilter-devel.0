From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 0/2] ipset: rework extension handling to be more
 manageable.
Date: Mon, 2 Sep 2013 22:04:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309022153040.1199@blackhole.kfki.hu>
References: <1378065522-65492-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53123 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969Ab3IBUE4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:04:56 -0400
In-Reply-To: <1378065522-65492-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Oliver,

On Sun, 1 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> Earlier today I sent a patch that cleaned up the hash extension, not noticing
> that the bitmap family is in a similar state.
> 
> This series cleans up the code for both the hash and bitmap families. Patch 1 is
> identical to the one I sent earlier today but has a different commit message that
> specifically mentions that it applies to the hash family.
> 
> Oliver Smith (2):
>   netfilter: ipset: rework hash ext. handling to be more manageable.
>   netfilter: ipset: rework bitmap ext. handling to be more manageable.

[Instead of extending "enum ipset_cadt_flags", better rely on the 
existing "enum ip_set_extension".]

The set extensions in their current form (full unique structures defined 
in all combinations ) reached their limit from management point of view. 
So a cleanup should change it, with the goal of keeping the memory 
requirements to the same as present but opening up for more possible 
extensions.

One possible way is to use memory blobs where the first part is the base 
structure for a given type (like "struct hash_netnet4_elem"), and the set 
structure is extended with the offsets to the extensions in the blob next 
to the base structure. That involves a couple of castings and changing 
access to all extensions by pointers (that means some reorganizatiom for 
the timeout extension).

What do you think?

Best regards,
Jozsef
 
>  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   8 +-
>  kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  55 ++++++++++
>  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |  68 ++----------
>  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  63 ++---------
>  kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  57 +---------
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 121 ++++++++-------------
>  6 files changed, 129 insertions(+), 243 deletions(-)
> 
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
