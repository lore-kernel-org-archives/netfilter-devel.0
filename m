From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-addons: match packets based on status of grsecurity
 RBAC
Date: Fri, 29 Oct 2010 14:55:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010291453480.2148@obet.zrqbmnf.qr>
References: <20101017135202.8AFEE148E1BC@opensource.dyc.edu> <alpine.LNX.2.01.1010181145360.18053@obet.zrqbmnf.qr> <4CBD7C2D.5090600@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pva@gentoo.org,
	hardened@gentoo.org, zbyniu@destrukcja.pl, spender@grsecurity.net,
	pageexec@freemail.hu
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41742 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0J2Mzo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:55:44 -0400
In-Reply-To: <4CBD7C2D.5090600@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-10-19 13:08, Anthony G. Basile wrote:
>On 10/18/2010 05:50 AM, Jan Engelhardt wrote:
>> On Sunday 2010-10-17 15:52, basile@opensource.dyc.edu wrote:
>> 
>>> This patch adds a module which is useful to users of
>>> grsecurity's RBAC system.  It matches packets based
>>> on whether RBAC is enabled or disabled.
>> 
>> Can you elaborate a bit on how this is useful in conjunction with 
>> rulesets? I could imagine it be used with LSM selctx'es for example, or 
>> another extension that tests for other RBAC attributes.
>
>The idea here is that when the RBAC rulesets are not being enforced, the
>system is more vulnerable and the user wants stricter firewall rules.
>When RBAC is being enforced, one can relax the firewall and access to
>services which are now better protected.  In practice this usually means
>allowing only access to some trusted IP(s) on boot before RBAC is turned on.

Thanks, I've put this into a branch that will be merged in time for the 
1.31 release.
