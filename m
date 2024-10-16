Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0E165EE6
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729106934; cv=none; b=o1FE5qKmnf2ETez7khbwCPzeZgbN3mKo11J+WTGCSkP2HPkmNYxg+jX30TZFmix5zM4n2VPJijsNUq42H+RZioBhDkQyWTtVmcVnwGbWLZFKPisYzrj+ha1XfzCJMXQGTxYKkFtVNbaCPX9IbhDPmRn5PnjppFHzAAvsnMqiTC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729106934; c=relaxed/simple;
	bh=Uh97zzBL0FYH/O/KNx1oE59mDNxvt07RCTSuSCi4GFg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sMwBNW4lnMeU4SYIcT/yd5hnLcj2N4YgDJNKt8PI8p5wZrefIiF8TrsaSXvkYJMkZIZMa1KH8ccCkRZnZAOZnR3lfEk+dfuvbxZaEg/RRZysvgQ3blEpDNUMQl3Lqq5IWpHSLGVOiHHb7PHPovPfMidc6N9s228MzCZ6VuUAcVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id CD2511003D14DE; Wed, 16 Oct 2024 21:28:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id CB8F11100A4396;
	Wed, 16 Oct 2024 21:28:46 +0200 (CEST)
Date: Wed, 16 Oct 2024 21:28:46 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC libnftnl/nft 0/5] nftables: indicate presence of unsupported
 netlink attributes
In-Reply-To: <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
Message-ID: <45r97p82-s222-1286-6636-25p3631qq10o@vanv.qr>
References: <20241007094943.7544-1-fw@strlen.de> <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2024-10-16 19:07, Phil Sutter wrote:
>On Mon, Oct 07, 2024 at 11:49:33AM +0200, Florian Westphal wrote:
>[...]
>> Extend libnftnl to also make an annotation when a known expression has
>> an unknown attribute included in the dump, then extend nftables to also
>> display this to the user.
>
>We must be careful with this and LIBVERSION updates. I'm looking at
>libnftnl-1.2.0 which gained support for NFTA_TABLE_OWNER,
>NFTA_SOCKET_LEVEL, etc. but did not update LIBVERSION at all - OK,
>that's probably a bug. But there is also libnftnl-1.1.9 with similar
>additions (NFTA_{DYNSET,SET,SET_ELEM}_EXPRESSIONS) and a LIBVERSION
>update in the compatible range (15:0:4 -> 16:0:5).

From 1.1.8 to 1.1.9, there were a bunch of function additions:

+void nftnl_expr_add_expr(struct nftnl_expr *expr, uint32_t type, struct nftnl_expr *e);
+int nftnl_expr_expr_foreach(const struct nftnl_expr *e,
+                           int (*cb)(struct nftnl_expr *e, void *data),
+                           void *data);

No such modifications (of this kind, or any stronger kind) were made between
1.1.9 to 1.2.0, hence there was no LIBVERSION update.

Expanding the enum{} generally does not change the ABI unless the underlying
type changes (which it did not in this instance).
