From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 10:19:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711291018450.22052@fbirervta.pbzchgretzou.qr>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp>
 <474E640F.4010401@trash.net> <200711290801.lAT81sf6014235@toshiba.co.jp>
 <Pine.LNX.4.64.0711290908240.22052@fbirervta.pbzchgretzou.qr>
 <474E77F6.8030003@trash.net> <Pine.LNX.4.64.0711290945110.22052@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711291005050.22052@fbirervta.pbzchgretzou.qr>
 <474E82C1.3050905@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33873 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbXK2JTI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:19:08 -0500
In-Reply-To: <474E82C1.3050905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 29 2007 10:13, Patrick McHardy wrote:
>> 
>> Also, there currently exist /trunk/PROJECTNAME. If that were to be
>> imported into git, I would not be sure whether you can tag single
>> projects like in svn .. in git it seems like just the whole tree.
>> Trying to tag v1.4.0 would then also include libnfconntrack and
>> friends in the tag - not good.
>
>
> We could use sepate git repositories for that, shouldn't be
> a big problem.
>

Just start a new git repo without importing anything.
