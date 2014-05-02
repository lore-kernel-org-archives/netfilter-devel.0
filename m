From: Florian Westphal <fw@strlen.de>
Subject: Re: ebtables issue in compat mode
Date: Sat, 3 May 2014 00:37:57 +0200
Message-ID: <20140502223757.GB3514@breakpoint.cc>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
 <20140501100229.GS31953@breakpoint.cc>
 <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
 <20140502223139.GA3514@breakpoint.cc>
 <alpine.LSU.2.11.1405030032510.21781@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Sharat Masetty <sharat04@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58994 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbaEBWh7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 May 2014 18:37:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405030032510.21781@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Saturday 2014-05-03 00:31, Florian Westphal wrote:
> 
> >Sharat Masetty <sharat04@gmail.com> wrote:
> >> We are using a 3.10.0 kernel version which has CONFIG_COMPAT enabled.
> >> The ebtables version is 2.0.10-4.  This is arm 63/32 not x86.
> >
> >FWIW i have no issues with 2.0.10-4 either (on x86), so its hard
> >for me to debug this since I don't have access to a aarch64/arm64
> >machine.
> 
> This has occurred so regularly now that it's likely to be one and the 
> same ABI issue all again where some user has more than 2 ABIs in the 
> system.

I must have missed something, what are you refering to?
