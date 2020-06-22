Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0E1C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3179F2073E
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 16:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgFVQps (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgFVQps (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 12:45:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17776C061573
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 09:45:48 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jnPZo-0005ff-RD; Mon, 22 Jun 2020 18:45:44 +0200
Date:   Mon, 22 Jun 2020 18:45:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables user space performance benchmarks published
Message-ID: <20200622164544.GD23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Reindl Harald <h.reindl@thelounge.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
 <20200622140450.GZ23632@orbyte.nwl.cc>
 <1a32ffd2-b3a2-cf60-9928-3baa58f7d9ef@thelounge.net>
 <20200622145410.GB23632@orbyte.nwl.cc>
 <eef37fef-0e6c-b948-7195-76ce2e2be93b@thelounge.net>
 <20200622154412.GC23632@orbyte.nwl.cc>
 <80246bf7-7496-0bfc-d5d7-329ae0fb3b1f@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80246bf7-7496-0bfc-d5d7-329ae0fb3b1f@thelounge.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Harald,

On Mon, Jun 22, 2020 at 06:29:05PM +0200, Reindl Harald wrote:
> Am 22.06.20 um 17:44 schrieb Phil Sutter:
> > Sorry, no thanks. If your setup is so complicated you rather send me an
> > image of the machine(s?) running it, you're in dire need to simplify
> > things in order to prepare for me helping out. Assuming that
> > 'firewall.sh' is also really 57KB in size, I'll probably have a hard
> > time even making it do what it's supposed to, let alone reproduce the
> > problem.
> 
> yeah, it's a corporate firewall with dos-protection, portscan-triggers
> and a ton of fancy stuff ending in 270 rules which are 100% needed (most
> are chains log something with -m limit and now do something using
> nflog/ulogd)
> 
> > Let's go another route: Before and after switching from legacy to nft
> > backend, please collect the current ruleset by recording the output of:
> > 
> > - iptables-save
> > - ip6tables-save
> > - nft list ruleset
> > - ipset list
> 
> *good news* with xtables-save v1.8.3 on Fedora 31
> 
> other than at the last try after switch to ip(6)tables-nft-(restore) and
> reboot the network seems to work now properly
> 
> not only that ssh behind a ipset-rule now works also my "test.php"
> confirms that ratelimits, portscan-trigger and the nat is working
> 
> iptables-legacy layer is for sure empty after reboot
> 
> -------------------------------
> 
> but what is the replacement for iterate "/proc/net/ip_tables_names" and
> "/proc/net/ip6_tables_names" in case "iptables-nft" is in use
> 
> that is not only used for reset but also on several places for status
> counters, display rulets in "-t filter", "-t mangle and "-t raw"
> 
> -------------------------------
> 
> missing that explains that everything is falling in pieces and add
> things which are supposed to be no longer there fails

Ah yes, that's an obvious change and there's nothing we can do about it.
Unlike legacy iptables, there are no dedicated modules supporting each
table in iptables-nft. For instance, nft_chain_filter.ko suffices for
raw, filter and security tables. For nat table you need nft_chain_nat.ko
and mangle needs nft_chain_route.ko (actually just for OUTPUT chain).

> $IPTABLES here is a macro within my application
> 
>  for TABLE in $(<'/proc/net/ip_tables_names'); do
>   hlp_rule_ipv4 "$IPTABLES -t $TABLE -F"
>   hlp_rule_ipv4 "$IPTABLES -t $TABLE -X"
>  done
>  if [ "$IPV6_LOADED" == 1 ]; then
>   for TABLE in $(<'/proc/net/ip6_tables_names'); do
>    hlp_rule_ipv6 "$IPTABLES -t $TABLE -F"
>    hlp_rule_ipv6 "$IPTABLES -t $TABLE -X"
>   done
>  fi

For iptables-services in Fedora, I simply hard-coded the table names.

Cheers, Phil
