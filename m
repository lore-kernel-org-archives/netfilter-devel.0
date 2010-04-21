From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iprange: fix xt_iprange v0 parsing
Date: Wed, 21 Apr 2010 14:48:54 +0200
Message-ID: <4BCEF436.7040306@trash.net>
References: <1271851758-12108-1-git-send-email-bernat@luffy.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Vincent Bernat <bernat@luffy.cx>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40128 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DUMsz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:48:55 -0400
In-Reply-To: <1271851758-12108-1-git-send-email-bernat@luffy.cx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vincent Bernat wrote:
> iprange_parse() was incomplete and did not include parsed ranges into
> ipt_iprange_info structure resulting in always adding range
> 0.0.0.0-0.0.0.0 in the kernel.
> 
> Moreover, when using --dst-range, error messages may display
> --src-range instead. Fix this too.

Applied, thanks Vincent.
