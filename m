From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 09:47:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711290945110.22052@fbirervta.pbzchgretzou.qr>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp>
 <474E640F.4010401@trash.net> <200711290801.lAT81sf6014235@toshiba.co.jp>
 <Pine.LNX.4.64.0711290908240.22052@fbirervta.pbzchgretzou.qr>
 <474E77F6.8030003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41917 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbXK2Irf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:47:35 -0500
In-Reply-To: <474E77F6.8030003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 29 2007 09:27, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Nov 29 2007 17:01, Yasuyuki KOZAKAI wrote:
>> > >
>> > > $ git-svnimport -v -C nf.git http://svn.netfilter.org/netfilter
> I want to switch entirely, but first I have to manage to import the
> repository :)
>
The problem is you have a non-trivial repository layout, so
using above's git-svnimport is likely to be not enough.
