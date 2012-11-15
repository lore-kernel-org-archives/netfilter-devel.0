From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: bugzilla status?
Date: Thu, 15 Nov 2012 19:14:20 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211151913210.6791@nerf07.vanv.qr>
References: <1352663561.17852.140661152301329.78E9D920@webmail.messagingengine.com> <20121111205458.GA3804@1984> <1352668477.31926.140661152323369.5EA58239@webmail.messagingengine.com> <1352996137.12531.140661154073597.78868B19@webmail.messagingengine.com>
 <20121115162852.GA19709@1984> <alpine.LNX.2.01.1211151745550.24398@nerf07.vanv.qr> <1352998442.20620.140661154088857.003FBE7B@webmail.messagingengine.com> <alpine.LNX.2.01.1211151849160.25666@nerf07.vanv.qr>
 <1353002359.2736.140661154114333.7899D355@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: ar16@imapmail.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:43161 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768630Ab2KOSOV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:14:21 -0500
In-Reply-To: <1353002359.2736.140661154114333.7899D355@webmail.messagingengine.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-11-15 18:59, ar16@imapmail.org wrote:

>atm i can faithfully reproduce it with 1.4.14 on any/all of my Opensuse
>12.2 boxes.

Well, as Pablo indicated (the linked Debian reports from bug 782) also 
show that this has already been fixed.

>otoh, 1.4.16 from netfilter:security causes me to hit this:
>https://bugs.launchpad.net/ufw/+bug/1065297
>
>trying to figure out what to do about THAT one ...

perl -i -pe 's{-m state --state}{-m conntrack --ctstate}g' my.rules
