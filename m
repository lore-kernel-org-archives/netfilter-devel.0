Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D114174A;
	Fri, 22 Mar 2024 12:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711110475; cv=none; b=t3C/AoJiFIgjhWiEEK1hDZSVq7hYc8QSFh8k2jG5GqIzEQgV8LQ2B+RoZ5KbiO6QMqDFLt/hdeUhtVVuIPix9hUxtJj9rLEH5Dh/OD0uDeNDoGcr317XfyuAlCHasj/j2/ZtQxQ7jB6BEGd4VOEiNspWkOkF+ikRbMHXnmdzgFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711110475; c=relaxed/simple;
	bh=POylI2exnghnVAhQzrav6+u5Od2WnLYhT5aCJPju1sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llKRUeah6owSb+WN6AIdmseW6r2hqFbJctGYYn3+SHXoD26+z8xKA7xPnGrg8ZWsr0qyZ6sSGRE2xNtaCWt+DTM6ePbKYrhm9M62arKeqjxHSma2bgsQ34Spbe2ZYdNpo+/tzBYndno5jl14GVGtnD1uF7KJ29uRhIQsse6QhlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 22 Mar 2024 13:27:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jianbo Liu <jianbol@nvidia.com>
Cc: "fw@strlen.de" <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Message-ID: <Zf15Ni8CuRLNnBAJ@calendula>
References: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NRNaLYY0vieban2T"
Content-Disposition: inline
In-Reply-To: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>


--NRNaLYY0vieban2T
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Jianbo,

On Mon, Mar 18, 2024 at 09:41:46AM +0000, Jianbo Liu wrote:
> Hi Florian and Pablo,
> 
> We hit the following warning from br_nf_local_in+0x157/0x180.

Can you give a try to this patch?

This fix is not yet complete but it should fix the splat for this
test.

Thanks.

--NRNaLYY0vieban2T
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 35e10c5a766d..085d3f751b3f 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -612,6 +612,13 @@ static unsigned int br_nf_local_in(void *priv,
 	if (likely(nf_ct_is_confirmed(ct)))
 		return NF_ACCEPT;
 
+	if (skb->pkt_type != PACKET_BROADCAST &&
+	    skb->pkt_type != PACKET_MULTICAST) {
+		skb->_nfct = 0ul;
+		nf_conntrack_put(nfct);
+		return NF_ACCEPT;
+	}
+
 	WARN_ON_ONCE(skb_shared(skb));
 	WARN_ON_ONCE(refcount_read(&nfct->use) != 1);
 

--NRNaLYY0vieban2T--
