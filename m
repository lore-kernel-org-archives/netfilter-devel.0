From: Florian Westphal <fw@strlen.de>
Subject: Re: ebtables issue in compat mode
Date: Sat, 3 May 2014 00:31:39 +0200
Message-ID: <20140502223139.GA3514@breakpoint.cc>
References: <CAJzFV37HK7J2W5uz8-zFZ-n80yYKvu8KmxWu8Dx2rzbzzLeZDw@mail.gmail.com>
 <20140501100229.GS31953@breakpoint.cc>
 <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Sharat Masetty <sharat04@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58974 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbaEBWbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 May 2014 18:31:41 -0400
Content-Disposition: inline
In-Reply-To: <CAJzFV37Vus34O9F+0ATW6s6-5=OgTBLAxJ1rC6_658x25dNWzw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sharat Masetty <sharat04@gmail.com> wrote:
> We are using a 3.10.0 kernel version which has CONFIG_COMPAT enabled.
> The ebtables version is 2.0.10-4.  This is arm 63/32 not x86.

FWIW i have no issues with 2.0.10-4 either (on x86), so its hard
for me to debug this since I don't have access to a aarch64/arm64
machine.

> Please let me know what to watch out for

My guess would be that ebt_size_mwt() in size_entry_mwt() fails
to account for some required padding.

You could #define DEBUG at the top of it and see the offset
fixup that it tries to make.

Should be fairly simple to build a ebtables64 binary
and check what the expected values should be.
