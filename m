From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: Doubt about CTA_EXPECT_* values passed to ctnetlink_parse_tuple()
Date: Tue, 18 Apr 2017 12:41:16 -0700
Message-ID: <20170418194116.GD128305@google.com>
References: <20170417223730.GR28657@google.com>
 <20170418083947.GA1720@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Matthias Kaehlcke <mka@chromium.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33148 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754528AbdDRTlS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 15:41:18 -0400
Received: by mail-pf0-f172.google.com with SMTP id a188so1331596pfa.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2017 12:41:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170418083947.GA1720@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thanks for your reply!

El Tue, Apr 18, 2017 at 10:39:47AM +0200 Pablo Neira Ayuso ha dit:

> On Mon, Apr 17, 2017 at 03:37:30PM -0700, Matthias Kaehlcke wrote:
> > Hi,
> > 
> > While working on clang support for kernel builds I came across at what
> > at first sight looks like an enum mismatch in the netfilter conntrack
> > code:
> > 
> > In multiple occasions CTA_EXPECT_* values (of type enum ctattr_expect)
> > are passed to ctnetlink_parse_tuple(), which expects an 'enum
> > ctattr_type' as type argument.
> 
> Are you refering to this? See patch.

Almost, see patch :)

I interpret that passing the different enum types is intentional and
changing the parameter type an acceptable solution.

Cheers

Matthias
