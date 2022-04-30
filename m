Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0442C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Apr 2022 17:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiD3R1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Apr 2022 13:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiD3R1V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Apr 2022 13:27:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E332220F5
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Apr 2022 10:23:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p6so9561210plf.9
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Apr 2022 10:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=tWUVF9DPqB4TmlhyLuAWyW9tYW5DE+f8TKo1PVrl9QQ=;
        b=Pm8CwCGb2UZgPG5DB6AW/BGe03OgFtwL9ZbqCkTI0XNygVmrx3BEGz4eYPSLBFrce0
         5q1gTHHqs6x6SyTOloaJX3b2/ve9MoL/piYCJtKZbbA426ucgR+133cYP2P0HGE11lOD
         sUfYcdlEjkplAjntPrzeNHTGQpJjq8zBRgt12Q2cDRk9RFtXv7YoZtEMeF2f53yL/7UN
         ZKgp8lEwUioPuq7X5fbKFWBFkj/WXXQ0jP2HnMER0KqXsLfnGl62KyWzcicHZ/GKlyTA
         ipkRRAMb4WBNkMSwPsASL9xu5UpTfoivUlQhPp6GGb8N59xI7Ibqdf3Hk848yBXentOw
         DWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=tWUVF9DPqB4TmlhyLuAWyW9tYW5DE+f8TKo1PVrl9QQ=;
        b=cMirL40BChAfheHLnZsgtVgUdMzYbzgUoqKMfW6WBXiEjtguW4/LUC3s12grLiOVTL
         r26uHmNglq+nbDVBERZQFDPCsX+kxNg6bjfBY1+TWHEtWgv9l/W6Py3gJZT73MnDtMdE
         OLI1eDp7xJhPFLrMdqqJ2PRBva/3vaWfyeahhsWgkp0Qmy6c7Nkp1HprhWvNZl9VXh9r
         zUMli3Tm4HkMx4TiZXnmMbCx9dAVN4N3L9eFteeEf5GOqDU6z1F9iIqhmSnl7ukS/CHj
         OAQgmLu1nQ77i7/glshh+8voYDdo2UjWLEk97Hg1y1rtjBrZrmXdzJpxe9urYARc0O6m
         CjGg==
X-Gm-Message-State: AOAM532rGolPGQ+gqA9OM9+zMiMrbKCDd7xFm3gcbNLxGmMm3sKUqjHE
        Er/VlgKyHUFeuQCw4XIPcFlwRar0qkbcOlAZ
X-Google-Smtp-Source: ABdhPJxTIKkssLJLcyBMOqJrL1F5whOWoV/AvPY89OqmXZz/uknMItjpdDN3uMApkzBWb2v9CsAgsQ==
X-Received: by 2002:a17:902:9349:b0:158:a6f7:e280 with SMTP id g9-20020a170902934900b00158a6f7e280mr4341773plp.155.1651339438667;
        Sat, 30 Apr 2022 10:23:58 -0700 (PDT)
Received: from [192.168.2.151] (fpa446b85c.tkyc319.ap.nuro.jp. [164.70.184.92])
        by smtp.gmail.com with ESMTPSA id ms13-20020a17090b234d00b001d9253a32fcsm12565688pjb.36.2022.04.30.10.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Apr 2022 10:23:58 -0700 (PDT)
Message-ID: <801f6e3a-77c5-0f6f-5aeb-84e76ffea03d@gmail.com>
Date:   Sun, 1 May 2022 02:23:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Ritaro Takenaka <ritarot634@gmail.com>
Subject: Re: [PATCH] nf_flowtable: ensure dst.dev is not blackhole
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20220425080835.5765-1-ritarot634@gmail.com>
 <YmfVpecE2UuiP6p8@salvia> <04e2c223-7936-481d-0032-0a55a21dca7a@gmail.com>
 <Ymlc+vl4TUE57Q3+@salvia>
Content-Language: en-US
In-Reply-To: <Ymlc+vl4TUE57Q3+@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2022/04/28 0:10, Pablo Neira Ayuso wrote:> On Tue, Apr 26, 2022 at 09:28:13PM +0900, Ritaro Takenaka wrote:
>> Thanks for your reply.
>>
>>> In 5.4, this check is only enabled for xfrm.
>> Packet loss occurs with xmit (xfrm is not confirmed).
>> I also experienced packet loss with 5.10, which runs dst_check periodically.
>> Route GC and flowtable GC are not synchronized, so it is
>> necessary to check each packet.
>>
>>> dst_check() should deal with this.
>> When dst_check is used, the performance degradation is not negligible.
>> From 900 Mbps to 700 Mbps with QCA9563 simple firewall.
> 
> You mention 5.10 above.
> 
> Starting 5.12, dst_check() uses INDIRECT_CALL_INET.
> 
> Is dst_check() still slow with >= 5.12?
> 
> Asking this because my understanding (at this stage) is that this
> check for blackhole_netdev is a faster way to check for stale cached
> routes.

I did the performance tests with 5.15, confirmed dst_check() is not slower
than checking for blackhole_netdev.

Good, dst_check() can be used.

Then, stale routes check should be moved from nf_flow_offload_gc_step() to
nf_flow_offload(_ipv6)_hook(). Is it correct?
