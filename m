From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sat, 04 Apr 2015 14:30:40 +0200
Message-ID: <551FD970.7030105@ahsoftware.de>
References: <551FC211.6000907@ahsoftware.de> <1428145986-15421-1-git-send-email-holler@ahsoftware.de> <20150404115550.GA5832@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:57084 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbbDDMas (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2015 08:30:48 -0400
Received: from wandq.ahsoftware (p4FC37AA6.dip0.t-ipconnect.de [79.195.122.166])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id 1C4062C9C1C4
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2015 14:30:46 +0200 (CEST)
In-Reply-To: <20150404115550.GA5832@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 04.04.2015 um 13:55 schrieb Pablo Neira Ayuso:
> On Sat, Apr 04, 2015 at 01:13:06PM +0200, Alexander Holler wrote:
>> Context sensitive handling of "param-problem" and "redirect" is necessary
>> to allow usage of them as token or as string for icmp types.
> [...]
> 
> I think we need some evaluation step at scanner level. This new
> evaluation routine needs to understand the token semantics to set some
> context information.
> 
> "redirect"		{ return scanner_evaluate(ctx, REDIRECT); }
> 
> We have to catch up more use cases such as sets and concatenations. I
> started a patch here, a bit more generalized than this when you
> reported this problem (we actually already knew about it).
> 
> @Patrick, any better idea?

Hmm. Looks ambitious.

I've no idea if it's worse to spend the time to build a general solution
instead of doing it like I did. It looks like you want to build a state
machine inside that scanner_evaluate() which means you have to use it
for every token, if I've understood your idea correctly.

How many ambigious tokens do exist besides redirect and param-problem
for which I've now added a "mini state machine"?

Sorry, but I'm not actively following this project or the mailing lists,
and thus have no real overview over existing problems. I've just fixed a
problem I've encountered while switching some of my systems from
iptables to nftables.

Regards,

Alexander Holler
