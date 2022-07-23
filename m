Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA43C43334
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Jul 2022 09:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiGWJsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Jul 2022 05:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiGWJsD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Jul 2022 05:48:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EF5357F7
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2022 02:48:02 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oFBjo-0006pB-8s; Sat, 23 Jul 2022 11:47:56 +0200
Date:   Sat, 23 Jul 2022 11:47:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
        Erik Skultety <eskultet@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
Message-ID: <YtvDzOxd1/eEMaFo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
        Erik Skultety <eskultet@redhat.com>,
        netfilter-devel@vger.kernel.org
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
 <20220720142002.GA22790@breakpoint.cc>
 <YtgpJ9FNZmmuniLV@nautilus.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtgpJ9FNZmmuniLV@nautilus.home.lan>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Jul 20, 2022 at 06:11:19PM +0200, Erik Skultety wrote:
[...]
> Hmm, the only reason why I submitted this change is because our libvirt test
> suite suddenly started failing on CentOS Stream 9 and only on CS9. Now, the
> test suite is flawed in its own way checking libvirt actions against iptables
> CLI output (yes, very fragile), but at the time the tests were written there
> essentially wasn't a programatic way of checking the changes like we could do
> today with the nftables library and its JSON formatter.
> So I investigated what's changed on CentOS Stream 9 compared to CS8 or Fedora
> 35/36 and it turned out that CS9 ships iptables-nft 1.8.8 while e.g. Fedora 36
> ships 1.8.7 (so we're bound to failures there as well in the future).
> 
> Let me describe the output difference in between the 2 versions of iptables:
> 
> < v1.8.8
> # ip6tables -L FI-tck-7081731
> Chain FI-tck-7081731 (1 references)
> target     prot opt source               destination
> RETURN     icmpv6    f:e:d::c:b:a/127     a:b:c::d:e:f         MAC01:02:03:04:05:06 DSCP match 0x02 ipv6-icmptype 12 code 11 ctstate NEW,ESTABLISHED
>     *** NOTE ^^HERE ***
> 
> >= v1.8.8
> ip6tables -L FI-tck-7081731
> Chain FI-tck-7081731 (1 references)
> target     prot opt source               destination
> RETURN     ipv6-icmp    f:e:d::c:b:a/127     a:b:c::d:e:f         MAC01:02:03:04:05:06 DSCP match 0x02 ipv6-icmptype 12 code 11 ctstate NEW,ESTABLISHED
>       *** NOTE ^^HERE ***
> 
> If my detective work was correct it was caused by commit
> b6196c7504d4d41827cea86c167926125cdbf1f3 which swapped the order of the
> protocol keys in the 'xtables_chain_protos'.

Yes, the goal was to avoid changes in output given typical /etc/protocol
contents - it prefers "ipv6-icmp" over "icmpv6" for protocol 58 at least
on my systems.

I would suggest to not rely upon human-readable names for protocol
numbers, but in fact there's no way out: iptables consolidates its
internal protocol names list even if --numeric was given.

Another bug I found while playing around is this:

| # iptables -A FORWARD -p icmpv6
| # iptables -vnL FORWARD
| Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
|  pkts bytes target     prot opt in     out     source               destination
|     0     0            ipv6-icmp--  *      *       0.0.0.0/0            0.0.0.0/0

print_rule_details() does not append a space after the protocol name if it is
longer or equal to five characters.

Both bugs seem to exist since day 1, I'm still tempted to fix them, i.e.:

- Print protocol numbers with --numeric
- Adjust the protocol format string from "%-5s" to "%-4s " for protocol
  names and from "%-5hu" to "%-4hu " for protocol numbers to force a
  single white space

Objections anyone?

Thanks, Phil
