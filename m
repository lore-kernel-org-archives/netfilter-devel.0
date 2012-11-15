From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: bugzilla status?
Date: Thu, 15 Nov 2012 18:53:39 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211151849160.25666@nerf07.vanv.qr>
References: <1352663561.17852.140661152301329.78E9D920@webmail.messagingengine.com> <20121111205458.GA3804@1984> <1352668477.31926.140661152323369.5EA58239@webmail.messagingengine.com> <1352996137.12531.140661154073597.78868B19@webmail.messagingengine.com>
 <20121115162852.GA19709@1984> <alpine.LNX.2.01.1211151745550.24398@nerf07.vanv.qr> <1352998442.20620.140661154088857.003FBE7B@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: ar16@imapmail.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:43075 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768574Ab2KORxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:53:41 -0500
In-Reply-To: <1352998442.20620.140661154088857.003FBE7B@webmail.messagingengine.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-11-15 17:54, ar16@imapmail.org wrote:

>Jan,
>
>SInce we can't get to info ...
>On Opensuse, does the v1.4.16 iptables update fix this broken-logging
>issue?  I see you're the maintainer/bugzilla contact for the pkg.

In bug 782 which you referenced, it says the poster is using
commit 8db1044ba608a, which is around April 2012.

I cannot reproduce it with either 8db1044ba608a, 1.4.14 or 1.4.16.2. 
Which does not mean that there is not something...

Bug 774 was marked duplicate of 782.

