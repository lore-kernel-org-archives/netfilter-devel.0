Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8782C43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 06:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99168205ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 06:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfLRGEU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 01:04:20 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51006 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbfLRGEU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 01:04:20 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 23EC13A2E02
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2019 17:04:02 +1100 (AEDT)
Received: (qmail 15858 invoked by uid 501); 18 Dec 2019 06:04:02 -0000
Date:   Wed, 18 Dec 2019 17:04:02 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Mike <mike@mdabbs.org>
Cc:     Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: trying to duplicate udp packets destined for port 67 to port
 6767 on same host
Message-ID: <20191218060402.GA11444@dimstar.local.net>
Mail-Followup-To: Mike <mike@mdabbs.org>,
        Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ba39eeef-6fa0-10de-e45d-8b121f1c37e5@mdabbs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba39eeef-6fa0-10de-e45d-8b121f1c37e5@mdabbs.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=RSmzAf-M6YYA:10 a=WHKFkbbgslkJQO4lyfEA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mike,

On Mon, Dec 09, 2019 at 09:22:30PM -0600, Mike wrote:
> I have a DHCP server on a host but also want to run openHAB which has the
> ability to listen on port 6767 for DHCP requests. The docs say to execute
> the following commands to replicate the packets on to port 6767:
>
> iptables -A PREROUTING -t mangle -p udp ! -s 127.0.0.1 --dport 67 -j TEE
> --gateway 127.0.0.1
> iptables -A OUTPUT -t nat -p udp -s 127.0.0.1/32 --dport 67 -j DNAT --to
> 127.0.0.1:6767
>
> When I do this though, I see the mangle rule packet count start to skyrocket
> and the nat rule never sees any packets. When I try a slight variation
> below, I prevent the skyrocketing packet count but the nat rule still never
> kicks in.
>
> iptables -A PREROUTING -t mangle -p udp ! -i lo --dport 67 -j TEE --gateway
> 127.0.0.1
>
> I have tried various combinations of ip_forward and route_localnet
>
>
> I hope this is the right mailing list and someone could offer some help. I
> can provide nf trace logs if needed, or any other kind of info.
>
> Thanks,
>
> Mike
>
You should be able to achieve this using the NFQUEUE target. Your nfq
application opens a udp socket to port 6767 and duplicates incoming packets to
port DHCP to this socket, using regular sendto() calls. Then it accepts the
packet, so DHCP gets to see it.

Cheers ... Duncan.
