From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Fri, 05 Apr 2013 20:27:58 +0100
Message-ID: <515F25BE.9070006@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost> <512D0BA4.7060809@googlemail.com> <20130226214707.GA3555@localhost> <512E7331.10304@googlemail.com> <515DE487.9020209@googlemail.com> <alpine.DEB.2.00.1304042341530.24744@blackhole.kfki.hu> <515F21AC.3080504@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37171 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162571Ab3DET2F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:28:05 -0400
Received: by mail-lb0-f179.google.com with SMTP id t1so4115655lbd.38
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Apr 2013 12:28:04 -0700 (PDT)
In-Reply-To: <515F21AC.3080504@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Michael Zintakis wrote:
> We would have had the consistency (in other words, getting a consistent result regardless of the order of the various conditions/matches) if nfacct was a target, not a match, but I know that would be difficult (I already examined that possibility) since the x_tables target does not provide a 'destroy' method, so there isn't a way to track the 'refcnt' in the nfacct kernel struct, so inventing this method is as equally as ugly as the hack I did with the nfacct match above, so I thought to ask and see whether there is a better solution.
It looks as though I was wrong - I must have been blind when I looked in the x_tables header file!

There is a destroy method as part of mt_target. So if I 'reform' the nfacct match and make it a target, then I guess that whole 'inconsistency' thing will disappear since I could now use something like:

iptables -A INPUT -m match1 -m match2 -j NFACCT --nfacct <nfacct_obj>

and regardless of the order of match1 and match2, the result will be the same, am I correct or is there something very wrong?
