Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6FA1758B
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 17:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753810700; cv=none; b=TmnUmBMigUKj6TRx+FzQN1iZ4nZfvxhxwM6kAGTtWLNDRN5azsh91w+c1BllOoLhoE5Ky31+eNBvRa4U8vjRB11Xv8YU+ylI6G3UN3y8JRL9hTlHJr3DSza088H8J7cmF7CVN+VMIJtt24taMMX66dUmdvZGbfqc2D74UbMwwG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753810700; c=relaxed/simple;
	bh=zuQa1E/sYBgGqf3G3KwyT63Ktt/YukOkhb2MLm0A5gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdzmVLmDByHOa4h40AtfWq74AQeLGygctvqPQLsjKyTe2GqydVGRBQVcvU0ye/JxFLccSOx1OYA0YHlhRW5hasc8TfF6lkVrZMGTj/bTAQlf5lw6qH5rDObwXj/rIGGq7NG6Q+yYyN1fv+ijAQMvxX+mQxxW32lwcXY8k9JDCoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0CF596101D; Tue, 29 Jul 2025 19:38:14 +0200 (CEST)
Date: Tue, 29 Jul 2025 19:38:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Dan Moulding <dan@danm.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Message-ID: <aIkHAZjudod05WaR@strlen.de>
References: <aIgMKCuhag2snagZ@strlen.de>
 <20250729170228.7286-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729170228.7286-1-dan@danm.net>

Dan Moulding <dan@danm.net> wrote:
> Ok. I just tried reverting only the changes to nf_conntrack_core.c and
> the hang no longer occurs. This is on top of 6.16.

Strange.  Can you completely revert 2d72afb340657f03f7261e9243b44457a9228ac7
and then apply this patch instead?

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -984,6 +984,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
        struct nf_conn_tstamp *tstamp;

        refcount_inc(&ct->ct_general.use);
+       ct->status |= IPS_CONFIRMED;

        /* set conntrack timestamp, if enabled. */
        tstamp = nf_conn_tstamp_find(ct);
@@ -1260,8 +1261,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
         * user context, else we insert an already 'dead' hash, blocking
         * further use of that particular connection -JM.
         */
-       ct->status |= IPS_CONFIRMED;
-
        if (unlikely(nf_ct_is_dying(ct))) {
                NF_CT_STAT_INC(net, insert_failed);
                goto dying;



(the confirm-bit-set moves from the too-early spot in __nf_conntrack_confirm
 to __nf_conntrack_insert_prepare).

Unlike 2d72afb340657f03f7261e9243b44457a9228ac7 its still set before
hash insertion, but we no longer set it on entries that were not
inserted into the hash.

Unfortunately I still do not see why setting the bit after hashtable
insertion causes problems.  ____nf_conntrack_find() should skip/ignore
the entry, and I don't see how it causes an infinite loop or
double-insert or whatever else is causing this hang.
