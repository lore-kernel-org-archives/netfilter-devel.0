Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECA3C606A1
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AB1020651
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="dQKOyh4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfGHJcC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 05:32:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55862 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbfGHJcC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 05:32:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so14995659wmj.5
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 02:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7NEkUPxwDuOoiNqf5KZiEB6HIUlhYyT8BGzVWnyqSwY=;
        b=dQKOyh4Pkg4PQSAau/yLEezloFmCAgfelsxaT9F1yI73/i5uFxsiE3DW/yBlnRYy05
         KPR9IcjM09/ftzO1ITOkJdv+taRPMH83Ucyy0Wyedq+bg0MIS5/BTfmz4Fo9MRcYXSHc
         Ua5lsd+hjNehDFQgeglTS60iDlalEJjWTAW58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7NEkUPxwDuOoiNqf5KZiEB6HIUlhYyT8BGzVWnyqSwY=;
        b=ozREB1EQjtqfSq4EAnHYTkDhpa8VaeVPFPt1zdvdFdEBqDIglYfzpaodz3fXtBseB8
         I6Q7/jgiTEfMvAnYCMEtbz6fFqfxsHoqYUvbMyQm+eLfwIOQGUCwat28iQjh5ImhZWzJ
         RcLk+zFrgl9rEv4uzKt/0YYOwElrvtTrQxgHvrmh82GfWtxhbwCRYaLzDcelyG8PSJAn
         OtUPk9R1vJxz3iPiaWb7Sk1wWHBV9pCyBzNRctrAQEHMqd9hCDxAiRVup6iPgzj98SL6
         IvUs2SdiH3R1yukxcQ//pDRWxx/7PjEFFj1ifNAET9Z0YVDPjRyP0pCJARmfHMoR87q+
         4f0Q==
X-Gm-Message-State: APjAAAW0EPORp5ZWyCHn+T0aErpmoFtxVqBBUWM2HI4rhcHgacHK2aFh
        g5dclOH33G38A+pxwVRsINw6joy6VZk=
X-Google-Smtp-Source: APXvYqz5ygAxPMUEMs9taeSX6+5AaEd7xGgFOrx+PWuu5jZyNJEE1xBrbdERWZk/aT9RjbAFpDojAQ==
X-Received: by 2002:a1c:e341:: with SMTP id a62mr16567320wmh.165.1562578319472;
        Mon, 08 Jul 2019 02:31:59 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f12sm17434423wrg.5.2019.07.08.02.31.57
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 02:31:58 -0700 (PDT)
Subject: Re: [PATCH nf-next v3] netfilter:nft_meta: add NFT_META_VLAN support
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
 <8dbddc50-c49a-346f-8df7-95d6b460f950@cumulusnetworks.com>
Message-ID: <a5108662-a465-9273-22d2-e355213436de@cumulusnetworks.com>
Date:   Mon, 8 Jul 2019 12:31:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8dbddc50-c49a-346f-8df7-95d6b460f950@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 08/07/2019 12:20, Nikolay Aleksandrov wrote:
> On 07/07/2019 16:37, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch provide a meta vlan to set the vlan tag of the packet.
>>
>> for q-in-q outer vlan id 20:
>> meta vlan set 0x88a8:20
>>
>> set the default 0x8100 vlan type with vlan id 20
>> meta vlan set 20
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  include/net/netfilter/nft_meta.h         |  5 ++++-
>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>>  net/netfilter/nft_meta.c                 | 27 +++++++++++++++++++++++++++
>>  3 files changed, 35 insertions(+), 1 deletion(-)
>>
> 
> So mac_len is (mostly) only updated at receive, how do you deal with the
> mac header at egress, specifically if it's a locally originating packet ?
> I think it will be 0 and data will be pointing at the network header, take
> NF_INET_LOCAL_OUT for example.
> 

Obivously I should've checked the hook limits of nft_meta first. :)
I see now that it is limited only to NF_INET_PRE_ROUTING for set, so that should be fine.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

