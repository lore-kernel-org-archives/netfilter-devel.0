Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2955C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 15:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6B43208E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 15:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="Q17J+W7o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbfFYPBo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:01:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52609 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730827AbfFYPBm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 11:01:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so3196962wms.2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TgM+MOK+N0aZbiGI/abx3iN5g7UAPGd/NAqCvFIIzGg=;
        b=Q17J+W7oB5DtD3KuDPOBa60AQStLSjliJFcmj27uo7ChvcbjHCv5rV/ae2Mm2win+o
         /tHB7O3F9lUqLCpuNgXX6e0xKLzmovdUYjivbFmqh2ENHymWjFLMx3c5iwcmMvojBHI4
         EuVLH5QA0WiPf+MVbXn0V7MH8om/gEhSw5WLhejxCRntwdy3fJSdkHG0mjL+TPvLSwP+
         5+pg0skLGCwC4JZr9DQjCjvtaIscfYbjipWNK/IoWnf2W27LZru1fNNA7X68UBqJbCWk
         vaNTkQqBk+/arLIVtilkFTYTMmIDy2rUSRIekbilcy/Q7DsLBd6BWR9p6rQ1UYhxhcZ8
         1cIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TgM+MOK+N0aZbiGI/abx3iN5g7UAPGd/NAqCvFIIzGg=;
        b=M+nzspwbLRMdwE8x0clHnS1B3hby7P6gvuYto4dfIRsYoeARzemr+KKF9IjjUe7xCB
         GyZ0AJw/BC+RfXsdEPaVEWk3SJFuhVbPfLTp0jDONB/fh3Ppr2zobIiBqGv/HkgJnAl7
         3hMcCeTd+LmR+Pmdqj0Xfv8PaFK+Rt8Xk0RaRxDF4GgQ4NwMGJvU2CR+JjD7g2pprpfe
         Gtrj3cY9L6dNCkH/8Mnc1SZIoIe8zAbHR6HT1Ei/3rPIOvsk/fqA4B8Uug0Dh1280XOq
         tLWnKKvn8F08kCT9L8hN8dWy2ctZTulxhbf85gL8vMvTPL7sRjTBPbBFzZWoQ0bU2XJb
         LgpA==
X-Gm-Message-State: APjAAAUbk6Qd+aAqXN4CzsH3XsWve2eym+VVFimn998t5JI1JfxFdNyY
        3uRhTN9scOxjORxcSX86Wb5Xzw==
X-Google-Smtp-Source: APXvYqxFFjCdTLePM4Tg4HIXflmLR7xJFBEfDpXJwI0AkNHSSTRqtW/fMPazyDCE4qWo9ty3wtSeww==
X-Received: by 2002:a1c:7217:: with SMTP id n23mr20450655wmc.47.1561474898705;
        Tue, 25 Jun 2019 08:01:38 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:4dd1:811d:80c5:4a03? ([2a01:e35:8b63:dc30:4dd1:811d:80c5:4a03])
        by smtp.gmail.com with ESMTPSA id z6sm14084551wrw.2.2019.06.25.08.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 08:01:37 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Kaechele <felix@kaechele.ca>
Cc:     netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
 <20190624235816.vw6ahepdgvxhvdej@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d8c9e1a9-dec3-da71-49a7-d692445a5aff@6wind.com>
Date:   Tue, 25 Jun 2019 17:01:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190624235816.vw6ahepdgvxhvdej@salvia>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 25/06/2019 à 01:58, Pablo Neira Ayuso a écrit :
> On Sun, Jun 23, 2019 at 11:44:09PM -0400, Felix Kaechele wrote:
> [...]
>>   [felix@x1 utils]$ sudo ./conntrack_delete
>>
>>   TEST: delete conntrack (-1)(No such file or directory)
> 
> Could you give a try to this patch?
> 
> 
> x.patch
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 7db79c1b8084..4886b1599014 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1256,7 +1256,6 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conn *ct;
>  	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> -	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
>  	struct nf_conntrack_zone zone;
>  	int err;
>  
> @@ -1266,11 +1265,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
>  
>  	if (cda[CTA_TUPLE_ORIG])
>  		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
> -					    u3, &zone);
> +					    nfmsg->version, &zone);
nfmsg->nfgen_family?

>  	else if (cda[CTA_TUPLE_REPLY])
>  		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
> -					    u3, &zone);
> +					    nfmsg->version, &zone);
Same here?

>  	else {
> +		u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
> +
>  		return ctnetlink_flush_conntrack(net, cda,
>  						 NETLINK_CB(skb).portid,
>  						 nlmsg_report(nlh), u3);
>
