From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: Ignore bogus SACK option values in TCP
 conntrack
Date: Tue, 3 Sep 2013 09:31:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309030858120.2504@blackhole.kfki.hu>
References: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu> <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu> <20130902215736.GA11580@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:39119 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab3ICHbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:31:23 -0400
In-Reply-To: <20130902215736.GA11580@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2 Sep 2013, Phil Oester wrote:

> On Mon, Sep 02, 2013 at 08:58:00PM +0200, Jozsef Kadlecsik wrote:
> > The netfilter TCP conntrack used to mark packets with bogus SACK option
> > values as INVALID. However, it seems broken SEQ anonymizers, which are
> > responsible for such traffic, are not going to die out soon and conntrack
> > effectively blocks traffic coming through such devices.
> > 
> > Better be liberal at conntrack level: when SACK is bogus, ignore it.
> 
> But if conntrack were being "liberal" then it wouldn't care about the 
> value of the ACKs either, no?  This sort of defeats the purpose of TCP 
> window tracking.

No, it doesn't defeat it - we fall back to checking the ACK value against 
the window.

> At the very least, this workaround should be dependent upon 
> nf_conntrack_tcp_be_liberal != 0.
> 
> Also note that David Miller refused to accept a patch working around this
> issue in the TCP stack [1].  Why should netfilter do so?
> 
> [1] http://marc.info/?l=linux-netdev&m=137714232805063&w=2

The purpose of that patch is to get back as much performance of TCP as 
possible, by working around the broken SACK options.

This patch lets the traffic at least through, otherwise it's simply 
blocked by conntrack. Similarly to the TCP stack, conntrack should ignore 
bogus SACK values instead of effectively dropping the stream.

This is a long time issue. To be honest, I believed such anonymizer 
devices would have disappeared (fixed) by now. However it is apparently 
not so and at the same time conntrack actually breaks TCP robustness. 
Therefore I think it should be fixed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
