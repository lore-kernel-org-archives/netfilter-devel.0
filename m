From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Fri, 26 Apr 2013 12:30:18 +0200
Message-ID: <20130426103018.GF32324@breakpoint.cc>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-2-git-send-email-fw@strlen.de>
 <20130426013601.GA4510@localhost>
 <20130426073239.GD32324@breakpoint.cc>
 <20130426093708.GA3757@localhost>
 <20130426100247.GE32324@breakpoint.cc>
 <20130426101212.GA18251@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48937 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759299Ab3DZKaV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:30:21 -0400
Content-Disposition: inline
In-Reply-To: <20130426101212.GA18251@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Looks good, only missing some explanation in the doxygen documentation
> on the "csum not ready" thing.

Thanks. I amended it:

--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -639,6 +639,23 @@ int nfq_set_mode(struct nfq_q_handle *qh,
  * - NFQA_CFG_F_CONNTRACK (requires Linux kernel >= 3.6): the kernel will
  *   include the Connection Tracking system information.
  *
+ * - NFQA_CFG_F_GSO (requires Linux kernel >= 3.10): the kernel will
+ *   not normalize offload packets, i.e. your application will need to
+ *   be able to handle packets larger than the mtu (up to 64k).
+ *
+ *   If your application validates checksums (e.g., tcp checksum),
+ *   then you must also check if the NFQA_SKB_INFO attribute is present.
+ *   If it is, you need to test the NFQA_SKB_CSUMNOTREADY bit:
+ * \verbatim
+       if (attr[NFQA_SKB_INFO]) {
+               uint32_t info = ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO]));
+               if (info & NFQA_SKB_CSUMNOTREADY)
+                       validate_checksums = false;
+       }
+\endverbatim
+ *  if this bit is set, the layer 3/4 checksums of the packet appear incorrect,
+ *  but are not (because they will be corrected later by the kernel).
+ *
  * Here's a little code snippet to show how to use this API:
  * \verbatim

I'll wait for a couple of more days before pushing the patches to
give others a chance to review them.

Cheers,
Florian
