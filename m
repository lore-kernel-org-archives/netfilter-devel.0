Return-Path: <SRS0=dF0f=SS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0575C10F13
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 12:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFC6B20868
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 12:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfDPM6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 08:58:30 -0400
Received: from drutsystem.com ([84.10.39.251]:57670 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfDPM6a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 08:58:30 -0400
Subject: Re: ulogd2 question - meaning of flow.start.sec when hash_mode == 0
 (NFCT input, JSON output)
From:   Michal Soltys <soltys@ziu.info>
To:     netfilter-devel@vger.kernel.org
References: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info>
Message-ID: <aa818a08-8994-aa1f-e845-05f628a89602@ziu.info>
Date:   Tue, 16 Apr 2019 14:58:22 +0200
MIME-Version: 1.0
In-Reply-To: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-MailScanner-ID: AC1076FF6A5.A0EB3
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/16/19 12:46 PM, Michal Soltys wrote:
> When using hash_mode == 0 with default event_mask, it looks like 
> destruction entry has uninitialized (or having some specific meaning) 
> flow.start.sec and flow.start.usec - as the former converts to early 1970.
> 
> Peeking at the code in event_handler_no_hashtable() it looks like it 
> should be set correctly, but alas something seems amiss.
> 
> creation event:
> 
> {"timestamp": "2019-04-16T12:02:30+0200", "dvc": "testdev", 
> "orig.ip.protocol": 6, "orig.l4.sport": 43562, "orig.l4.dport": 22, 
> "orig.raw.pktlen": 0, "orig.raw.pktcount": 0, "reply.ip.protocol": 6, 
> "reply.l4.sport": 22, "reply.l4.dport": 43562, "reply.raw.pktlen": 0, 
> "reply.raw.pktcount": 0, "ct.mark": 0, "ct.id": 784049088, "ct.event": 
> 1, "flow.start.sec": 1555408950, "flow.start.usec": 517694, 
> "oob.family": 2, "oob.protocol": 0, "src_ip": "192.168.0.254", 
> "dest_ip": "10.151.151.22", "reply.ip.saddr.str": "10.151.151.22", 
> "reply.ip.daddr.str": "192.168.0.254"}
> 
> destruction event:
> 
> {"timestamp": "2019-04-16T12:05:00+0200", "dvc": "testdev", 
> "orig.ip.protocol": 6, "orig.l4.sport": 43562, "orig.l4.dport": 22, 
> "orig.raw.pktlen": 115789, "orig.raw.pktcount": 2011, 
> "reply.ip.protocol": 6, "reply.l4.sport": 22, "reply.l4.dport": 43562, 
> "reply.raw.pktlen": 28701079, "reply.raw.pktcount": 13119, "ct.mark": 0, 
> "ct.id": 784049088, "ct.event": 4, "flow.start.sec": 4084, 
> "flow.start.usec": 805056, "flow.end.sec": 1555409100, "flow.end.usec": 
> 321544, "oob.family": 2, "oob.protocol": 0, "src_ip": "192.168.0.254", 
> "dest_ip": "10.151.151.22", "reply.ip.saddr.str": "10.151.151.22", 
> "reply.ip.daddr.str": "192.168.0.254"}
> 
> flow.start.sec is 4084 == Thu, 01 Jan 1970 02:08:04 +0100
> 
> Any ideas ?
> 

For the record, the same unusual timestamp is shown when monitoring with conntrack:

    [NEW] tcp      6 120 SYN_SENT src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 [UNREPLIED] src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572
 [UPDATE] tcp      6 60 SYN_RECV src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572
 [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572 [ASSURED]
 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572 [ASSURED]
 [UPDATE] tcp      6 60 CLOSE_WAIT src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572 [ASSURED]
 [UPDATE] tcp      6 30 LAST_ACK src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572 [ASSURED]
 [UPDATE] tcp      6 120 TIME_WAIT src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572 [ASSURED]
[DESTROY] tcp      6 src=192.168.0.254 dst=10.151.151.22 sport=44572 dport=22 packets=55 bytes=6577 src=10.151.151.22 dst=192.168.0.254 sport=22 dport=44572 packets=51 bytes=8919 [ASSURED] delta-time=1555405003 [start=Thu Jan  1 04:58:06 1970] [stop=Tue Apr 16 14:54:49 2019]

