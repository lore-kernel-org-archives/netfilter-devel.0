Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE5C1D63CF
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 09:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745572684; cv=none; b=LCjD/YeJjB+mhz/e7MYEAIDvK3e50RO0qdf+DUH86YrKyIvLgW8lgaVhd2cxNCErT1c4if4dNDmmGR6VQ1NoM1cOV3j/eWuLjV9o+kWrN7ccRsnuTinSA5rbKSMUS8EzThnE54kSZ3u9Li/frrl7qzUOaFz68DP9Hj41X2fTc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745572684; c=relaxed/simple;
	bh=vs7jry8yc2jIoDNQmUoCChZ2/3buwqIJiwgIq43w2QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBoPrrlHYMxHxcTGfMYZdHOzl1tnUgyhT+SH/j6RAfgC13zVuZ5bd2RQvj8NnrRA+29+b1wcYXQm4KKbYQWAmiPNaGuRwNy7oK1SybD4COAdU+1o7zIwojyG7FG99Ldf2t6R7TN+i4AI8ryK3a8ulyiNGzTld3RQnMGCPNg1DXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v+SM3tvs; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fuRTiz8b; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v+SM3tvs";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fuRTiz8b"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 71FBC6068A; Fri, 25 Apr 2025 11:17:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745572679;
	bh=Ss2Ha1VQNbMCoMiKdvaI6jq4ejv3t2p1YjK7U1QMq90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v+SM3tvsjWeaXFcSto+GpP+RLiAMCJrPkEg/0KKcOLjx/muMIdTd4KyMMleddgoKR
	 SzCf3rePDJl5+WHN3GjTNlzp21vaqnx7bz4zyDNPx4qoc18Edc63RbZo7F9G7oNsGF
	 KIXsQ/MkH6HeKv7y+TRMh3fU3yvvT/n8tAshC26T7dirCSc90CD49DSz11wp6KI+/x
	 CIXPQb1FbAz42ym8NfZm27IVilcx060yMigMqc97Jhs049ywokDYMW6pj84UvQU5e2
	 P53uWssir8tNON98v68X4meKM1eBHAMmmz3PvNCfocwKzOQcBum18bqVuOPTnmqZg2
	 4auLajK0pVkYg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6EA856061E;
	Fri, 25 Apr 2025 11:17:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745572678;
	bh=Ss2Ha1VQNbMCoMiKdvaI6jq4ejv3t2p1YjK7U1QMq90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fuRTiz8b0TXQRLfIBU7WXuWDYm4VzzBmArUw15e3avpDx8KbI9cSKMTCq48+Yz3Mz
	 j+G65DOVLvEpc3uN0KrpWHdilrn9dY72NVUVhO/zqvpEZETQYbPkbDHm0sfY3EFElr
	 1Iy9cdCSqjOPUJemYKxGhQKwW15khNq3XPcdxdsbXk+5SdUv30kVZfpwLzE7C+7+6g
	 WDCd2yGjVZfAgDS//4L1KjXZTeLYhAFNnPxp+gq+vqxeVhdFZ7+gI5V5Bmt3TL9EQH
	 TXHDsyP0QTxPxTQLe0L+yBWK0H2b063YNbIm2o5R4vrF+zcvHF3Q8k6BqKP+pKSf+e
	 wMMOCMcBvQbMw==
Date: Fri, 25 Apr 2025 11:17:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Miao Wang <shankerwangmiao@gmail.com>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH iptables] extensions: libebt_redirect: prevent translation
Message-ID: <aAtTRLKeH9JkyKVQ@calendula>
References: <20250425-xlat-ebt-redir-v1-1-3e11a5925569@gmail.com>
 <aAtPd3QF-2v8TNCe@calendula>
 <37E09A07-36FE-4F90-AB3E-9DB5701B86CD@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37E09A07-36FE-4F90-AB3E-9DB5701B86CD@gmail.com>

On Fri, Apr 25, 2025 at 05:07:04PM +0800, Miao Wang wrote:
> 
> > 2025年4月25日 17:01，Pablo Neira Ayuso <pablo@netfilter.org> 写道：
> > 
> > On Fri, Apr 25, 2025 at 04:44:24PM +0800, Miao Wang via B4 Relay wrote:
> >> From: Miao Wang <shankerwangmiao@gmail.com>
> >> 
> >> The redirect target in ebtables do two things: 1. set skb->pkt_type to
> >> PACKET_HOST, and 2. set the destination mac address to the address of
> >> the receiving bridge device (when not used in BROUTING chain), or the
> >> receiving physical device (otherwise). However, the later cannot be
> >> implemented in nftables not given the translated mac address. So it is
> >> not appropriate to give a specious translation.
> >> 
> >> This patch adds xt target redirect to the translated nft rule, to ensure
> >> it cannot be later loaded by nft, to prevent possible misunderstanding.
> >> 
> >> Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
> >> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
> >> ---
> >> extensions/libebt_redirect.c      | 2 +-
> >> extensions/libebt_redirect.txlate | 6 +++---
> >> 2 files changed, 4 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
> >> index a44dbaec6cc8b12f20acd31dcb1360ac7245e349..83d2b576cea5ae625f3bdf667ad56fc57c1665d9 100644
> >> --- a/extensions/libebt_redirect.c
> >> +++ b/extensions/libebt_redirect.c
> >> @@ -77,7 +77,7 @@ static int brredir_xlate(struct xt_xlate *xl,
> >> {
> >> const struct ebt_redirect_info *red = (const void*)params->target->data;
> >> 
> >> - xt_xlate_add(xl, "meta pkttype set host");
> >> + xt_xlate_add(xl, "meta pkttype set host xt target redirect");
> >> if (red->target != EBT_CONTINUE)
> >> xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
> >> return 1;
> >> diff --git a/extensions/libebt_redirect.txlate b/extensions/libebt_redirect.txlate
> >> index d073ec774c4fa817e48422fb99aaf095dd9eab65..abafd8d15aef8349d29ad812a03f0ebeeaea118c 100644
> >> --- a/extensions/libebt_redirect.txlate
> >> +++ b/extensions/libebt_redirect.txlate
> >> @@ -1,8 +1,8 @@
> >> ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
> >> -nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host accept'
> >> +nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect accept'
> > 
> > this is not a working translation, I don't think this is leaving this
> > in a better situation than before.
> 
> Or can we fully remove the translation? The translation result is
> really misleading, because the result is a valid nft rule statement
> but cannot work as intended.

I suggest to remove it.

It should be possible to fix this by adding a new expression, eg. nft_dev
to retrieve information from a device.

        case NFT_DEV_BR_IN_DEV_ADDR:
                memcpy(..., br_port_get_rcu(xt_in(par))->br->dev->dev_addr, ...);
                break;
        case NFT_DEV_IN_DEV_ADDR:
                memcpy(..., br_port_get_rcu(xt_in(par))->br->dev->dev_addr, ...);
                break;

it should be easy to add a new expression to provide this. Then,
provide a translation.
