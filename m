From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 16 Feb 2017 20:57:24 -0500
Message-ID: <CAHC9VhSZ9AkD5OUKg3JX9R83Aq6Afa8EUXFVuNPT+QLPgf3G5Q@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca> <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca> <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
 <20170214002452.GT26850@madcap2.tricolour.ca> <CAHC9VhTZZN8u1CmVVSn_tmirvY+nGjry1PEcQFM+a-DhcLgoBg@mail.gmail.com>
 <20170216223612.GM21519@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:34359 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755215AbdBQB50 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 20:57:26 -0500
Received: by mail-ua0-f170.google.com with SMTP id 35so22526830uak.1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2017 17:57:26 -0800 (PST)
In-Reply-To: <20170216223612.GM21519@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NOTE: I'll respond back to the other part of your email later but I'm
running out of time in the day and this was a quick but important
response]

On Thu, Feb 16, 2017 at 5:36 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Steve has requested the subject attributes which prefixes 7 fields.

I already commented on this earlier in this thread - or some other
related thread, I've lost track, but both you and Steve were on the
To/CC line - last time I checked, you can't reliably link packets to
the sender/subject in the netfilter hooks (I'll be shocked if this has
changed).  The best you can do in some cases is to link the packet to
the socket, and that isn't going to help you.

-- 
paul moore
www.paul-moore.com
