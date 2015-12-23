From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] extensions: libxt_MARK: Add translation to nft
Date: Wed, 23 Dec 2015 19:21:18 +0100
Message-ID: <20151223182118.GA19872@breakpoint.cc>
References: <20151223153353.GA17748@gmail.com>
 <CAKHNQQEqnUejMapByGwqr+Lhh5Q+Hsd=As9qeTHrEihQWDCW2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51812 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932282AbbLWSVU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 13:21:20 -0500
Content-Disposition: inline
In-Reply-To: <CAKHNQQEqnUejMapByGwqr+Lhh5Q+Hsd=As9qeTHrEihQWDCW2Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> I'm unsure if the options or-set, and-set are supported in nftables. I
> cannot find much about them. Please let me know if there are
> translations corresponding to these options as well, I'll send another
> patch then.

You have to combine another mark + binop, i.e.:

filter input mark set mark or 1
  [ meta load mark => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0xfffffffe ) ^ 0x00000001 ]
  [ meta set mark with reg 1 ]

i.e., load mark into register, or with 1 (or whatever),
then set new mark based on result.

Replace or with and to get --and-mark.
