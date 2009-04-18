From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: some unused netfilter config vars?
Date: Sat, 18 Apr 2009 10:25:01 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0904181024220.25584@localhost.localdomain>
References: <alpine.LFD.2.00.0904180909580.499@localhost.localdomain> <alpine.LSU.2.00.0904181624001.19265@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:59541 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbZDROZ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:25:59 -0400
In-Reply-To: <alpine.LSU.2.00.0904181624001.19265@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 18 Apr 2009, Jan Engelhardt wrote:

> On Saturday 2009-04-18 15:10, Robert P. J. Day wrote:
>
> >
> >===== IP_NF_MATCH_TTL
> >net/ipv4/netfilter/Kconfig:95:config IP_NF_MATCH_TTL
> >===== IP_NF_TARGET_TTL
> >net/ipv4/netfilter/Kconfig:325:config IP_NF_TARGET_TTL
> >===== IP6_NF_MATCH_HL
> >net/ipv6/netfilter/Kconfig:97:config IP6_NF_MATCH_HL
> >===== IP6_NF_TARGET_HL
> >net/ipv6/netfilter/Kconfig:133:config IP6_NF_TARGET_HL
> >
> >  nothing seems to refer to any of the above.
>
> The commit message stated why - compatibilityophobia ;-)

  ah, quite right ... my bad.  sorry.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
