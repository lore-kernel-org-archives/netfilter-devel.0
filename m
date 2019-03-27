Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E676BC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 15:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B43982087C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 15:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfC0PeY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:34:24 -0400
Received: from peace.netnation.com ([204.174.223.2]:59078 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfC0PeX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 11:34:23 -0400
Received: from sim by peace.netnation.com with local (Exim 4.84_2)
        (envelope-from <sim@hostway.ca>)
        id 1h9AZL-0000s1-2T; Wed, 27 Mar 2019 08:34:23 -0700
Date:   Wed, 27 Mar 2019 08:34:23 -0700
From:   Simon Kirby <sim@hostway.ca>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Re: Inability to IPVS DR with nft dnat since 9971a514ed26
Message-ID: <20190327153422.GA1161@hostway.ca>
References: <20190327062650.GA10700@hostway.ca>
 <20190327093027.gmflo27icuhr326p@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327093027.gmflo27icuhr326p@breakpoint.cc>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 27, 2019 at 10:30:27AM +0100, Florian Westphal wrote:

> > I bisected this to 9971a514ed2697e542f3984a6162eac54bb1da98 ("netfilter:
> > nf_nat: add nat type hooks to nat core").
> > 
> > It should be pretty easy to see this with a minimal setup:
> > 
> > /etc/nftables.conf:
> > 
> > table ip nat {
> >     chain prerouting {
> > 		type nat hook prerouting priority 0;
> > 
> > 		ip daddr $ext_ip dnat to $vip
> > 	}
> > 	chain postrouting {
> > 		type nat hook postrouting priority 100;
> > 
> > 		# In theory this hook no longer needed since this commit,
> > 		# but we also need to do some unrelated snatting.
> > 	}
> > }
> > 
> > /etc/sysctl.conf:
> > 	
> > net.ipv4.conf.all.accept_local = 1
> > net.ipv4.vs.conntrack = 1
> > 
> > IPVS DR setup:
> > 
> > ipvsadm -A -t $vip:80 -s wrr
> > ipvsadm -a -t $vip:80 -r $real_ip:80 -g -w 100
> 
> I have a hard time figuring out how to expand $ext_ip, $vip and $real_ip,
> and where to place those addresses on the nft machine.

$ext_ip is something reachable from the "outside"; it just has to be
something which can get to the nft box that isn't the real server or the
same host. We have a public IP in this case.

$vip is something that is on the local LAN "behind" the nft box. In our
case this is an rfc1918 IP address.

$real_ip is on the same subnet as the $vip and is just a way for IPVS to
resolve the neighbor of one of the real servers in order to forward the
packet. With this example configuration, IPVS is basically equivalent to:

ip route add $vip via $real_ip

Except that it hooks the input path because $vip is expected to be bound
locally...and normally you have multiple real servers and some algorithm
selected for balancing. So, I guess I didn't mention that, and you also
need to bind $vip to the nft box, and also to the real server if you
want it to actually be able to respond.

"LVS-HOWTO" has info on how to set up LVS-DR. The only difference here is
that we're using it in a relatively new (2009) configuration where "DR"
(Direct Return) mode is actually symmetric and replying back to the nft
box (symmetric) instead of directly to a separate router. This lets NAT
actually work since it can see traffic in both directions.

Simon-
