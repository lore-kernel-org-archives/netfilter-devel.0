From: Paul Moore <pmoore@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Tue, 7 Feb 2017 22:56:39 -0500
Message-ID: <CAGH-KguuAriVuLEE+mb2HwQLcq6ePeDfVyZ=acoxmomnK5R09w@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <20170118151520.GY3087@madcap2.tricolour.ca>
 <CAHC9VhS_6Q=bxnzU8ni1a2fRWnXoMcELzAmy0HmwMH_xhgfRBw@mail.gmail.com>
 <21839828.eXAB1nqvpV@x2> <20170207205219.GA5864@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34796 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753284AbdBHD4k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2017 22:56:40 -0500
Received: by mail-oi0-f53.google.com with SMTP id s203so75433984oie.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Feb 2017 19:56:40 -0800 (PST)
In-Reply-To: <20170207205219.GA5864@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 7, 2017 at 3:52 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> So while I'm not advocating this is what should be done and I'm trying
> to establish bounds to the scope of this feature, but would it be
> reasonable to simply not log packets that were transiting this machine
> without a local endpoint?

I'm still waiting on more detailed requirements information from
Steve, but based on what we've heard so far, it seems that ignoring
forwarded traffic is a reasonable thing to do.

-- 
paul moore
security @ redhat
