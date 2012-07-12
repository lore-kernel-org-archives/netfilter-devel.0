From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re: [PATCH 2/2] extensions: add HMARK target
Date: Thu, 12 Jul 2012 09:34:45 +0200 (CEST)
Message-ID: <tqndgm6.047f943bd7060a4c2b179885c2c22c50@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:50772 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2GLHer convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:34:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo
[snip]
+static void HMARK_check(struct xt_fcheck_call *cb)
>+{
>+	if (!(cb->xflags & (1 << O_HMARK_MODULUS)))
>+		xtables_error(PARAMETER_PROBLEM, "--hmark-mod is mandatory");
>+	if (!(cb->xflags & (1 << O_HMARK_RND)))
>+		xtables_error(PARAMETER_PROBLEM, "--hmark-rnd is mandatory");

I don't think rnd should be mandatory, a default value is enough.
offset however should be mandatory.



