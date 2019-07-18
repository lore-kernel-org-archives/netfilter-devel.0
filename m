Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A834C76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 08:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE5A208C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 08:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfGRIto (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 04:49:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:48270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726397AbfGRIto (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 04:49:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 86834AF47
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 08:49:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 333A6E00A9; Thu, 18 Jul 2019 10:49:43 +0200 (CEST)
Date:   Thu, 18 Jul 2019 10:49:43 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netfilter-devel@vger.kernel.org
Subject: userspace conntrack helper and confirming the master conntrack
Message-ID: <20190718084943.GE24551@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

to clean up some skeletons in the closet of our distribution kernels,
I'm trying to add a userspace conntrack helper for SLP into conntrackd.

A helper is needed to handle SLP queries which are sent as multicast UDP
packets but replied to with unicast packets so that reply's source
address does not much request's destination. This is exactly the same
problem as for mDNS so that I started by copying existing mdns helper in
conntrackd and changing the default timeout. But I found that it does
not work with 5.2 kernel.

The setup looks like this (omitting some log rules):

  nfct helper add slp inet udp
  iptables -t raw -A OUTPUT -m addrtype --dst-type MULTICAST \
      -p udp --dport 427 -j CT --helper slp
  iptables -t raw -A OUTPUT -m addrtype --dst-type BROADCAST
      -p udp --dport 427 -j CT --helper slp
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
  iptables -A INPUT -m conntrack --ctstate RELATED -j ACCEPT
  iptables -P INPUT DROP
  iptables -P OUTPUT ACCEPT

The helper rules apply, outgoing multicast packet is sent away but the
unicast reply is not recognized as related and rejected. Monitring with
"conntrack -E expect" shows that an expectation is created but it is
immediately destroyed and "conntrack -E" does not show the conntrack for
the original multicast packet (which is created when I omit the helper
rules in raw table). Kernel side tracing confirms that the conntrack is
never confirmed and inserted into the hash table so that the expectation
is destroyed once the request packet is sent out (and skb_consume()-ed).

I added some more tracing and this is what seems to happen:

  - ipv4_confirm() is called for the conntrack from ip_output() via hook
  - nf_confirm() calls attached helper and calls its help() function
    which is nfnl_userspace_cthelper(), that returns 0x78003
  - nf_confirm() returns that without calling nf_confirm_conntrack()
  - verdict 0x78003 is returned to nf_hook_slow() which therefore calls
    nf_queue() to pass this to userspace helper on queue 7
  - nf_queue() returns 0 which is also returned by nf_hook_slow()
  - the packet reappears in nf_reinject() where it passes through
    nf_reroute() and nf_iterate() to the main switch statement
  - it takes NF_ACCEPT branch to call okfn which is ip_finish_output()
  - unless I missed something, there is nothing that could confirm the
    conntrack after that

Did I forget to do something in the helper (essentially a copy of
existing mdns helper which is supposed to work) or in the setup above
(which is based on the documentation)? Or is this a problem on kernel
side? Should the conntrack be confirmed while processing the original
packet (which ends up queued) or the reinjected one? And where should it
happen?

Thanks in advance,
Michal Kubecek
