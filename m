Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FB4713791A
	for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2024 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716219881; cv=none; b=P4g2Wcgth3/q4X5eKC3vkSmA7RA+xikJJ2ZsmSROsBlg29Dc7dbrTWHTq1u3qzqr+7sqPEhFUJ5/aWsWDLFMDIJIYgS2vvZ40aKsEU6ErSHY6iADvhB+YRxXBxfc9aeDq3IKkvy6ZEbyWrmVZo/Vb4WA+rX+xiuSk2rYKLWKVXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716219881; c=relaxed/simple;
	bh=Ch32079HY1ynMHNtT4scfht8Sv96oBGeu/eyJk9k+p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXRvj3E8LH88HP6EHPH+2qBOp2wJ9SL7Vw2dREMBDhUb1VQ4BKa3hSyWwqvsKk3yXNM1iCam00AvUnrpuQMpsYz3vwPGKGA0SC+Dqj76P0S2PkEt7Ry/MbWa/qm9+Wy0cxL4olkDrFP+UiG+Qxs+A7CtdPXYn3B0N86xdiC2RHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 20 May 2024 17:44:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <Zktv4TN-DPvCLCXZ@calendula>
References: <20240513220033.2874981-1-aojea@google.com>
 <Zkszmr7lNVte6iNu@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zkszmr7lNVte6iNu@calendula>

On Mon, May 20, 2024 at 01:27:22PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 13, 2024 at 10:00:31PM +0000, Antonio Ojea wrote:
> > Fixes the bug described in
> > https://bugzilla.netfilter.org/show_bug.cgi?id=1742
> > causing netfilter to drop SCTP packets when using
> > nfqueue and GSO due to incorrect checksum.
> > 
> > Patch 1 adds a new helper to process the sctp checksum
> > correctly.
> > 
> > Patch 2 adds a selftest regression test.
> 
> I am inclined to integrated this into nf.git, I will pick a Fixes: tag
> sufficiently old so -stable picks up.

I have to collapse this chunk, otherwise I hit one issue with missing
exported symbol. No need to resend, I will amend here. Just for the
record.

diff --git a/net/core/dev.c b/net/core/dev.c
index e1bb6d7856d9..e7d83b95e6cc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3384,6 +3384,7 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 out:
        return ret;
 }
+EXPORT_SYMBOL(skb_crc32c_csum_help);
 
 __be16 skb_network_protocol(struct sk_buff *skb, int *depth)
 {

ERROR: modpost: "skb_crc32c_csum_help" [net/netfilter/nfnetlink_queue.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:145: Module.symvers] Error
