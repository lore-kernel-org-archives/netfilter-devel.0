From: Sam Liddicott <sam@liddicott.com>
Subject: Re: Multiple conntrack tables
Date: Thu, 19 Jun 2014 14:49:01 +0100
Message-ID: <CAOj-5WDOCwpCCBPLUwQ=vd1GzrTbLg6hLSFVWCnrozdZhTjp5A@mail.gmail.com>
References: <CAOj-5WDepb3pj3=oRms+OhWhScFJ15V-H3QuGUFjScE54-mtMg@mail.gmail.com>
	<20140618213057.GA13029@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:57672 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaFSNtC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:49:02 -0400
Received: by mail-qc0-f176.google.com with SMTP id w7so2184991qcr.35
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 06:49:01 -0700 (PDT)
In-Reply-To: <20140618213057.GA13029@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks, Florian, that's great!

Sam

On Wed, Jun 18, 2014 at 10:30 PM, Florian Westphal <fw@strlen.de> wrote:
> Sam Liddicott <sam@liddicott.com> wrote:
>> I know that a rule in raw can prevent a packet from being processed by
>> contrack..
>>
>> I wonder if it could also identify which contrack table it should go in.
>
> This is possible via conntrack zones, see
> iptables-extensions(8), '--zone' option of CT target.
