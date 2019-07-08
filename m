Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7954C606A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A065720644
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 09:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="dsvdK0qi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfGHJVC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 05:21:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45952 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfGHJVC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 05:21:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so16163432wre.12
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 02:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xKaPruWTlpWYxTAe5/OM4A69iwAjsuSfFQXF7KmN4t8=;
        b=dsvdK0qi3A9LYQRo3NIpkZxTvkK9fNxv4HBY45Fdw4cEU+kkzdhj5v89f+EdTiLnDa
         htxsQALue0Ri1TZp4kO0y95gk/lbwWJIrUSc+pl4bHnPxKkon6aDm8Q4hEoT4OGiGvlB
         8jDiTM1C5HyZy+d75iAwjoLtRaY6hoKiulK6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xKaPruWTlpWYxTAe5/OM4A69iwAjsuSfFQXF7KmN4t8=;
        b=HtxcAjpS/Ho7w0wbk7vwU8keMlY+/x1wGHD9z1fDnNPAv4EGlTKVtEnVewKBGnFYpi
         w0lrm/UapsfNnMkPg135WQyoer9SEnZbtVi+RLib+J01t4f3ajTmlhTDgjt6CjM9mzgu
         qfHfHn+YZRiPBo2xyWZLnd/eNMw6lTaMO7zeQJd0HhN6ewofzxoVzDh+BckTp9M5VWDO
         iTBDmyMXyrmEDNl8RkuFp0T7c6VNovHrMTMI2kHKGFnDNwKW4Cef+CkteW6G+LKcOK6f
         TNZCyQKElyXWa8+o+UcI8levzvUHSOzanSqO0bBVmtwwob8hcTOX4Y+eIPXzzCWUkS9K
         Ls8A==
X-Gm-Message-State: APjAAAXAH5FRpS+NvZ9qnMAFd6/XXf5FoSTdpUbkMxOHUjdL/2lKAsB1
        aXNz+rLBad8HQyHC8VshgpI2Uk8ejYg=
X-Google-Smtp-Source: APXvYqzHr98XVbO5L7No2wd0cwrT5mAvOgpS2rj1lDCjkl8ERwHNotB4jz7EBq+1T75zQxWkndzGJA==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr17743312wrv.180.1562577659774;
        Mon, 08 Jul 2019 02:20:59 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm14144524wmg.42.2019.07.08.02.20.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 02:20:59 -0700 (PDT)
Subject: Re: [PATCH nf-next v3] netfilter:nft_meta: add NFT_META_VLAN support
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <8dbddc50-c49a-346f-8df7-95d6b460f950@cumulusnetworks.com>
Date:   Mon, 8 Jul 2019 12:20:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 07/07/2019 16:37, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta vlan to set the vlan tag of the packet.
> 
> for q-in-q outer vlan id 20:
> meta vlan set 0x88a8:20
> 
> set the default 0x8100 vlan type with vlan id 20
> meta vlan set 20
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/net/netfilter/nft_meta.h         |  5 ++++-
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>  net/netfilter/nft_meta.c                 | 27 +++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 

So mac_len is (mostly) only updated at receive, how do you deal with the
mac header at egress, specifically if it's a locally originating packet ?
I think it will be 0 and data will be pointing at the network header, take
NF_INET_LOCAL_OUT for example.




