Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B19323182B
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 23:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017043; cv=none; b=ryMYwhHXKML7yzyOtjf6c/RRLm33P/B5AgvPDEJUmX1FrQrYT60p5QVTTJpJty1/p+Qlxi5JycIM9fiSGwdlUY010bjC84rtsH/ZJ05GONS9ocAkyIMAgAugqXuOSTJM9wp28olFrPlUM1Z2gIye3tpQX3tiK3/L9iELPZQPXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017043; c=relaxed/simple;
	bh=WGauY56LCdLOUz1HaHbF3NANB7Vc7sk7gIFQ2Xknv/8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=sy7X9fKw6/ZAk+3Vkwd62DRyCit4ueDaLa8l63bjyW7izWj3rRbkLJAs2xohdAmfVvyyhEJC/vcS6j97xtEbybWU7BqD5eRJQs6ADR0vOtYazIz9NJN71j44TIOkJ2IeHLvd+zfrc6hPxBIxktrErFT/VUrGitSvv2sZNrNSIzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iJ4VCsQJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iJ4VCsQJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iJ4VCsQJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iJ4VCsQJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E2EEB60276; Wed,  9 Jul 2025 01:23:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017038;
	bh=pxapU7VUoJfqX9DkJ69LspqskWoFBRk3HE9+6bktXwI=;
	h=From:To:Subject:Date:From;
	b=iJ4VCsQJx9BpIeMoL9tZn4FstqiNSCDNEa1lJVi4iVvjumBzc5p602X1TfdMHM+PY
	 toRQdjVr3G/8jJbTHgSGFm3vMThBHMCBE5v/uHsXenQDbV2ux1RQkKUZRyKicnkZtF
	 vLl3LuBki6BbPefi6xriI9rYh1VsyYYDjeVnvCCXYxpy9ulBvNi+9OOLrNicRYDX+C
	 w7lnyXqpxINCG9BlegRMsERjUpG99x6I3AhkGZkp0j5VC386/xSdqzgVMoh6s2DX/t
	 fbHdchWGfFe5mR3Toub+YEnYyFQdOugrz/RNZ1ribERiDRFkd5vHBf3xp2kZizCuON
	 YzeLS6qP/ApjQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 86A1260273
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 01:23:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017038;
	bh=pxapU7VUoJfqX9DkJ69LspqskWoFBRk3HE9+6bktXwI=;
	h=From:To:Subject:Date:From;
	b=iJ4VCsQJx9BpIeMoL9tZn4FstqiNSCDNEa1lJVi4iVvjumBzc5p602X1TfdMHM+PY
	 toRQdjVr3G/8jJbTHgSGFm3vMThBHMCBE5v/uHsXenQDbV2ux1RQkKUZRyKicnkZtF
	 vLl3LuBki6BbPefi6xriI9rYh1VsyYYDjeVnvCCXYxpy9ulBvNi+9OOLrNicRYDX+C
	 w7lnyXqpxINCG9BlegRMsERjUpG99x6I3AhkGZkp0j5VC386/xSdqzgVMoh6s2DX/t
	 fbHdchWGfFe5mR3Toub+YEnYyFQdOugrz/RNZ1ribERiDRFkd5vHBf3xp2kZizCuON
	 YzeLS6qP/ApjQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/4] detach concat, list and set expression layouts
Date: Wed,  9 Jul 2025 01:23:50 +0200
Message-Id: <20250708232354.2189045-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

These three expressions use the same layout but they have a different
purpose, it is better to split them in independent layouts.

The compound expression still remains in place, there, the initial
layout to store the list of expressions and size is still in the same
in these expressions.

The initial three patch address type confusions uncovered by patch
4/4 in this series.

This is implicitly reducing the size of one of the largest structs
in the union area of struct expr, still EXPR_SET_ELEM remains the
largest so no gain is achieved in this iteration.

Pablo Neira Ayuso (4):
  evaluate: mappings require set expression
  evaluate: validate set expression type before accessing flags
  src: convert set to list expression
  src: detach set, list and concatenation expression layout

 include/expression.h      |  22 ++++-
 src/cmd.c                 |   5 +-
 src/evaluate.c            | 185 ++++++++++++++++++++++++--------------
 src/expression.c          |  41 ++++-----
 src/intervals.c           |  80 ++++++++---------
 src/json.c                |  10 +--
 src/mergesort.c           |   2 +-
 src/mnl.c                 |  13 ++-
 src/monitor.c             |   2 +-
 src/netlink.c             |  26 +++---
 src/netlink_delinearize.c |  14 +--
 src/netlink_linearize.c   |   2 +-
 src/optimize.c            |  22 ++---
 src/parser_bison.y        |   2 +-
 src/parser_json.c         |   5 +-
 src/rule.c                |   4 +-
 src/segtree.c             |  22 ++---
 17 files changed, 261 insertions(+), 196 deletions(-)

-- 
2.30.2

