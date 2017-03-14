From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrack (possibly) hangs on our ARM CPU in case we delete 5k+
 connections as fast as possible
Date: Tue, 14 Mar 2017 12:20:51 +0100
Message-ID: <20170314112051.GA23549@breakpoint.cc>
References: <CAMm+moMPBxBmrnNuwK6tK_Bu2oKaxOMj=BK=DtpYT_YStO9P7A@mail.gmail.com>
 <20170314103300.GA8738@breakpoint.cc>
 <CAMm+moPG18qx-2xQ6dXK0p=vTjGNfH6Xo_hk2ADWbf8ocmLTkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Peter Marczis <peter.marczis@greenwavesystems.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750774AbdCNLVL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 07:21:11 -0400
Content-Disposition: inline
In-Reply-To: <CAMm+moPG18qx-2xQ6dXK0p=vTjGNfH6Xo_hk2ADWbf8ocmLTkw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Marczis <peter.marczis@greenwavesystems.com> wrote:
> I mean we destroy the sockets, we used two very basic python script to
> open and close TCP sockets between the WAN and LAN interface.

Then my guess wrt. nf_ct_iterate_cleanup is certainly wrong.

