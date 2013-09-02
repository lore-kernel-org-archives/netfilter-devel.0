From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 1/1] netfilter: Ignore bogus SACK option values in TCP
 conntrack
Date: Mon, 2 Sep 2013 14:57:36 -0700
Message-ID: <20130902215736.GA11580@linuxace.com>
References: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37722 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007Ab3IBV6G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:58:06 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so5120149pbb.5
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Sep 2013 14:58:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 02, 2013 at 08:58:00PM +0200, Jozsef Kadlecsik wrote:
> The netfilter TCP conntrack used to mark packets with bogus SACK option
> values as INVALID. However, it seems broken SEQ anonymizers, which are
> responsible for such traffic, are not going to die out soon and conntrack
> effectively blocks traffic coming through such devices.
> 
> Better be liberal at conntrack level: when SACK is bogus, ignore it.

But if conntrack were being "liberal" then it wouldn't care about the value of
the ACKs either, no?  This sort of defeats the purpose of TCP window tracking.
At the very least, this workaround should be dependent upon
nf_conntrack_tcp_be_liberal != 0.  

Also note that David Miller refused to accept a patch working around this
issue in the TCP stack [1].  Why should netfilter do so?

Phil


[1] http://marc.info/?l=linux-netdev&m=137714232805063&w=2
