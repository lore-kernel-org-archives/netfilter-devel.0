Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D31C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E8520767
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgFVQ3I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:29:08 -0400
Received: from mail.thelounge.net ([91.118.73.15]:19231 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbgFVQ3I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 12:29:08 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49rFGp21P6zXNv;
        Mon, 22 Jun 2020 18:29:06 +0200 (CEST)
Subject: Re: iptables user space performance benchmarks published
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
 <20200622140450.GZ23632@orbyte.nwl.cc>
 <1a32ffd2-b3a2-cf60-9928-3baa58f7d9ef@thelounge.net>
 <20200622145410.GB23632@orbyte.nwl.cc>
 <eef37fef-0e6c-b948-7195-76ce2e2be93b@thelounge.net>
 <20200622154412.GC23632@orbyte.nwl.cc>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <80246bf7-7496-0bfc-d5d7-329ae0fb3b1f@thelounge.net>
Date:   Mon, 22 Jun 2020 18:29:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622154412.GC23632@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 22.06.20 um 17:44 schrieb Phil Sutter:
> Sorry, no thanks. If your setup is so complicated you rather send me an
> image of the machine(s?) running it, you're in dire need to simplify
> things in order to prepare for me helping out. Assuming that
> 'firewall.sh' is also really 57KB in size, I'll probably have a hard
> time even making it do what it's supposed to, let alone reproduce the
> problem.

yeah, it's a corporate firewall with dos-protection, portscan-triggers
and a ton of fancy stuff ending in 270 rules which are 100% needed (most
are chains log something with -m limit and now do something using
nflog/ulogd)

> Let's go another route: Before and after switching from legacy to nft
> backend, please collect the current ruleset by recording the output of:
> 
> - iptables-save
> - ip6tables-save
> - nft list ruleset
> - ipset list

*good news* with xtables-save v1.8.3 on Fedora 31

other than at the last try after switch to ip(6)tables-nft-(restore) and
reboot the network seems to work now properly

not only that ssh behind a ipset-rule now works also my "test.php"
confirms that ratelimits, portscan-trigger and the nat is working

iptables-legacy layer is for sure empty after reboot

-------------------------------

but what is the replacement for iterate "/proc/net/ip_tables_names" and
"/proc/net/ip6_tables_names" in case "iptables-nft" is in use

that is not only used for reset but also on several places for status
counters, display rulets in "-t filter", "-t mangle and "-t raw"

-------------------------------

missing that explains that everything is falling in pieces and add
things which are supposed to be no longer there fails

$IPTABLES here is a macro within my application

 for TABLE in $(<'/proc/net/ip_tables_names'); do
  hlp_rule_ipv4 "$IPTABLES -t $TABLE -F"
  hlp_rule_ipv4 "$IPTABLES -t $TABLE -X"
 done
 if [ "$IPV6_LOADED" == 1 ]; then
  for TABLE in $(<'/proc/net/ip6_tables_names'); do
   hlp_rule_ipv6 "$IPTABLES -t $TABLE -F"
   hlp_rule_ipv6 "$IPTABLES -t $TABLE -X"
  done
 fi
