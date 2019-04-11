Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4628C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F6C20818
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 10:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfDKKVG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 06:21:06 -0400
Received: from mail.us.es ([193.147.175.20]:53470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfDKKVF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 06:21:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFA5311F02B
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2019 12:21:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9FCADA703
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2019 12:21:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D95E4DA70C; Thu, 11 Apr 2019 12:21:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2155DA703;
        Thu, 11 Apr 2019 12:20:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Apr 2019 12:20:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 995B34265A5B;
        Thu, 11 Apr 2019 12:20:59 +0200 (CEST)
Date:   Thu, 11 Apr 2019 12:20:59 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Naruto Nguyen <narutonguyen2018@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: ESTABLISHED tcp conntrack timeout
Message-ID: <20190411102059.b6kyga3jcg6xshcl@salvia>
References: <CANpxKHGdbN6UYTw=r=r9=usZ3taX05ARpnAQ_StF4Zikcpp5WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpxKHGdbN6UYTw=r=r9=usZ3taX05ARpnAQ_StF4Zikcpp5WA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Dropping Cc to netdev and netfilter, no need to Cc everyone :-)

On Wed, Apr 10, 2019 at 05:47:35PM +0700, Naruto Nguyen wrote:
> Hello everyone,
> 
> When duplicating tcp conntrack from main name space to another network
> namespace, I see that sometimes timeout value for an established tcp
> connection in another network namespace has been changed from 432000
> to 300 like below, even it is in ASSURED
> 
> 03:05:53.773
> tcp      6 300 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:05:56.018
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:05:58.267
> tcp      6 300 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:00.511
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:02.767
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:05.024
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:07.318
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:09.578
> tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:11.833
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:14.082
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:16.315
> tcp      6 299 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:25.314
> tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:27.571
> tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:29.815
> tcp      6 431999 ESTABLISHED src=10.172.1.6 dst=11.35.4.5 sport=70752
> dport=7050 src=11.35.4.5 dst=10.172.1.6 sport=7050 dport=70752
> [ASSURED] mark=0 use=1
> 03:06:32.065
> 
> In nf_conntrack_proto_tcp.c, I see that 2 constants have 5 mins set
> 
> [TCP_CONNTRACK_RETRANS] = 5 MINS,
> [TCP_CONNTRACK_UNACK] = 5 MINS,
> 
> and the code
> 
> if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
>        timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
>        timeout = timeouts[TCP_CONNTRACK_RETRANS];
> else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
>        IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
>        timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
>        timeout = timeouts[TCP_CONNTRACK_UNACK];
> else
>        timeout = timeouts[new_state];
> 
> but I am not sure this code cause the above issue. For the second
> TCP_CONNTRACK_UNACK, it only happens for [UNREPLIED] instead of
> [ASSURED]. Could you please let me know how the time out value can be
> changed for an established tcp connection and how to prevent this
> change?

Probably you're seeing retransmission, did you have a look at packet
traces?

Could you describe you testbed, your kernel, and so on?

Thanks.
