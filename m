From: Philip Craig <philipc@snapgear.com>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 19:15:04 +1000
Message-ID: <471F0D18.1030606@snapgear.com>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0597.4030203@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:35160 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752702AbXJXJJK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:09:10 -0400
In-Reply-To: <471F0597.4030203@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pascal Hambourg wrote:
> Do you mean that the "bridged" flag (or whatever way this is 
> implemented) is not reset when the packet is routed ? Doesn't this sound 
> like a bug ?

It's not set at all for routed packets, which is correct behaviour.

