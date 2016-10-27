From: Florian Westphal <fw@strlen.de>
Subject: Re: NFTables Internals
Date: Thu, 27 Oct 2016 18:29:41 +0200
Message-ID: <20161027162941.GC23011@breakpoint.cc>
References: <CAChgv6pe8mrMRgYhzmiTSQ9dC5d1shp8j_RpU2Kf+n31iA_omQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: mark diener <rpzrpzrpz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60856 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750742AbcJ0QbJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:31:09 -0400
Content-Disposition: inline
In-Reply-To: <CAChgv6pe8mrMRgYhzmiTSQ9dC5d1shp8j_RpU2Kf+n31iA_omQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mark diener <rpzrpzrpz@gmail.com> wrote:
> https://workshop.netfilter.org/2016/wiki/images/7/78/Nft-tutorial.pdf
> 
> Now I just need to figure out how to interpet the "payload load 4b @
> network_header + 12" nomenclature to really get a handle on things.

It tells the payload expression to load 4 bytes, with offset 12,
realtive to network header (base).

> Any more documents or videos to understand the internals?
> (Instead of hours spent looking at source code!)

Whats your goal?

If you really want to learn the internal workings source code is indeed
best option.
