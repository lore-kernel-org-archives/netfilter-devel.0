Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC8D2C11E4
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2026 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786494619; cv=none; b=h7b8hja18h765I0QG2TttvJRdqurBL5MD68+kETUtr6peHnksbURsE/ukSBZ0hCmikYzyBf/Qawk39LJOyTSPGcMtv3c54w8RqV5D1/VuAVxIL4Sg8FmoQxPhlW54zHR0m1i/lylSObnEUjaArKd4t/0DYjk3PBsFs2/SV9Rclk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786494619; c=relaxed/simple;
	bh=uxrn58UdygRHqUBAHOyq9snOJTFjaE9eVr40nZZClrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkIYihscCkCi+Bgq4LEV7HLcpzPjFMxxjzHW54FsrX0soRZlfUSw0mxzAi/Wqv0qG9grahdh6p1TLp4dETRVCGw3MEoiLcWDmdW2zFDqhlNXULAJAVHzu3TiiKoYYZar688zqXuLUbAWiBiJT58BL6aL9sA9hLPbTPGTzuWRCc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OM2HWhtS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OM2HWhtS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786494614;
	bh=zDfJq8zDe6Ak9N2EBmZYw0bJIWVkaLemrUWPHNhP3CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OM2HWhtS901bTr1+QQUPpA2bxw1OpXeA3hgMKIWlkDN/vcJ4Hj/vzWZuWsPfnCnN4
	 IBkZhsxb5LsBOI+RI2KCQS4YsVzVeVzX1WQINdN4hyfLs6R07EiheFOo9zocf2q0lF
	 Q0ecu3WFLP8A1U6F0f4ClfI1rc78N7ijJeaUL9uGfO4IytDd+2TLTqM5DX2c9FM6eu
	 kTwHsbM6UhcChTUJTesEazXIJ6x0yCtWZD1KZEaycilvqQKZAMDarGQ0E2QbZ9sF8/
	 xFHw+WDryIj8kSBF+xCbLr60kvXFQDxWPv2343ki0hKsosPX/R+6Wf89TZz3L9JMU/
	 mgD3PfBChWiFQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 313036007B;
	Wed, 12 Aug 2026 02:30:14 +0200 (CEST)
Date: Wed, 12 Aug 2026 02:30:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit
 when building new ruleset
Message-ID: <anu-k2MbkI1Hx7zC@chamomile>
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
 <anRrLtZvlPXtqJAA@strlen.de>
 <anSe0eK9dl1d2J7-@chamomile>
 <anTMFbo6AB9IqejA@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <anTMFbo6AB9IqejA@strlen.de>

Hi Florian,

On Thu, Aug 06, 2026 at 08:01:57PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Why must the blob be rebuilt before stale node purge in rbtree case?
> > 
> > ... there is a gap between the ruleset blob is built and published and
> > the set .commit interface is called to publish the new version of the
> > rbtree/pipapo datastructure.
> > 
> > See:
> > https://lore.kernel.org/netfilter-devel/589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com/
> 
> Ah. That makes sense. So the problem is not rbtree specific.  Problem is
> that packets switch over to the *new base chain* (linked to nf machinery,
> nft rule blob becomes reachable on base_seq swap:
> 
> 1. commit phase starts.
> 2. seqcount gets bumped.
>  A.  	Packet p1 enters machinery
> 3. elements get purged / chains / tables unlinked, netlink notificatons
>    etc. etc.
>  B.     Packet p1 is in nft_lookup, which gets updated base_seq,
>         but no match because rbtree blob resp. pipapo live blob
> 	are empty in the 'flush ruleset; table t { ..' case.
> 4. nft_set_commit_update() is called.

Yes. The empty set is exposed to the packet path for a short time span,
until nft_set_commit_update() is called.

> If the above is right your patch makes much more sense now :-)
> 
> The logic with (set->ops->abort_skip_removal && early_commit)
> however is hard to grasp.

I can add a specific .early_commit in v3 as Fernando suggested.

> Even with NFT_COMMIT_PHASE_EARLY or whatever its bad because
> the set implementation details leak into the transaction phase.
> But I understand that you'd like to at least solve it for rbtree
> with a smaller change, so thats ok.
>
> Is there a long-term plan?
>
> Maybe your 'pre-commit' phase could iterate the transaction
> log and relink transactions (add/del/update of set elements
> ) to the owning set?  Contradicting transactions (destroy set x,
> then remove element from x) should have been caught earlier, so
> this delete-from-transaction-log-and-link-to-per-set-struct should
> not be a problem.  Perhaps we might see issues with changes in the
> netlink reporting order... but thats hopefully easy to avoid.
>
> the ->commit() callback could then access the pending transactions
> for the set (element adds/deletes) and always get invoked early.
>
> Pipapo could walk its specific elem deletions internally, then swap.
> 
> The only other issue I see is that we need a second
> list_for_each_entry_safe(trans, next, &nft_net->commit_list, list)
> 
> ... walk, because the step-1 walk is allowed to fail.

I was considering to address this from the pipapo datastructure itself.
The idea would be similar to what the rbtree does, which is to offer a
front-end pipapo datastructure that is exposed to control plane that can
be updated under the commit mutex and that is not exposed to packet
path. Then use it from this new .early_commit interface to clone it,
then publish the new version and release the stale via RCU.

Same approach for the bitmap set.

As for the non-rhashtable version, it could be possible to build a
compact hashtable based on the control plane datastructure, ie.
rhashtable would be only used for control plane and a compact hashtable
(using array for buckets and chains) will be built from the new
.early_commit interface to publish to datapath.

Exception are dynsets, where a single rhashtable can be used, both to
control and datapath.
