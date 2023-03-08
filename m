Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54A3C742A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Mar 2023 11:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCHLKV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Mar 2023 06:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjCHLKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2023 06:10:18 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B159E67A
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2023 03:10:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id j2so14954010wrh.9
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Mar 2023 03:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678273815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R5KxqxsCE5OkU+lsucXpiyBxVUa95jE3K3CanvMwcZk=;
        b=Gdp+twmN7YoWPOwI1B2rFmiMEdcUU0+g3T4j+yf37qkyoaHBlB9oZ88Gbxmzj7sK5F
         3ezxELfmoF/+xbVG98PLZGk/0LxWciSBzcIUNP+F0eUAbOZHpVeHJxhOzIUFRJhVd9Vg
         LWC41AO4cxI3HiEEN8fFvDNZr9Qmk9HkBFAgFq+lypwrn+SlCCP0Dgx7A6esqurqrKPw
         t/m159wQryRTQOUQx67iUdcig4/SrPUu7Xxkx8KwtzOw4M7XDnYJSX+6tlNQ9AZjGekf
         GeUteVwZwCzT+N6DfI1cARg4CR3KlPSo+JOw/S7CBw64zELNIKggXYw/vu8LyHulpcDm
         jw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678273815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R5KxqxsCE5OkU+lsucXpiyBxVUa95jE3K3CanvMwcZk=;
        b=RXS69NNyjwT+0DvxlE1i+aF/BCtSDqUARMkxU9pvtNf9OMya7bQQfWZ7ykZXQsD7E6
         CPcuUF7gIl9cIiZDvdRO/kFu4uHLS9TAf4RFZfBcA/Svi91CaqZipk1sjNoZwhKVt5D4
         bB3rMtDW8SFN2C8AoUvphP2NGZqnnutdClyP9wK1wTcsG8ASJ2/34/HaVa7h5trKS+fa
         FaA7KO7C0cDig9Y0hO2EQzcg9iQPZYqLYkmerqWVwRS5IqGd4eTODW3TqeUE1lljbu9Q
         hgnOz+iV7TGc3CxSKfYK1fnU2SRMICyAoxPd3l2FZHEGVxu17BxMHIe7bkfO/SFcgs+f
         LtWQ==
X-Gm-Message-State: AO0yUKWinNdMl5RhdkDJ7aMVQnEn4ileQjSiQqlcOLixlKgeNoo/4SOW
        j2ESJiIIn+efNNGoRXpfongH+CIhqh74b1QmGtzIvA==
X-Google-Smtp-Source: AK7set+i9zLCYxpSAfqjRIsD4Rx5j+P1dOFGWsiOKP70AfDgLY4yqUMAL2IQUK4/bSYWMUh9XXPT9Q==
X-Received: by 2002:a5d:69cc:0:b0:2c7:17db:bf5c with SMTP id s12-20020a5d69cc000000b002c717dbbf5cmr9882765wrw.25.1678273815330;
        Wed, 08 Mar 2023 03:10:15 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id a13-20020a5d508d000000b002c54536c662sm15202465wrt.34.2023.03.08.03.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 03:10:15 -0800 (PST)
Message-ID: <c7766c78-8947-79ca-992d-fe5300774ff9@blackwall.org>
Date:   Wed, 8 Mar 2023 13:10:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv2 nf-next 6/6] selftests: add a selftest for big tcp
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
References: <cover.1678224658.git.lucien.xin@gmail.com>
 <c1ae6bb8f9c67c14437c7714efed7fd2ec551258.1678224658.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <c1ae6bb8f9c67c14437c7714efed7fd2ec551258.1678224658.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 07/03/2023 23:31, Xin Long wrote:
> This test runs on the client-router-server topo, and monitors the traffic
> on the RX devices of router and server while sending BIG TCP packets with
> netperf from client to server. Meanwhile, it changes 'tso' on the TX devs
> and 'gro' on the RX devs. Then it checks if any BIG TCP packets appears
> on the RX devs with 'ip/ip6tables -m length ! --length 0:65535' for each
> case.
> 
> Note that we also add tc action ct in link1 ingress to cover the ipv6
> jumbo packets process in nf_ct_skb_network_trim() of nf_conntrack_ovs.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Reviewed-by: Aaron Conole <aconole@redhat.com>
> ---
>  tools/testing/selftests/net/Makefile   |   1 +
>  tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
>  2 files changed, 181 insertions(+)
>  create mode 100755 tools/testing/selftests/net/big_tcp.sh

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


