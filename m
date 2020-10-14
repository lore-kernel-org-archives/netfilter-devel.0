Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71728C433E7
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 18:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D5042222A
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 18:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgJNSsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 14:48:14 -0400
Received: from correo.us.es ([193.147.175.20]:47964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgJNSsO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 14:48:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16AA012BFE0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 20:48:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED8C8DA730
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 20:48:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E2F54DA73D; Wed, 14 Oct 2020 20:48:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B92FBDA730;
        Wed, 14 Oct 2020 20:48:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 20:48:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9C07B4301DE0;
        Wed, 14 Oct 2020 20:48:09 +0200 (CEST)
Date:   Wed, 14 Oct 2020 20:48:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: ingress inet support
Message-ID: <20201014184809.GA18012@salvia>
References: <20201013113857.12117-1-pablo@netfilter.org>
 <f790c9ca-a556-98d7-d371-e073cfbc10e5@netfilter.org>
 <20201014184725.GA17701@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20201014184725.GA17701@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Oct 14, 2020 at 08:47:25PM +0200, Pablo Neira Ayuso wrote:
> Hi Arturo,
> 
> On Wed, Oct 14, 2020 at 05:54:13PM +0200, Arturo Borrero Gonzalez wrote:
> > On 2020-10-13 13:38, Pablo Neira Ayuso wrote:
> > > Add support for inet ingress chains.
> > > 
> > >  table inet filter {
> > >         chain ingress {
> > >                 type filter hook ingress device "veth0" priority filter; policy accept;
> > >         }
> > > 	chain input {
> > > 		type filter hook input priority filter; policy accept;
> > > 	}
> > > 	chain forward {
> > > 		type filter hook forward priority filter; policy accept;
> > > 	}
> > >  }
> > 
> > This sound interesting, thanks.
> > 
> > I could see some questions coming from users:
> > 
> > * where are the docs on which packet/traffic sees this nft family vs netdev?
> > * what are the added benefit of this nft family vs netdev?
> 
> See patch update for documentation, let me know if this addresses
> these two questions. I can extend it further, let me know.
> 
> > * is the netdev family somehow deprecated?
> 
> I don't think so. The netdev family is still useful for filter packet
> of any possible ethertype that are entering through a given device
> (for instance ARP, 802.1q, 802.1ad among others). The only difference
> between inet ingress and netdev ingress is that the sets and maps that
> are defined in a given inet table can be accessed from the ingress
> chain, note that it is not possible to access inet sets and maps from
> the netdev ingress chain.
> 
> If your ruleset if focused on traffic filtering for IPv4 and IPv6,
> then inet ingress should be enough.
> 
> The ingress netdev chain also comes with hardware offload support,
> which allows you to drop packets from the NIC, which might be useful
> in DoS scenarios to save CPU cycles. You only have to check if your
> NIC is supported.

Forgot attachment to update documentation, I can possibly include this
information I mentioned above too.

--XsQoSWH+UP9D9v3l
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/doc/nft.txt b/doc/nft.txt
index 5326de167de8..02aefb1589e6 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -217,6 +217,10 @@ Packets forwarded to a different host are processed by the forward hook.
 Packets sent by local processes are processed by the output hook.
 |postrouting |
 All packets leaving the system are processed by the postrouting hook.
+|ingress |
+All packets entering the system are processed by this hook. It is invoked before
+layer 3 protocol handlers, hence before the prerouting hook, and it can be used
+for filtering and policing. Ingress is only available for Inet.
 |===================
 
 ARP ADDRESS FAMILY
@@ -242,15 +246,18 @@ The list of supported hooks is identical to IPv4/IPv6/Inet address families abov
 
 NETDEV ADDRESS FAMILY
 ~~~~~~~~~~~~~~~~~~~~
-The Netdev address family handles packets from ingress.
+The Netdev address family handles packets from the device ingress path. This
+family allows you to filter packets of any ethertype such as ARP, VLAN 802.1q,
+VLAN 802.1ad (Q-in-Q) as well as IPv4 and IPv6 packets.
 
 .Netdev address family hooks
 [options="header"]
 |=================
 |Hook | Description
 |ingress |
-All packets entering the system are processed by this hook. It is invoked before
-layer 3 protocol handlers and it can be used for early filtering and policing.
+All packets entering the system are processed by this hook. It is invoked after
+the network taps (ie. *tcpdump*), right after *tc* ingress and before layer 3
+protocol handlers, it can be used for early filtering and policing.
 |=================
 
 RULESET
@@ -373,7 +380,7 @@ This allows to e.g. implement policy routing selectors in nftables.
 |=================
 
 Apart from the special cases illustrated above (e.g. *nat* type not supporting
-*forward* hook or *route* type only supporting *output* hook), there are two
+*forward* hook or *route* type only supporting *output* hook), there are three
 further quirks worth noticing:
 
 * The netdev family supports merely a single combination, namely *filter* type and
@@ -381,6 +388,10 @@ further quirks worth noticing:
   to be present since they exist per incoming interface only.
 * The arp family supports only the *input* and *output* hooks, both in chains of type
   *filter*.
+* The inet family also supports the *ingress* hook, to filter IPv4 and IPv6
+  packet at the same location as the netdev *ingress* hook. This inet hook
+  allows you to share sets and maps between the usual *prerouting*,
+  *input*, *forward*, *output*, *postrouting* and this *ingress* hook.
 
 The *priority* parameter accepts a signed integer value or a standard priority
 name which specifies the order in which chains with same *hook* value are

--XsQoSWH+UP9D9v3l--
