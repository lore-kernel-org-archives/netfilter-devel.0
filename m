From: Mohit Mehta <mohit.mehta@vyatta.com>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte
 counters for a specific rule using iptables/ip6tables
Date: Thu, 10 Sep 2009 09:24:01 -0700 (PDT)
Message-ID: <4281186.244991252599841498.JavaMail.root@tahiti.vyatta.com>
References: <alpine.LSU.2.00.0909101620240.24353@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:34855 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZIJQX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:23:58 -0400
In-Reply-To: <alpine.LSU.2.00.0909101620240.24353@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Sorry for the delay in reponse. I thought you were making a statement :-) Also, thanks for cleaning up the whitespaces and man page stuff for the patch.

So, as you already mentioned in your previous post - 

> wonder what the real-world use of this is, apart from
> rule debugging (for which -j TRACE seems better anyhow).

The motivation for exposing the existing library function for -Z # was to facilitate an easy way for the users to debug a specific rule. I think this is most useful when there's a couple hundred rules and the user wants to quickly check if a  specific rule is getting hit by looking at its counters.

Honestly, I had not looked at the TRACE target before this and that as you point out is also useful in rule debugging. But I guess that resetting the counters of a rule would would come in handy when the user already has a target defined for a rule and wants to quickly test if the rule is getting hit for an expected traffic pattern as defined in the rule.  Hopefully, other people will find this useful as well.

Mohit

----- Jan Engelhardt <jengelh@medozas.de> wrote:
> Hi Mohit,
> 
> 
> On Wednesday 2009-08-19 22:41, Jan Engelhardt wrote:
> >
> >>I was able to cleanly apply the attached modified patches to the
> >> latest iptables code. Also, below is the code in text if attachment
> >> doesn't reach.
> >>
> >>Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using iptables
> >
> >
> >I wonder what the real-world use of this is, apart from
> >rule debugging (for which -j TRACE seems better anyhow).
> 
> That was meant to be a question. Could you please let me know why 
> exactly -Z # was needed? I guess there was some large value seen in it 
> given you were sending it from Vyatta, so I would like to know. If it 
> was just an experiment and TRACE and/or quota2 (Xta) was sufficient in 
> regards to you accomplishing whatever the intention was to, please also 
> let me know so that I can possibly discard the branch with your -Z#
> submission.

