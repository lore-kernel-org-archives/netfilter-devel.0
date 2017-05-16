From: Florian Westphal <fw@strlen.de>
Subject: Re: crash on >= 4.9.0 kernel seems nf related
Date: Tue, 16 May 2017 10:21:28 +0200
Message-ID: <20170516082128.GB16290@breakpoint.cc>
References: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
 <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: =?iso-8859-15?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40900 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750885AbdEPIWG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2017 04:22:06 -0400
Content-Disposition: inline
In-Reply-To: <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bjørnar Ness <bjornar.ness@gmail.com> wrote:
> Is this an issue  for igb, or netfilter?

I'd lean towards igb, afaics the occurence of the gc worker
is coincidence.

Or does it show up in all such traces?
