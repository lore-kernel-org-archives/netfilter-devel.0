From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: TPROXY / DIVERT
Date: Sun, 12 Jul 2009 19:17:02 +0200
Message-ID: <20090712171702.GA1668@sch.bme.hu>
References: <4A543BB2.5080906@treenet.co.nz> <4A572C20.8020807@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:43488 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZGLRRG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jul 2009 13:17:06 -0400
Content-Disposition: inline
In-Reply-To: <4A572C20.8020807@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Jul 10, 2009 at 11:55:12PM +1200, Amos Jeffries wrote:
> Amos Jeffries wrote:
> >TPROXY is turning out alright for most of our users. The iptables and 
> >kernel changes seem to work perfectly. Thanks a lot guys.
> >
> >We are just working our way through how it needs to fit into various 
> >other network toolchains and re-documenting.
> >
> >
> >Two netfilter relevant questions have arisen:
> >
> >The old one: How long until IPv6 TPROXY support is available?
> >
> >
> >The new one: How to configure TPROXY on a bridge?
> >
> 
> Alright Nevermind the bridge Q. has been resolved now.

Cool. What was the problem?

> The IPv6 Q. is still open. hint, hint :)

As far as I know noone is working on this. Theoretically, shouldn't be too
complicated, though.

I'll try to look into this once I find the time.

-- 
KOVACS Krisztian
