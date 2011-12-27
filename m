From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: xt_ecn revisited
Date: Tue, 27 Dec 2011 19:18:58 +0100
Message-ID: <20111227181858.GA28674@1984>
References: <1324999681-22479-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43796 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1L0STG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:19:06 -0500
Content-Disposition: inline
In-Reply-To: <1324999681-22479-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 27, 2011 at 04:27:56PM +0100, Jan Engelhardt wrote:
> 
> fatal: Unable to look up  (port 9418) (No address associated with hostname)
> warn: No branch of git://dev.medozas.de is at:
> warn:   806e172: netfilter: xtables: collapse conditions in xt_ecn
> warn: Are you sure you pushed HEAD there?
> 
> The following changes since commit c5e1fd8ccae09f574d6f978c90c2b968ee29030c:
> 
>   Merge branch 'nf-next' of git://1984.lsi.us.es/net-next (2011-12-25 02:21:45 -0500)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de ..BRANCH.NOT.VERIFIED..
> 
> Jan Engelhardt (3):
>       netfilter: xtables: move ipt_ecn to xt_ecn
>       netfilter: xtables: give xt_ecn its own name
>       netfilter: xtables: collapse conditions in xt_ecn
> 
> Patrick McHardy (1):
>       netfilter: xtables: add an IPv6 capable version of the ECN match

Is this Patrick's or you made a mistake here?

I don't find.

I'll try to pass this to davem by tomorrow, not sure if we'll reach the
merge window :-\
