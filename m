Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A19A1A5B93
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749055892; cv=none; b=LuTRVbtYOs4LfHNKlJNCb0ysqqr4l2m+uUxLcumE8J+cFOWs13PtdhBqpeQi8ppatore7X6tkqJ3cW1csguRIy65MrLvBLjF1c+uotkohm96/yHyiSL2RAnQ8oYqmfYWOdYPGd5ZLpXPPzLiLDS78S+g+vqwGHKYiRA2666XDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749055892; c=relaxed/simple;
	bh=6G2zl1hfrsQi5BmYyfmta83iO3nHbVqn9upbR8ASTaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a2uZjQy9iJTvm/gLtk6BO4B8d7KFjW114uSPJ7/Uh7pj8SVGBxuC2KvDjX908+jrzzK8h//ZOopnSBtHcLw9bsD/az6Bsk2TFrInH7jCAv5H2MMTz77JeffFQHzBAlhRnI/Cc8qLaGxer35/bQ1KjzFqkzquFxcZf/IeTwz/TyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZFPIiUhG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZFPIiUhG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1+knMWrsfQMcysWpxM3kkpjnzEnKMXHPuJ/+NsfOJBA=; b=ZFPIiUhGxe8JiLcx46mP2h4N4o
	CMHqLx9BV0la2ZTs5Q+M0YL47r2ucyJ72qXTlGAH1ntQrsO4i0PowkWRTTShWooJjq1P6BVAOb89l
	ggJkrqSRoznt6/hKmQy9IK03vo6y0Gh8RVi0iVWeahe5AAqtruErD9ZtNwArg+NfKhETXyCCiN9g3
	a+Vo6RaQwbk+cQ5/XfBF4Pv3+25z7k4pXp2VvyMhTAdU/MPQxvU/PxeMFuXiT2BSm9/63ya6DrlEE
	uU24LbmyBBYi7PiH0VqfbubkPbY1vbZKAGPeMjVmnGKxTJP3lxUSMy5cn5FCsuTZPTP/jnsCafTe5
	lDcGVlGA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMrKl-000000001Nh-3a6E;
	Wed, 04 Jun 2025 18:51:23 +0200
Date: Wed, 4 Jun 2025 18:51:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Folsk Pratima <folsk0pratima@cock.li>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Document anonymous chain creation
Message-ID: <aEB5i1l8C8-TK3vJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Folsk Pratima <folsk0pratima@cock.li>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20250604102915.4691ca8e@folsk0pratima.cock.li>
 <aEBPo-EAZA0_OSD7@orbyte.nwl.cc>
 <20250604154604.0af22103@folsk0pratima.cock.li>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h3AbvsgQjcua7Do2"
Content-Disposition: inline
In-Reply-To: <20250604154604.0af22103@folsk0pratima.cock.li>


--h3AbvsgQjcua7Do2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2025 at 03:46:04PM -0000, Folsk Pratima wrote:
> On Wed, 4 Jun 2025 15:52:35 +0200
> Phil Sutter <phil@nwl.cc> wrote:
> >Did you try requesting a user account?
> Frankly, I do not know how.

Oh, indeed. The main page merely states to send "comments" to
netfilter@vger.kernel.org list. I guess you could send diffs to page
source, but it's indeed pretty cumbersome.

Pablo, can we have moderated users? Or was moderation just too much
trouble?

> >you could add the missing documentation to nft man page and submit a
> >patch
> See the attachment.

Thanks! I think we need to update the synopsis as well. What do you
think of my extra (attached) to yours?

Cheers, Phil

--h3AbvsgQjcua7Do2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="extra.diff"

diff --git a/doc/statements.txt b/doc/statements.txt
index 79a01384660f6..6d9db011c3fa1 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -3,8 +3,12 @@ VERDICT STATEMENT
 The verdict statement alters control flow in the ruleset and issues policy decisions for packets.
 
 [verse]
+____
 {*accept* | *drop* | *queue* | *continue* | *return*}
-{*jump* | *goto*} 'chain'
+{*jump* | *goto*} 'CHAIN'
+
+'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
+____
 
 *accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
 
@@ -26,15 +30,20 @@ resumes with the next base chain hook, not the rule following the queue verdict.
 *return*:: Return from the current chain and continue evaluation at the
  next rule in the last chain. If issued in a base chain, it is equivalent to the
  base chain policy.
-*jump* 'chain':: Continue evaluation at the first rule in 'chain'. The current
+*jump* 'CHAIN':: Continue evaluation at the first rule in 'CHAIN'. The current
  position in the ruleset is pushed to a call stack and evaluation will continue
  there when the new chain is entirely evaluated or a *return* verdict is issued.
  In case an absolute verdict is issued by a rule in the chain, ruleset evaluation
  terminates immediately and the specific action is taken.
-*goto* 'chain':: Similar to *jump*, but the current position is not pushed to the
+*goto* 'CHAIN':: Similar to *jump*, but the current position is not pushed to the
  call stack, meaning that after the new chain evaluation will continue at the last
  chain instead of the one containing the goto statement.
 
+Note that an alternative to specifying the name of an existing, regular chain
+in 'CHAIN' is to specify an anonymous chain ad-hoc. Like with anonymous sets,
+it can't be referenced from another rule and will be removed along with the
+rule containing it.
+
 .Using verdict statements
 -------------------
 # process packets from eth0 and the internal network in from_lan

--h3AbvsgQjcua7Do2--
