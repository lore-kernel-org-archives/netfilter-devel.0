Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190DFC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 06:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA902075D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 06:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbfC0Goh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 02:44:37 -0400
Received: from peace.netnation.com ([204.174.223.2]:58136 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfC0Gog (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 02:44:36 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Mar 2019 02:44:36 EDT
Received: from sim by peace.netnation.com with local (Exim 4.84_2)
        (envelope-from <sim@hostway.ca>)
        id 1h921S-0002u4-8W; Tue, 26 Mar 2019 23:26:50 -0700
Date:   Tue, 26 Mar 2019 23:26:50 -0700
From:   Simon Kirby <sim@hostway.ca>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Inability to IPVS DR with nft dnat since 9971a514ed26
Message-ID: <20190327062650.GA10700@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!

We have been successfully using nft dnat and IPVS in DR mode on 4.9, 4.14
kernels, but since upgrading to 4.19, such rules now appear to miss the
IPVS input hook and instead appear to hit localhost (and "tcpdump -ni lo"
shows the packets) instead of being forwarded to a real server.

I bisected this to 9971a514ed2697e542f3984a6162eac54bb1da98 ("netfilter:
nf_nat: add nat type hooks to nat core").

It should be pretty easy to see this with a minimal setup:

/etc/nftables.conf:

table ip nat {
        chain prerouting {
                type nat hook prerouting priority 0;

		ip daddr $ext_ip dnat to $vip
	}
	chain postrouting {
		type nat hook postrouting priority 100;

		# In theory this hook no longer needed since this commit,
		# but we also need to do some unrelated snatting.
	}
}

/etc/sysctl.conf:
	
net.ipv4.conf.all.accept_local = 1
net.ipv4.vs.conntrack = 1

IPVS DR setup:

ipvsadm -A -t $vip:80 -s wrr
ipvsadm -a -t $vip:80 -r $real_ip:80 -g -w 100

On the real server, the vip has to be bound to lo or similar and
net.ipv4.conf.all.arp_announce=2 and net.ipv4.conf.all.arp_ignore=1 as
usual for DR, with a symmetric gateway setup (with accept_local above).
Actually, a real server isn't needed to show the issue here, just another
neighbor to route at.

When it works, the inbound frame (TCP connectin to $ext_ip:80) should be
dnatted and then L2-routed (like a static route) to the MAC of $real_ip,
and sent out that interface. Since this commit, it hits lo instead.

Any ideas on what is going wrong here?

Note that we ended up using originally using nftables here because it let
us do one more thing: hairpin NAT _with_ IPVS all on the same host with
"type nat hook input priority -99" and applying snat there. The abillity
to specify hook priorities made this possible. I haven't checked if this
is still working or not, yet, though.

Simon-
