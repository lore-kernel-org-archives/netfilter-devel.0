Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128C4C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 09:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9D521787
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 09:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlZNqT1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfK1JKO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 04:10:14 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:42162 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfK1JKO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 04:10:14 -0500
Received: by mail-oi1-f171.google.com with SMTP id o12so22669613oic.9
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2019 01:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g3qNDDwHHvu76ibKAwcnUoVtoZyH1LVj2sh3S7a0DwQ=;
        b=DlZNqT1Mzoy1x6Rq+ZykrmmY9MaETOj+e2zS6Mem87k62Q6PDV8FE/F0T0W0g3oNJQ
         M0v6udH0KLkmcqgVYSOHiFLnYhZ864txOtYUy7tOBINAJhY10YRceRUBxUO89/DGzU6M
         nbRV/KTKG8DaeDazqrqnGJi0BfaTlvCPWaPjXQWc0tCXlpxDHoTGai4vb9RPFiiBNKAq
         EXDiGkXR+93ztCqDld24YYKlCC/hOC4MKJO9xaSkZZdVRWxsRuzZ+TsZ0sfQI6VEDS/r
         URoos7dkJF0OtjPM5YfnCktjS+cFWaK/DKL6okK14jweC+3jv2R6XT3OlK2WqngA24wC
         s1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g3qNDDwHHvu76ibKAwcnUoVtoZyH1LVj2sh3S7a0DwQ=;
        b=tIiUIP+nfLYJ2CNvUsjS14Wyj8JnXI6B0YiZ18Bx0sskzEVbFLygEPqhuaXL3iTnex
         WBGJSFMFTWQnqRR14hEhbxpsEaBhEXKQr0PCfB03uVr6GwxoBo7Qu/27U1XCCG5eKbAg
         NdmczKYK7LJYUJvLZZQKx5Q31cIorHz1aBA2s03RzHmP1HQkYnYnVLSF9NRI+qlPJyZ4
         8VHcI6bC7v0evkB/sZ9nXSoF9rKZWQ7JpV1rDqlnXKca2JFIJYkjzCK2Goy2GTVCfPTs
         /a+MsnzdtUuVYHJoF3h6YPvgFDYlRnoUePvNHW5Vo8esoI8ZBa94kxtsLmxiBe9MDsNi
         VK/g==
X-Gm-Message-State: APjAAAU+nzyZH0jbzWfZoJ4mV7geS4BD6ByWboW0IMLPepPnn8SnOL3h
        dLttcd3Es1BRPsblkXuul4vi4IHXCLduq0A3Y0zqE0Kt
X-Google-Smtp-Source: APXvYqy5+DvNcU+RyN2ROjbVT2DdD5HvW4IUAUT3cScNDGCJlTbNvRXQ+bvm6KLYCEcumbfN50ft3Yj6E4VVJCxeyAU=
X-Received: by 2002:aca:d4c4:: with SMTP id l187mr7421255oig.169.1574932212680;
 Thu, 28 Nov 2019 01:10:12 -0800 (PST)
MIME-Version: 1.0
References: <20191126155125.GD8016@orbyte.nwl.cc> <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc> <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org> <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc> <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
 <20191127160646.GK8016@orbyte.nwl.cc> <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
 <20191127172210.GM8016@orbyte.nwl.cc> <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
In-Reply-To: <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Thu, 28 Nov 2019 10:10:01 +0100
Message-ID: <CAF90-WiPoqEWn45taW0WqSMp5cW75VBJyVN9rn13jd8d_Mys-A@mail.gmail.com>
Subject: Re: Operation not supported when adding jump command
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, I guess we had a very similar conversation with the sig-network guys.

Please see below some comments.

On Thu, Nov 28, 2019 at 2:22 AM Serguei Bezverkhi (sbezverk)
<sbezverk@cisco.com> wrote:
>
> Hello Phil,
>
> Please see below the list of nftables rules the code generate to mimic on=
ly filter chain portion of kube proxy.
>
> Here is the location of code programming these rules.
> https://github.com/sbezverk/nftableslib-samples/blob/master/proxy/mimic-f=
ilter/mimic-filter.go
>
> Most of rules are static, will be programed  just once when proxy comes u=
p, with the exception is 2 rules in k8s-filter-services chain. The referenc=
e to the list of ports can change. Ideally it would be great to express the=
se two rules with a single rule and a vmap, where the key must be service's=
 ip AND service port, as it is possible to have a single service IP that ca=
n be associated with several ports and some of these ports might have an en=
dpoint and some do not. So far I could not figure it out. Appreciate your t=
hought/suggestions/critics. If you could file an issue for anything you fee=
l needs to be discussed, that would be great.
>
>
> sudo nft list table ipv4table
> table ip ipv4table {
>         set svc1-no-endpoints {
>                 type inet_service
>                 elements =3D { 8989 }
>         }
>
>         chain filter-input {
>                 type filter hook input priority filter; policy accept;
>                 ct state new jump k8s-filter-services
>                 jump k8s-filter-firewall
>         }
>
>         chain filter-output {
>                 type filter hook output priority filter; policy accept;
>                 ct state new jump k8s-filter-services
>                 jump k8s-filter-firewall
>         }
>
>         chain filter-forward {
>                 type filter hook forward priority filter; policy accept;
>                 jump k8s-filter-forward
>                 ct state new jump k8s-filter-services
>         }
>
>         chain k8s-filter-ext-services {
>         }
>
>         chain k8s-filter-firewall {
>                 meta mark 0x00008000 drop
>         }
>
>         chain k8s-filter-services {
>                 ip daddr 192.168.80.104 tcp dport @svc1-no-endpoints reje=
ct with icmp type host-unreachable
>                 ip daddr 57.131.151.19 tcp dport @svc1-no-endpoints rejec=
t with icmp type host-unreachable
>         }
>

Here you're going to have the same problems with iptables, lack of
scalability and complexity during rules removal. In nftlb we create
maps and with the same rules, you only have to take care of insert and
remove elements in them.

Some extensive examples here:

https://github.com/zevenet/nftlb/tree/master/tests

In regards to the ip : port natting, is not possible to use 2 maps
cause you need to generate numgen per each one and it will come to
different numbers.

Cheers.

>         chain k8s-filter-forward {
>                 ct state invalid drop
>                 meta mark 0x00004000 accept
>                 ip saddr 57.112.0.0/12 ct state established,related accep=
t
>                 ip daddr 57.112.0.0/12 ct state established,related accep=
t
>         }
> }
>
> Thank you
> Serguei
>
> =EF=BB=BFOn 2019-11-27, 12:22 PM, "n0-1@orbyte.nwl.cc on behalf of Phil S=
utter" <n0-1@orbyte.nwl.cc on behalf of phil@nwl.cc> wrote:
>
>     Hi,
>
>     On Wed, Nov 27, 2019 at 04:50:56PM +0000, Serguei Bezverkhi (sbezverk=
) wrote:
>     > According to api folks kube-proxy must sustain 5k or about test oth=
erwise it will never see production environment. Implementing of numgen exp=
ression is relatively simple, thanks to "nft --debug all" once it's done, a=
 user can use it as easily as  with json __
>     >
>     > Regarding concurrent usage, since my primary goal is kube-proxy I d=
o not really care at this moment, as k8s cluster is not an application you =
co-locate in production with some other applications potentially altering h=
ost's tables. I agree firewalld might be interesting and more generic alter=
native, but seeing how quickly things are done in k8s,  maybe it will be do=
ne by the end of 21st century __
>
>     I agree, in dedicated setup there's no need for compromises. I guess =
if
>     you manage to reduce ruleset changes to mere set element modification=
s,
>     you could outperform iptables in that regard. Run-time performance of
>     the resulting ruleset will obviously benefit from set/map use as ther=
e
>     are much fewer rules to traverse for each packet.
>
>     > Once I get filter chain portion in the code I will share a link to =
repo so you could review.
>
>     Thanks! I'm also interested in seeing whether there are any
>     inconveniences due to nftables limitations. Maybe some problems are
>     easier solved on kernel-side.
>
>     Cheers, Phil
>
>
