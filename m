From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] NETFILTER:  Remove superfluous __KERNEL__ tests from
 unexported headers.
Date: Thu, 3 Apr 2008 11:18:57 -0400 (EDT)
Message-ID: <alpine.LFD.1.00.0804031118290.24383@localhost.localdomain>
References: <alpine.LFD.1.00.0804020946430.18913@localhost.localdomain> <47F4F344.602@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:37634 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926AbYDCPTB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:19:01 -0400
In-Reply-To: <47F4F344.602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 3 Apr 2008, Patrick McHardy wrote:

> Robert P. J. Day wrote:
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> >  include/linux/netfilter/nf_conntrack_h323.h      |    4 ----
> >  include/linux/netfilter/nf_conntrack_irc.h       |    3 ---
> >  include/linux/netfilter/nf_conntrack_pptp.h      |    3 ---
> >  include/linux/netfilter/nf_conntrack_proto_gre.h |    2 --
> >  include/linux/netfilter/nf_conntrack_sane.h      |    4 ----
> >  include/linux/netfilter/nf_conntrack_sip.h       |    2 --
> >  6 files changed, 18 deletions(-)
>
>
> Parts of almost all of these files will be exported at
> some point for ctnetlink, so for now I prefer to keep the
> __KERNEL__ guards.

no problem.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
