Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B1BC282E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 10:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFF56214AE
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 10:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nasimtelecom.com header.i=@nasimtelecom.com header.b="UJ/HYRIx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfDYKNK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:13:10 -0400
Received: from mailuserarghavan.mylittledatacenter.com ([176.9.109.118]:55643
        "EHLO arghavan.mylittledatacenter.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726810AbfDYKNK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 06:13:10 -0400
X-Greylist: delayed 3184 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2019 06:13:08 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=nasimtelecom.com; s=default; h=Message-ID:Subject:To:From:Date:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=se+i60c3AyRMV7AhQembGm/Cr/kOEcUJoqpc7CixbWQ=; b=UJ/HYRIxSy7tF4kOkB/EJq/0i
        ny8W01UCO0R3Uv63XF3et6yBHB928VjxKBT+1+UMULpKJr/rIPNKYZtzucjD7eEB0U5xbHHoe0Gju
        74/kXXfgD6D+rY2HKagT9ss8fqt2fSqEY3ylSzXMftSJXnTva+fdEIIgZ0/r+hpD4vukydXF4yv6c
        gdDNzx37Sw1xjkJvwRnrtlUcPaoEpv5/DGAcKeGjgL/V/EQPdXgV6NhZpVuXD4qthBW/JqcJZtUCS
        1Gr/a26Hkex5DdOk9Kq5779lAEe4jO7vyainOgyaaD5Vygh9UimbzIeIhr5esNREcyHge12uPl9Ah
        6PZxHzsnQ==;
Received: from [127.0.0.1] (port=58658 helo=arghavan.mylittledatacenter.com)
        by arghavan.mylittledatacenter.com with esmtpa (Exim 4.91)
        (envelope-from <Esfandiari@NasimTelecom.com>)
        id 1hJaaC-004CWi-U7; Thu, 25 Apr 2019 13:52:20 +0430
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 25 Apr 2019 13:52:20 +0430
From:   Mojtaba Esfandiari <Esfandiari@NasimTelecom.com>
To:     netfilter-devel@vger.kernel.org
Subject: Issue related to conntrack while insert new rule with conntrack
 command in linux
Message-ID: <8a0187814d06d872011e4026dab073a0@NasimTelecom.com>
X-Sender: Esfandiari@NasimTelecom.com
User-Agent: Roundcube Webmail/1.3.6
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - arghavan.mylittledatacenter.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - NasimTelecom.com
X-Get-Message-Sender-Via: arghavan.mylittledatacenter.com: authenticated_id: esfandiari@nasimtelecom.com
X-Authenticated-Sender: arghavan.mylittledatacenter.com: esfandiari@nasimtelecom.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,
I read conntrack document that you wrote about connection tracking. That 
is great.
I have a issue while i am working on it. For example i just want add new 
rule like this:
conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070 
--dport 5005 -r 192.168.122.1 -q 192.168.122.103 --reply-port-src 1111 
--reply-port-dst 2222 --timeout 30

But it doen't work.
if i insert these two rule in iptable, the same above rule will insert 
in conntrack table automatically and work correctly.
iptables -t nat -A PREROUTING -i eth0 -p udp -s 192.168.122.242 --dport 
5005 -j DNAT --to 192.168.122.1:1111

iptables -t nat -A POSTROUTING -p udp --dport 1111 -j SNAT --to 
192.168.122.103:2222
Who can i solve this problem?
With Best regards
