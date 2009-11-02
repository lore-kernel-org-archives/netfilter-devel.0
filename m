From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] xtables: deactivate intrapositional support
Date: Mon, 2 Nov 2009 19:59:08 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911021958480.18000@obet.zrqbmnf.qr>
References: <1256891969-18437-1-git-send-email-jengelh@medozas.de> <1256891969-18437-3-git-send-email-jengelh@medozas.de> <4AEF0636.6010604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38373 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbZKBS7F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:59:05 -0500
In-Reply-To: <4AEF0636.6010604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-11-02 17:17, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> In going to fix NF bug #611, "argv" would be needed in
>> xtables_check_inverse to set "optarg" to the right spot in case of an
>> intrapositional negation. Adding argv to the parameter list would
>> cause an API change, which I would like to avoid because it is
>> planned to be thrown out anyway.
>> 
>> So deactive intrapositional support now already, but leave the error
>> message (which has already been there for two releases). Slightly
>> adjust it, because some users have been wondering whether iptables
>> or they are at "fault".
>
>I'm worried that this is too early, two releases is not particulary
>long and I'd expect a lot of people haven't noticed the warning yet,
>especially on headless systems. Looking at bug #611, we've never
>claimed "-ptcp" would be supported, so this hardly justifies the
>risk IMO.
>
>At least this needs more discussion, I'd like to hear a few more
>opinions on this.
>
Given the ultimate shortage of developers on NF these days, I am unsure 
there are that many opinions left.
