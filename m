From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 12:43:10 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
References: <200805151421.23862.anton.vazir@gmail.com> <alpine.LNX.1.10.0805151125570.16151@fbirervta.pbzchgretzou.qr> <200805151535.31933.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34980 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYEOKnL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 06:43:11 -0400
In-Reply-To: <200805151535.31933.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-15 12:35, Anton wrote:
>> You missed IPMARK from Xtables-addons which does the
>> marking in O(1) instead of O(n).
>
>Great! This partially solves problem with marking while used 
>with shaper, but in global scope - iptables remains slow?

Slow, where?
