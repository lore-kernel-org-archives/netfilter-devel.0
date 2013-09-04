From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 1/1] netfilter: Ignore bogus SACK option values in TCP
 conntrack
Date: Wed, 4 Sep 2013 09:54:03 -0700
Message-ID: <20130904165403.GA13703@linuxace.com>
References: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20130902215736.GA11580@linuxace.com>
 <alpine.DEB.2.00.1309030858120.2504@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47756 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934767Ab3IDQyi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:54:38 -0400
Received: by mail-pa0-f45.google.com with SMTP id bg4so685396pad.4
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Sep 2013 09:54:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1309030858120.2504@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 03, 2013 at 09:31:19AM +0200, Jozsef Kadlecsik wrote:
> On Mon, 2 Sep 2013, Phil Oester wrote:
> > But if conntrack were being "liberal" then it wouldn't care about the 
> > value of the ACKs either, no?  This sort of defeats the purpose of TCP 
> > window tracking.
> 
> No, it doesn't defeat it - we fall back to checking the ACK value against 
> the window.
> 
> > At the very least, this workaround should be dependent upon 
> > nf_conntrack_tcp_be_liberal != 0.
> > 
> > Also note that David Miller refused to accept a patch working around this
> > issue in the TCP stack [1].  Why should netfilter do so?
> > 
> > [1] http://marc.info/?l=linux-netdev&m=137714232805063&w=2
> 
> The purpose of that patch is to get back as much performance of TCP as 
> possible, by working around the broken SACK options.
> 
> This patch lets the traffic at least through, otherwise it's simply 
> blocked by conntrack. Similarly to the TCP stack, conntrack should ignore 
> bogus SACK values instead of effectively dropping the stream.
> 
> This is a long time issue. To be honest, I believed such anonymizer 
> devices would have disappeared (fixed) by now. However it is apparently 
> not so and at the same time conntrack actually breaks TCP robustness. 
> Therefore I think it should be fixed.

This should still only be allowed if nf_conntrack_tcp_be_liberal is enabled
IMHO (or some new sysctl like nf_conntrack_tcp_sack_be_liberal?).  Personally
I don't care about these broken middleboxes, and would rather not have SACK
validation disabled by default.  

Phil
