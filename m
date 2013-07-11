From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH v3 kernel 1/29] bugfix: pkts/bytes need to be specified
 simultaneously
Date: Thu, 11 Jul 2013 19:56:12 +0100
Message-ID: <51DEFFCC.6050402@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com> <1373480727-11254-2-git-send-email-michael.zintakis@googlemail.com> <20130710200450.GE27468@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:56204 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3GKS4Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:56:24 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so6876073lbv.41
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 11:56:23 -0700 (PDT)
In-Reply-To: <20130710200450.GE27468@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Florian Westphal wrote:
> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>> * in nfnetlink_acct.c::nfnl_acct_new enforce a check ensuring that
>> packet and byte values are specified simultaneously - return -EINVAL if
>> that is not the case.
> 
> Ok, I understand why it appears to be un-intuitive to have
> an accounting object that shows '0 bytes in 100000 packets'.
> 
> But still, whats the point?
The fact that it isn't un-intuitive is not the reason for creating that patch.

> I could also set '1 byte in 100000 packets', no?
> 
> [ so my point is, why bother with checking this? ]
Indeed you can, but that would be your own (conscious) decision and you will be responsible for it (which is what counts here).

When either packet or byte counters aren't specified that isn't necessarily the case (you may forgot to set them up for example).

Let me illustrate my point with a little real-life example: suppose you have an alarm clock which lags behind quite often and you need to set it up to wake you in the morning for an important meeting.

Now, if you deliberately choose to put the clock backwards (the equivalent of specifying "0 bytes in 100000 packets") you will be late for that meeting and, as you did not set your clock properly, you are responsible for the flak you are going to get when you are late, while if you leave the clock to drift and be late, you may have an excuse (provided anyone believes that excuse, but that is not the point I am trying to make).

So, nothing is stopping you from specifying "0 bytes in 100000 packets" if you want to, but that would ultimately be your own conscious decision (and responsibility!), as oppose to "forgetting" to specify either bytes or packets, which may or may not be entirely your fault.
