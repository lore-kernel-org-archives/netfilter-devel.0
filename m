Return-Path: <SRS0=ah1+=RK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5454C43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 14:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D3E20835
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 14:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlw4rrkr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfCGO6N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:58:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41690 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfCGO6N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 09:58:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id n2so17786625wrw.8;
        Thu, 07 Mar 2019 06:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oJU+yhEF6uANH8LMyOSkhxC5rgf801ijG9i4cePKCok=;
        b=mlw4rrkrEg7k/ZWbSZQtU966A1gdOsBqJeCt3tlqdKCHW7jnEgOFzEbVqxXA5lD6++
         HdtiJostiaG60ZWcKjzvvVSyAxAmEcJ/F6WmZH8O9UOvQiPt7ZFtRfH51iNygiQr/9c3
         3Y2GeBj0LCrEtfleDvwRp1OZ4X69J3gAUdmkcNpzZT1QN+whvpsXzbdPuxybo9uhCkA9
         X8Cw/4dHIwkxfwOgIsIL0qy17IM6ESzQQcYRKfcVZKYrkda5eS1Ol2/USyZwqohPQ5u4
         Gu7SGMkqvJ65uiL8zrFBsveciwnZeroVg7tj3BTkxH9RjmcrWzhMd7P3XhNB+JEtCa76
         L+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oJU+yhEF6uANH8LMyOSkhxC5rgf801ijG9i4cePKCok=;
        b=VgQwE9wVZSgTglQWLIjVXkdVtYLPpx4vTgGNQzAC4P+YGTWf5BEO96Jll4ihN45+43
         XBM3BBzpBJ/EhOHspd4Pd7/At/wVp7ywDYuhyzoiQXD83tT3igdmU/CtLpueTzeM50+k
         SMkoF5Int/2GtEQBgLL+vRAgLKFQ1YJrVnOFxM6yJKPtNkAMTgJdk7msYyAkHDx8yBrA
         i4Ki/+aw9SjMdijjSMS1uogAGKlCxBuT5a0FHATyjjncpf19ZCz2PawYGfufocoaIlJx
         U9YL1nFRvOK1GTaIBDDNTljRYHJFJvDnDcQmrn7wApmPh93Pb50UUbPY1XYdOM+Kj9qN
         AKAw==
X-Gm-Message-State: APjAAAVmvTEpwK0Ml5jVRv7aqYTgKWWvPYGrFoPzEujyqwTbGzuvGnor
        KP1/Ud1u83PfZpBemx+mZ1I=
X-Google-Smtp-Source: APXvYqxnKhNnSVzIRxSFtKB7RPbTjK073xdGbO7VFozi6qqbLyoJsklO3HiiUcILgbK6/5TEw0DqNg==
X-Received: by 2002:a5d:458b:: with SMTP id p11mr7417859wrq.22.1551970691263;
        Thu, 07 Mar 2019 06:58:11 -0800 (PST)
Received: from [192.168.1.201] (7.73.31.93.rev.sfr.net. [93.31.73.7])
        by smtp.gmail.com with ESMTPSA id f68sm10650115wmg.5.2019.03.07.06.58.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 06:58:10 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] br_netfilter: enable in non-initial netns
To:     Christian Brauner <christian@brauner.io>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Cc:     tyhicks@canonical.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com
References: <20181107134859.19896-1-christian@brauner.io>
From:   Florian LAUNAY <launayflorian@gmail.com>
Message-ID: <aca5e0b4-7c2a-4bd5-41ba-9a6ac965b9c6@gmail.com>
Date:   Thu, 7 Mar 2019 15:58:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20181107134859.19896-1-christian@brauner.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi everyone,

Can someone help move this topic forward ?
This issue simply prevents any advanced use of docker in LXC.

Thank you in advance!
Florian LAUNAY

On 07/11/2018 14:48, Christian Brauner wrote:
> Hey everyone,
> 
> Over time I have seen multiple reports by users who want to run applications
> (Kubernetes e.g. via [1]) that require the br_netfilter module in
> non-initial network namespaces [2], [3], [4], [5] (There are more issues
> where this requirement is reported.).
> Currently, the /proc/sys/net/bridge folder is only created in the
> initial network namespace. This patch series ensures that the
> /proc/sys/net/bridge folder is available in each network namespace if
> the module is loaded and disappears from all network namespaces when the
> module is unloaded.
> The patch series also makes the sysctls:
> 
> bridge-nf-call-arptables
> bridge-nf-call-ip6tables
> bridge-nf-call-iptables
> bridge-nf-filter-pppoe-tagged
> bridge-nf-filter-vlan-tagged
> bridge-nf-pass-vlan-input-dev
> 
> apply per network namespace. This unblocks some use-cases where users
> would like to e.g. not do bridge filtering for bridges in a specific
> network namespace while doing so for bridges located in another network
> namespace.
> The netfilter rules are afaict already per network namespace so it
> should be safe for users to specify whether a bridge device inside their
> network namespace is supposed to go through iptables et al. or not.
> Also, this can already be done by setting an option for each individual
> bridge via Netlink. It should also be possible to do this for all
> bridges in a network namespace via sysctls.
> 
> Thanks!
> Christian
> 
> [1]: https://github.com/zimmertr/Bootstrap-Kubernetes-with-Ansible
> [2]: https://github.com/lxc/lxd/issues/5193
> [3]: https://discuss.linuxcontainers.org/t/bridge-nf-call-iptables-and-swap-error-on-lxd-with-kubeadm/2204
> [4]: https://github.com/lxc/lxd/issues/3306
> [5]: https://gitlab.com/gitlab-org/gitlab-runner/issues/3705
> 
> Christian Brauner (2):
>    br_netfilter: add struct netns_brnf
>    br_netfilter: namespace bridge netfilter sysctls
> 
>   include/net/net_namespace.h          |   3 +
>   include/net/netfilter/br_netfilter.h |   3 +-
>   include/net/netns/netfilter.h        |  16 +++
>   net/bridge/br_netfilter_hooks.c      | 166 ++++++++++++++++++---------
>   net/bridge/br_netfilter_ipv6.c       |   2 +-
>   5 files changed, 134 insertions(+), 56 deletions(-)
> 
