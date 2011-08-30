From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: kernel BUG at net/netfilter/ipset/ip_set_core.c:314
Date: Tue, 30 Aug 2011 15:59:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108301556050.26239@blackhole.kfki.hu>
References: <4E5CA623.9000402@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38630 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1H3N71 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:59:27 -0400
In-Reply-To: <4E5CA623.9000402@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 30 Aug 2011, Jean-Philippe Menil wrote:

> With the set bitmap ipmac, if i had one, two hundred ip,mac in a set; and do
> an ipset list,
> i get an:
> ipset v6.8: Kernel error received: No buffer space available
> followed by a kernel panic (trace attached).

If possible, could you stress-test the case with the patch below applied?

If there was a dumping error in the middle, the set-specific variable was 
not zeroed out and thus the 'done' function of the dumping wrongly tried 
to release the already released reference of the set.

diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index b5d380c..c3eabfd 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -1148,6 +1148,7 @@ release_refcount:
 	if (ret || !cb->args[2]) {
 		pr_debug("release set %s\n", ip_set_list[index]->name);
 		ip_set_put_byindex(index);
+		cb->args[2] = 0;
 	}
 out:
 	if (nlh) {

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
