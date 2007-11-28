From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables release
Date: Wed, 28 Nov 2007 18:49:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711281848440.16364@fbirervta.pbzchgretzou.qr>
References: <474C4B67.3000200@trash.net> <Pine.LNX.4.64.0711271942330.20371@fbirervta.pbzchgretzou.qr>
 <474C6A22.9080202@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39160 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXK1Rte (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:49:34 -0500
In-Reply-To: <474C6A22.9080202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 27 2007 20:04, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Nov 27 2007 17:52, Patrick McHardy wrote:
>> > I have a large number of pending patches for iptables for new
>> > matches and targets. I'm not going apply patches for new things
>> > unless they are at least in a -rc kernel, so we have a chance to
>> > fix mistakes. So my question is whether we're ready to release
>> > the current iptables -rc anytime soon (before/when 2.6.24 is
>> > released) or whether we're more likely going to need until 2.6.25,
>> > in which case I would apply them now.
>> >
>> > Any opinions?
>> 
>> Apply now, make an rc2 (maybe?),
>> apply more gems (coming), target 2.6.25,
>> be done :-)
>
> I'm aiming for one release per kernel release to get new stuff
> out in time for testing. Unfortunately we're already way behind,
> so I'd prefer an earlier release than 2.6.25. My feeling is that
> the current -rc works well, so if nobody is aware of any big
> issues, I think we should release the current version in a few
> weeks when 2.6.24 comes out.
>
I have pushed out (as patches) everything I wanted to, so it is
now up to you what to cherry-pick. The autoconf one might get a
little last tweaking once the .*-test situation is clear. I'd
just import ipt_condition.h and so to fix it.
