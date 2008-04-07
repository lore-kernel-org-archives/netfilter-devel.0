From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct
 nf_conntrack_l3proto
Date: Mon, 7 Apr 2008 10:46:21 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804071034000.17722@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr> <47F8EAA6.1040406@trash.net> <alpine.LNX.1.10.0804061728040.16851@fbirervta.pbzchgretzou.qr> <47F8F39B.8060003@trash.net>
 <alpine.LNX.1.10.0804061803420.16851@fbirervta.pbzchgretzou.qr> <47F8F7EE.7010009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44101 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbYDGIqX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:46:23 -0400
In-Reply-To: <47F8F7EE.7010009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-04-06 18:18, Patrick McHardy wrote:
>
> I didn't, I'm saying the patches you've sent me are broken.
> The reason is probably "format=flawed", but thats up to
> you to figure out.
>
Thanks for pointing out. I was aware that format=flowed was used, and
actually, I used it ever since I showed up on the Internet, both PINE
as old as 4.61 (rpm says: Build Date: 19 March 2005) and ALPINE have
it enabled (or rather "do not send flowed" disabled). It did not seem to 
affect any of submissions over the years.

According to Pine help text, format=flawed only has effect when a
line has trailng space, thereby indicating that the mail reader may
reflow the paragraph or line or whatever.

But there are no trailing spaces in the patch I sent. In fact, because 
format=flowed is a client-side transformation (and in memory only!), 
sending mails with format=flawed should not cause anything special 
besides the Content-Type header indicating format=flowed. But what I see 
is that both Alpine and Pine mangle this message, for whatever reason; 
even .Mail/Sent has the broken one (when viewed with 'less') and I dunno 
why -- I guess time for a bugreport.
