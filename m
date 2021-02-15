Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84A8C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Feb 2021 17:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A43A564DEB
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Feb 2021 17:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhBORbv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Feb 2021 12:31:51 -0500
Received: from mout.gmx.net ([212.227.17.22]:58411 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhBORaF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Feb 2021 12:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1613410109;
        bh=JtiDZd27iGEYR2cwmnmD2dV+cJyWX6tZBOAATJ6pHYE=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=ALZe3zWeGl/R9tObbhAGYcea6tEwTlAuAGMwByPb3FM1zBNgdbqgPoyO0h+pFDJyV
         xug7k/HiCfg9HNUgrG3ITHrPnyFq/hqKAvV+U2jEeir0NoA84enHZ780l5f5l4e3wZ
         GykXewW22njZY/sD8jEXfmiVjhfBwIyeP48EK/xo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.11.9.43] ([80.220.103.250]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M1Hdq-1l8wVy3ONm-002oQk for
 <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2021 18:28:28 +0100
To:     netfilter-devel@vger.kernel.org
From:   =?UTF-8?Q?Lars_Nood=c3=a9n?= <lars.nooden@gmx.com>
Subject: traffic shaping with tc on Linux 5.4.x
Message-ID: <7881d7d9-cd47-749a-aed4-7f6fccf0b059@gmx.com>
Date:   Mon, 15 Feb 2021 19:28:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G22lcOqm/dEMdbN2xJohTaJXd37vapC5kv903PyEHeIqPmcC8ZI
 txVTLM7VDusf7bHsa5J9wBomvB9TCLS5YZxFs8QDNztuaoDasZQ2CQH/cvLs4GskEH+KYnv
 0T3CqXafu+nyfBnMgr/MRVuMAGuC2xq7A8HT+Iwbuz4+zksDg5qF+RG2I2xfhiRSBNw2j/N
 n0gYhP7jE1g+adhVoVf+g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:esZ82HWXBJQ=:iyvfsgwyXow2H8N865WumS
 CMMP0n+/izfOzoE1dK2AKtTPBKvMqHR3XvlTDMfcAWCi8djB43NtzqD9FGG4fSi73HAxYf/4k
 oaljtdJujDfEEyEstseQy8N+QJdLF3z/oIf6XsShlqCV3QniK0eXwLoSPkftezaoaXI7MoT5R
 zKR+/I994SJ9QuyvmcTcS1XiA5Src2+Kf3ewlDXMs+8JxXQG+G/IkvaxLtjUlqRiK7VazY/Xr
 aM7Jq5p5tXsgsMcKBRTNVEFadC7uAWnNKPX2okiZC3r5pfh+LEJ9eQJqtxHvASsvxhbQ1IwOw
 yYPfHe/u5TozVZaikaxkCc0xt05MfEfZ6KAYCB76pMOHJkM4WKnagc4z948endpLr2Tmwv4wn
 No2mj6jBPz6NZroPFgdEkx0yQwJwF/ZjB01R6Fc03JczXQSH01UYAwHqrXnMrp0GB765eWx0n
 tQP+yLy5PmHko5EjJknhCr0eXn+H5/YUiS1aIwsBSkR4BTkuCSYP/fz/3wZeCANdIMzcXgo4z
 Z9d77gh/LvBVdJzKOv2RMZ7+mX6XXlOx621sLTNRmMTSxB6GG2Qkw4fVtmAUo6vs+p+87ZLs1
 L4hSSIMWfNs6QNx9UqWRa4fonwZmKBIh5SpKqLfaZNPL+hIqTBpHw+9V3ASXqe/WrnfqRUocR
 nGDLCU6pwjSQyhw/k4OYNW0laJqaVp6PCOm3fkQQOF0XrUajCgmljbkXTiT5W5iyF8FWmrNVj
 FoZkQYjA67J1FRG6j4WFAnssJCZ39eVkh9vgKdezDZ9sO+ZSBqcn6qM+MqoQeQR6qrnxH2MzQ
 CJjtTf+fk1Eeh20St86qGWxGmX3Za5DtkyiG/l9flQaRqj/hklYlGVIw2ewq8pkTuT9oWgSvF
 WcteWcrR5K0/o37Q/sIw==
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If this is the right list to ask about tc, then I have a beginner
question about traffic shaping.  If not please point me to the correct
venue.

My questions is, given the rules below, how would I further subdivide
the SSH queue so that interactive sessions are prioritized over bulk
transfers?

The goal of the rules below are to give top priority to SSH, next
priority to HTTP/HTTPS, third priority to everything else, and, then,
with what's left over give something to IPFS.  General tips and
corrections also welcome, especially about nft instead of iptables.

Regards,
Lars

=2D--

#!/bin/sh

PATH=3D/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

if=3Dwlp1s0

# remove existing qdiscs, classes, and filters from interface
tc qdisc del dev $if ingress
tc qdisc del dev $if root

# default class for unclassified traffic
tc qdisc replace dev $if root handle 1: htb default 30

# top level class with handle 1:1
tc class add dev $if parent 1: classid 1:1 htb rate 800kbit

# Class 1:10 is highest priority, SSH/SFTP
# Class 1:20 is next highest priority, HTTP/HTTPS
# Class 1:30 is next lowest priority, default traffic
# Class 1:40 is lowest priority but highest bandwidth, IPFS

tc class add dev $if parent 1:1 classid 1:10 htb rate 1mbit \
	ceil 200kbit prio 1
tc class add dev $if parent 1:1 classid 1:20 htb rate 1mbit \
	ceil 100kbit prio 2
tc class add dev $if parent 1:1 classid 1:30 htb rate 1mbit \
	ceil 100kbit prio 3
tc class add dev $if parent 1:1 classid 1:40 htb rate 1mbit \
	ceil 400kbit prio 4

# leaf qdisc to each child class
tc qdisc add dev $if parent 1:10 fq_codel
tc qdisc add dev $if parent 1:20 fq_codel
tc qdisc add dev $if parent 1:30 fq_codel
tc qdisc add dev $if parent 1:40 fq_codel

# add filters to prioritize traffic
tc filter add dev $if parent 1: handle 100 fw classid 1:10
tc filter add dev $if parent 1: handle 200 fw classid 1:20
tc filter add dev $if parent 1: handle 400 fw classid 1:40

# label outgoing traffic
iptables -Z; # zero counters
iptables -F; # flush (delete) rules
iptables -X; # delete all extra chains

iptables -t mangle -A OUTPUT -p tcp --match multiport \
	--sports 22 -j MARK --set-mark 100
iptables -t mangle -A OUTPUT -p tcp --match multiport \
	--sports 80,443 -j MARK --set-mark 200
iptables -t mangle -A OUTPUT -p tcp --match multiport \
	--sports 4001 -j MARK --set-mark 400
