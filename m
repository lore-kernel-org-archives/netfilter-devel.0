Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76269204088
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741214465; cv=none; b=PIYrJ5YhRHAq5tiwvhhqkkz6ir1uu9uGtTnU2G44OU+45uzN6RMT9r6QBzO3H8LpDv1aL5kXN+4Og7tML1N1U3E3Phpc1Oo+H6NZQ8dpVc5iAACqonsaxLObgqxYscpyTvm0esviKv9OPoxG4n2O/t1HrGvpn71IjM1Kmn+cBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741214465; c=relaxed/simple;
	bh=Xmrkvz1sNlpTjOif2bMLARjCxEFc7wiMjWgLnuZ9qDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmjgDj30md4CyxPELWzLo3/eZnlKCJakJh9TidFdOoFU8Sy1RyA3tLIDF9O1R17+ZmgBcm5WZXE6r4+sJ2bsCJFOpzg6gv0QJe2V5UactyrsuThP1gUr254XE9NGhAfMGVYa5+91FTmU+HVY5zvlekr55MmMQqebaU4h7getBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZoSuGLoz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZoSuGLoz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZoSuGLoz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZoSuGLoz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A662A6030E; Wed,  5 Mar 2025 23:41:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741214461;
	bh=s7SvPxCDIlLhOn18U1V795OfvPmBQTaL2PZbFKbwyiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZoSuGLozAwZzJULgVNXga7XOhvB4GLiR7AFCIMIFUQK51Ei7aQ5YvCOqlMe1fibWG
	 fCJZEdM2nSE9KM0BtmDikPt7JBuNXKumepYt76HPts/JrJh1rv8rTeUHo0x/Gm2Iwb
	 demKZJmdPi6ENs7h9//fBYScJ0GE5X+YNnh7vYzgVWCLU4bCs74/83F3bUD0WUA0X4
	 KO3CA3i7va5FIqQPCLKtGNoqzWl2ZdiqBeYTEY02p26MODB2RYeDn2lYp1dmLMnfmC
	 c0onDl01GZO/l88kOGz9plg2bo7lf0+bi4CkWtSMixuoLNWR3mlW7DNbDdBTitApDO
	 y+dZAjtJRSoZQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 00C066030A;
	Wed,  5 Mar 2025 23:41:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741214461;
	bh=s7SvPxCDIlLhOn18U1V795OfvPmBQTaL2PZbFKbwyiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZoSuGLozAwZzJULgVNXga7XOhvB4GLiR7AFCIMIFUQK51Ei7aQ5YvCOqlMe1fibWG
	 fCJZEdM2nSE9KM0BtmDikPt7JBuNXKumepYt76HPts/JrJh1rv8rTeUHo0x/Gm2Iwb
	 demKZJmdPi6ENs7h9//fBYScJ0GE5X+YNnh7vYzgVWCLU4bCs74/83F3bUD0WUA0X4
	 KO3CA3i7va5FIqQPCLKtGNoqzWl2ZdiqBeYTEY02p26MODB2RYeDn2lYp1dmLMnfmC
	 c0onDl01GZO/l88kOGz9plg2bo7lf0+bi4CkWtSMixuoLNWR3mlW7DNbDdBTitApDO
	 y+dZAjtJRSoZQ==
Date: Wed, 5 Mar 2025 23:40:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/4] add mptcp suboption mnemonics
Message-ID: <Z8jS-nJzt_6yaq54@calendula>
References: <20250227145214.27730-1-fw@strlen.de>
 <Z8i8HoNQwtif911v@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rZItABNBAxlu+kVR"
Content-Disposition: inline
In-Reply-To: <Z8i8HoNQwtif911v@calendula>


--rZItABNBAxlu+kVR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Mar 05, 2025 at 10:03:28PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 27, 2025 at 03:52:06PM +0100, Florian Westphal wrote:
> > Allow users to do
> >   tcp option mptcp subtype mp-capable
> > 
> > instead of having to use the raw values described in rfc8684.
> > 
> > First patch adds this, rest of the patches resolve printing issues
> > when the mptcp option match is used in sets and concatenations.
> 
> For this series.
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

BTW, maybe add this too?

--rZItABNBAxlu+kVR
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="mptcp.patch"

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 2a155aa87b6f..c363ba355138 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -735,7 +735,7 @@ nftables currently supports matching (finding) a given ipv6 extension header, TC
 The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
 [verse]
 *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
-*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
+*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp* | *mptcp*}
 *ip option* { lsrr | ra | rr | ssrr }
 *dccp option* 'dccp_option_type'
 
@@ -794,6 +794,9 @@ length, left, right
 |timestamp|
 TCP Timestamps |
 length, tsval, tsecr
+|mptcp|
+MPTCP Option Subtype |
+subtype
 |============================
 
 TCP option matching also supports raw expression syntax to access arbitrary options:

--rZItABNBAxlu+kVR--
