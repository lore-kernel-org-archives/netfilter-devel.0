Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AACE1FC0F3
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 10:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743590182; cv=none; b=I/jNbyNnmf0HvV+7W+EobSeHb0E9F3GhC6kK+M0z2uBL/ZlHOTPzPBxWoYhFS3k9vMzw0fQVVq+LvebG1XEP/djr0fPo5F34qhqPkJmU9co8VC9M6sLQrfolFxxtxlEPZSNwrXUqT6cOzlxx5k4Lyh+8nEVqoWC0f4yQRLtoBnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743590182; c=relaxed/simple;
	bh=s+1K1fTMIf7ZizJrtZAlFq1GMC2E7FzicK7sUgPeCls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jsn5X+7ZVxXD1siy8zot9Wy4AIcsJhTgNK5ckNiCCdLHKgXS1fflM401nrohIJXrRDSVr8LR2x5ufU7Oi/FUNfzbNj8cSST/9KCyxtsFELrqR80g1oURVDtlt9wigcfsCykrgjepyzyRBF69BVXgNsGhl2YiuDkKBSztW+V0aSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kwJK1cOp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vM9MSG1j; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kwJK1cOp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vM9MSG1j"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 46C1D605F2; Wed,  2 Apr 2025 12:36:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743590176;
	bh=nXrg9zHM30G/LNDQ7B+Y3PdMr1Yc568/d414UyQV8HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kwJK1cOpE/NnX3JU31TEHtgetT5BmQsJ2AJw5ZX5Fw2jUEp+Z+NVBIF1M/Gmha4FK
	 F1kiSa0iwKgLW8nJCo141Sk0cl19A7s9nhnOaX3j0kPBKEG3/my2FnXemkx6EDYQmr
	 J4sYIFX38nRF5JPXX3j0jItkeNiMk6EnyEwcG9XzObKfSDjKRbMfpQXoQ3QACmOk2O
	 fhFmjx98LSCylU4gjKMX4UMiO0iOFgnjMPYawEjSeYgKO9g0pR8JzrEPPc/5l6n1dE
	 3SFDCo1JDlgLfNdkWv13Bd1Tm6rT3wWw7+oKRNjSFuWm97IBDukkxDaG+3j/DNpjL8
	 YlTtEt3ri9r3w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 15ECE605F2;
	Wed,  2 Apr 2025 12:36:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743590175;
	bh=nXrg9zHM30G/LNDQ7B+Y3PdMr1Yc568/d414UyQV8HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vM9MSG1jjaFgx60UWHnV+vYZ0kY1Pye6YdQX5L5pldEfkG09wEGtNpcL9WCjD9jFx
	 wYXCgkaxi0jlz96QDJRSDFPkY09jB+0bs39hg4jfX700NPRQ6l1vHYbwZq/y2MUPYa
	 ACJ6L0sCGd2zLT1LN3Asl5iV3H/Lqa488lvSU6z3MtSoYdBNdmBht94P6Ux9BLMn+H
	 rpVIazJh9z6B/GAVLF3r2Ssoa1mvWGsYXPT6qChbupgMDZX0qjfyBNJ8XieCMM/BDQ
	 M1i0/bolZd4wBgCtP8PvqNqAkzVuX6ZQ8NJFUPA0OQcyc+9VmysySq/cJSe+Wrv0Ow
	 r10Lv0ZF/cfXQ==
Date: Wed, 2 Apr 2025 12:36:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: don't unregister hook when
 table is dormant
Message-ID: <Z-0THLCSy917XRq0@calendula>
References: <20250401123651.29379-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250401123651.29379-1-fw@strlen.de>

Hi Florian,

On Tue, Apr 01, 2025 at 02:36:47PM +0200, Florian Westphal wrote:
> When nf_tables_updchain encounters an error, hook registration needs to
> be rolled back.
> 
> This should only be done if the hook has been registered, which won't
> happen when the table is flagged as dormant (inactive).
> 
> Just move the assignment into the registration block.

I just made another pass today on this, I think this needs to be:

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2df81b7e950..a133e1c175ce 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2839,11 +2839,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
                        err = nft_netdev_register_hooks(ctx->net, &hook.list);
                        if (err < 0)
                                goto err_hooks;
+
+                       unregister = true;
                }
        }
 
-       unregister = true;
-
        if (nla[NFTA_CHAIN_COUNTERS]) {
                if (!nft_is_base_chain(chain)) {
                        err = -EOPNOTSUPP;

This is the rationale:

- only updchain allows for adding new basechains for netdev family,
  this is to add new devices to this netdev basechain.
- !netdev families only check if the hook is the same in the chain
  update. Otherwise, it reports EEXIST. That is, chain update of
  !netdev families is not possible.

I am moving "unregister = true" under this check:

  if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {

only in this case hook registrations can happen. Then, in case of
error, unwind only applies if basechain's family is netdev.
