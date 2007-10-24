From: Philip Craig <philipc@snapgear.com>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 19:39:40 +1000
Message-ID: <471F12DC.8050508@snapgear.com>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0597.4030203@plouf.fr.eu.org> <471F0D18.1030606@snapgear.com> <471F0ED1.202@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:36519 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370AbXJXJdq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:33:46 -0400
In-Reply-To: <471F0ED1.202@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pascal Hambourg wrote:
> Sure, but what about packets that enter a bridged interface and then are 
> routed ?

It's not set for them either, they are still just routed packets.
Not sure I understand your question.  My original comment was that
because the packets are routed (even though they arrived on a bridge),
the bridged flag is not set, and so the --physdev-is-bridged option
would never match for that particular rule, and it simply isn't
possible to fix that rule to get the --physdev-out to work.

