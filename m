From: David Miller <davem@davemloft.net>
Subject: Re: [2.6.24][BUG] Compact code broken?
Date: Wed, 14 Nov 2007 15:42:47 -0800 (PST)
Message-ID: <20071114.154247.130153717.davem@davemloft.net>
References: <20071114212855.GA580@dreamland.darkstar.lan>
	<20071114.150029.144310383.davem@davemloft.net>
	<68676e00711141539k18fa900bj9016ee5dd72a71c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: kronos.it@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50394
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbXKNXms (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:42:48 -0500
In-Reply-To: <68676e00711141539k18fa900bj9016ee5dd72a71c4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Luca Tettamanti" <kronos.it@gmail.com>
Date: Thu, 15 Nov 2007 00:39:11 +0100

> On Nov 15, 2007 12:00 AM, David Miller <davem@davemloft.net> wrote:
> > From: Luca Tettamanti <kronos.it@gmail.com>
> > Date: Wed, 14 Nov 2007 22:28:55 +0100
> >
> > > Hello,
> > > I'm testing a 64bit kernel on my machine and I've found an issue with
> > > iptables (32 bit). Kernel is git current (9418d5dc).
> >
> > What platform?  x86?  powerpc?  sparc64?
> 
> x86

Ok, the userland pointer you provided seemed to be sign extended
to 64-bit, so there might be a pointer arithmetic bug in the
netfilter compat code somewhere.
