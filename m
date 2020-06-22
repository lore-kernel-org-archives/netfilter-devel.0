Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57759C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3051A206E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgFVOLK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:11:10 -0400
Received: from mail.thelounge.net ([91.118.73.15]:30581 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgFVOLJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:11:09 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49rBCb1XYpzXST;
        Mon, 22 Jun 2020 16:11:07 +0200 (CEST)
Subject: Re: iptables user space performance benchmarks published
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
 <20200622140450.GZ23632@orbyte.nwl.cc>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <1a32ffd2-b3a2-cf60-9928-3baa58f7d9ef@thelounge.net>
Date:   Mon, 22 Jun 2020 16:11:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622140450.GZ23632@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 22.06.20 um 16:04 schrieb Phil Sutter:
>> i gave it one try and used "iptables-nft-restore" and "ip6tables-nft",
>> after reboot nothing worked at all
> 
> Not good. Did you find out *why* nothing worked anymore? Would you maybe
> care to share your script and ruleset with us?

i could share it offlist, it's a bunch of stuff including a managament
interface written in bash and is designed for a /24 1:1 NETMAP

basicaly it already has a config-switch to enforce iptables-nft

FILE                    TOTAL  STRIPPED  SIZE
tui.sh                  1653   1413      80K
firewall.sh             984    738       57K
shared.inc.sh           578    407       28K
custom.inc.sh           355    112       13K
config.inc.sh           193    113       6.2K
update-blocked-feed.sh  68     32        4.1K

[harry@srv-rhsoft:/data/lounge-daten/firewall/snapshots/2020-06-21]$
/bin/ls -1 ipset_*
ipset_ADMIN_CLIENTS.txt
ipset_BAYES_SYNC.txt
ipset_BLOCKED.txt
ipset_EXCLUDES.txt
ipset_HONEYPOT_IPS.txt
ipset_HONEYPOT_PORTS.txt
ipset_IANA_RESERVED.txt
ipset_INFRASTRUCTURE.txt
ipset_IPERF.txt
ipset_JABBER.txt
ipset_LAN_VPN_FORWARDING.txt
ipset_OUTBOUND_BLOCKED_PORTS.txt
ipset_OUTBOUND_BLOCKED_SRC.txt
ipset_PORTSCAN_PORTS.txt
ipset_PORTS_MAIL.txt
ipset_PORTS_RESTRICTED.txt
ipset_RBL_SYNC.txt
ipset_RESTRICTED.txt
ipset_SFTP_22.txt

>> via console i called "firewall.sh" again wich would delete all rules and
>> chains followed by re-create them, no success and errors that things
>> already exist
> 
> That sounds weird, if it reliably drops everything why does it complain
> with EEXIST?

that was the reason why i gave up finally

>> please don't consider to drop iptables-legacy, it just works and im miss
>> a compelling argument to rework thousands of hours
> 
> I'm not the one to make that call, but IMHO the plan is for
> iptables-legacy to become irrelevant *before* it is dropped from
> upstream repositories. So as long as you are still using it (and you're
> not an irrelevant minority ;) nothing's at harm.

well, my machines are dating back to 2008 and i don't plan to re-install
them and given that im am just 42 years old now :-)
