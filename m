From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH v3 kernel 19/29] add byte threshold capability to nfacct
Date: Thu, 11 Jul 2013 19:56:38 +0100
Message-ID: <51DEFFE6.5070907@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com> <1373480727-11254-20-git-send-email-michael.zintakis@googlemail.com> <20130710200053.GC27468@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:65308 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3GKS4r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:56:47 -0400
Received: by mail-lb0-f172.google.com with SMTP id v20so7014325lbc.3
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 11:56:45 -0700 (PDT)
In-Reply-To: <20130710200053.GC27468@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Florian Westphal wrote:
> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>> * add a 'bthr' variable to each nfacct object, allowing a bytes 'threshold'
>> to be stored and then reported if/when traffic breaches it.
> 
> Again, why is this needed?
> Why is it useful?
This is used for measuring traffic "expectancy", i.e. allows one to be able to register what amount of traffic is "expected" to pass through this accounting object. If that traffic threshold is exceeded, this is properly indicated when the accounting object is listed or any statistics for that object are being collected by the nfacct daemon.

That traffic "expectancy" can be set/reset depending on the nature of the traffic or its source/destination etc, so it is pretty flexible. Again, there is extensive information on this in the (revised) man page if you decide to look at it.
