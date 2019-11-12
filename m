Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72528C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 16:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 143BD21D7F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 16:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="g0YBL8Mq";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tootai.net header.i=@tootai.net header.b="g0YBL8Mq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKLQuT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:50:19 -0500
Received: from mail1.tootai.net ([213.239.227.108]:38208 "EHLO
        mail1.tootai.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQuT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 11:50:19 -0500
Received: from mail1.tootai.net (localhost [127.0.0.1])
        by mail1.tootai.net (Postfix) with ESMTP id CBD826008753
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 17:50:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1573577416; bh=hJoQgKG/w/ZOou4EFQTw2D+/6zO0WMND7Ar7tyPNGFc=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=g0YBL8MqzRxkNOkdvsdkO8Utx4x8BqgApLYkGun7cMfnhN0W9G35iKgmAo/gwxcDR
         kR3tlgL5ASOhkZs4RTFKu4cTmPmC+2sq92LkSTLAqR0t0kMIMjf0Ikls6KwIQv3x0L
         QGPnRvbNMl4SO4eYs0C/luZCmcg4hIuCIVtL1FN4=
Received: from [192.168.10.4] (unknown [192.168.10.4])
        by mail1.tootai.net (Postfix) with ESMTPSA id 969056008749
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 17:50:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=tootai.net; s=mail;
        t=1573577416; bh=hJoQgKG/w/ZOou4EFQTw2D+/6zO0WMND7Ar7tyPNGFc=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=g0YBL8MqzRxkNOkdvsdkO8Utx4x8BqgApLYkGun7cMfnhN0W9G35iKgmAo/gwxcDR
         kR3tlgL5ASOhkZs4RTFKu4cTmPmC+2sq92LkSTLAqR0t0kMIMjf0Ikls6KwIQv3x0L
         QGPnRvbNMl4SO4eYs0C/luZCmcg4hIuCIVtL1FN4=
Subject: Re: ipv6 forward rule after prerouting - Howto
To:     Netfilter list <netfilter-devel@vger.kernel.org>
References: <eb91d7f8-e344-c697-b2e0-ff4fb77245b2@tootai.net>
 <20191106185022.GT15063@orbyte.nwl.cc>
From:   Daniel Huhardeaux <tech@tootai.net>
Message-ID: <af730ce4-5b94-7ee2-fba3-e658ac552965@tootai.net>
Date:   Tue, 12 Nov 2019 17:50:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191106185022.GT15063@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 06/11/2019 à 19:50, Phil Sutter a écrit :
> Hi,
> 
> On Wed, Nov 06, 2019 at 06:55:56PM +0100, Daniel Huhardeaux wrote:
>> Hello,
>>
>> I setup prerouting rules with maps like
>>
>> chain prerouting {
>>      type nat hook prerouting priority 0; policy accept;
>>      iif "ens3" ip6 saddr . tcp dport vmap @blacklist_tcp
>>      if "ens3" ip6 saddr . udp dport vmap @blacklist_udp
>>      dnat to tcp dport map @fwdtoip_tcp:tcp dport map @fwdtoport_tcp
>>      dnat to udp dport map @fwdtoip_udp:udp dport map @fwdtoport_udp
>>      ip6 daddr 2a01:729:16e:10::9998 redirect to :tcp dport map @redirect_tcp
>>      ip6 daddr 2a01:729:16e:10::9998 redirect to :udp dport map @redirect_udp
>>      ct status dnat accept
>>      }
>>
>> Default behavior in ip6 filter forward table is to drop. This means that
>> my above rules are blocked, I see (u18srv being the machine who will
>> forward the traffic to another one):
>>
>> 18:32:00.476524 IP6 <hostname>.41174 > u18srv.12345: Flags [S], seq
>> 126955234, win 28640, options [mss 1432,sackOK,TS val 2255777795 ecr
>> 0,nop,wscale 7], length 0
>>   
>>
>> 18:32:08.668468 IP6 <hostname>.41174 > u18srv.12345: Flags [S], seq
>> 126955234, win 28640, options [mss 1432,sackOK,TS val 2255785986 ecr
>> 0,nop,wscale 7], length 0
>> 18:32:24.796392 IP6 <hostname>.41174 > u18srv.12345: Flags [S], seq
>> 126955234, win 28640, options [mss 1432,sackOK,TS val 2255802114 ecr
>> 0,nop,wscale 7], length 0
>>
>> Now if I change my default value to accept for ip6 filter forward table,
>> all is good.
>>
>> Question: how can I add forward rule to filter table using the existing
>> maps which are defined in nat tables ? Other solution ?
>>
>> I thought that ct status dnat accept was the key to archieve my goal,
>> seems not :(
>>
>> Thanks for any hint
> 
> Please be aware that 'accept' verdict will only stop the packet from
> traversing the current chain and any later chain may still drop the
> packet. Only 'drop' verdict is final in that sense.
> 
> So regarding your problem, I guess you have to add the 'ct state' based
> accept rule to forward chain to prevent the drop policy to affect the
> packet. Your prerouting chain already has an accept policy, so explicit
> accepting shouldn't be needed.

Finally I got it work replacing redirect with dnat like

add rule ip6 nat prerouting ip6 daddr == $addripv6 ip6 nexthdr tcp dnat 
to : tcp dport map @redirect_tcp

Thanks for your help
-- 
TOOTAi Networks
