Return-Path: <SRS0=Y5HT=D4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3253DC4363D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 04:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C61D20870
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Oct 2020 04:41:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DfTQVBNS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440227AbgJUElx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Oct 2020 00:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440224AbgJUElw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Oct 2020 00:41:52 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6366DC0613D3
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 21:41:52 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a12so633473ybg.9
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 21:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LTT5moHIxo5F6I/D11VJLyiKml9YA23rdvibIphc6wY=;
        b=DfTQVBNS6fkMnXNL3a3r96MvmrfqjmLBYaQLUg3SNRwd5wYJg/3oObW+Fo5Ned+R82
         FbaT4w0RNgOFeGAohAH5JMtyQaU5O9dcxwwlDVsbKJsHi9OOTdpcU6ttMgml5XTfTkQl
         6dwYAODCgSxl7GvQk0XeI8T0txugVTJnCrtNcdy0I7JGgFJmQW9teBD6dTj9HJdxddLE
         VkbG2/FJca8GtGMtmbDRz2wDito8VRn22n4cK5D0W7NDPoUVLRFrZRe52RX8mR04Xzd5
         8nSagY0+miJ13t48eI42VM41GJ0u/flhvefy036rXf2ZYA3/jFYrulp66emmlnyj+kox
         ukJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LTT5moHIxo5F6I/D11VJLyiKml9YA23rdvibIphc6wY=;
        b=duOtHWiH1sciPrHBHIJxdBgKtQLlo/bSME/sz529Z1eHkR/+vCE7IfM/BaLeMydPpp
         LwvMSppW99oR5T17tL8b5N4CyySnnXB+KkomCdCbgY6S+YQU+Z1/jwhbH8js2hontq8d
         ktr+nUvSFxcmwjVY0ygchGWExsPFzyQlGeSmr/E0o22fTvXUEschU8Sz4ppsdz80SLxs
         +8t3jk2cDfSMivAJjWgQTk+cfFC5DzJrwblCeQNhCsmBgfe6Hc6DhzRccu+syiakk3pm
         GEH8SGMDFI1fXOuQ5LZ63QNj2I8HTRZEFgnO5HuViSXrSTeP9E//0Ackene+bLfoaidD
         WPlQ==
X-Gm-Message-State: AOAM533v/YtvHDtFIshynXFRBJ7Ce790H0O8Xnasf/pZWaMpxlEpniyJ
        xlEl/GVGz1+qqNH/hSMR2Em1TLvx1dwFwlm8NkNqqXZYAcL8qZLj
X-Google-Smtp-Source: ABdhPJySJeR+iZtOIkgZSUrAeVtAmODnTMvEdxSBQ0q0naYm3M3PU/YeBsJHbPaWnTbA2M0d3yggbIG1U47jwbV5ie4=
X-Received: by 2002:a25:37c2:: with SMTP id e185mr2420215yba.505.1603255310214;
 Tue, 20 Oct 2020 21:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <1A2C4E81-2244-4104-B543-08713F000C0C@criteo.com> <79a56db-5657-6dda-5de0-d7565ef950c6@ssi.bg>
In-Reply-To: <79a56db-5657-6dda-5de0-d7565ef950c6@ssi.bg>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 20 Oct 2020 21:41:34 -0700
Message-ID: <CAF2d9jjbtp-60nSTCbzjriY4A=zXib9O-PhOkrao0Z9UoarHfg@mail.gmail.com>
Subject: Re: Network namespace, ipvlan and IPVS source NAT
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Damien Claisse <d.claisse@criteo.com>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 20, 2020 at 11:01 AM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Tue, 20 Oct 2020, Damien Claisse wrote:
>
> > I'm trying to understand a limitation in ipvlan/netfilter that prevents=
 doing routed IPVS with source NAT inside a namespace.
> >
> > Setup is the following: there is an "lvs" namespace, with an ipvlan int=
erface (in l3 mode) moved to this namespace, linked to physical interface. =
Goal is to isolate load balanced traffic in a separate namespace.
> > This setup is working flawlessly with l3 routed IPIP encapsulation, but=
 I also have a use case for applications that don't support encapsulation, =
hence the need to do l3 routed load balancing with source NAT.
> > Issue is that if I put iptables NAT rule in namespace using ipvs module=
, nothing happens, packet is forwarded but source IP is not translated. It =
seems like netfilter is blind to ipvlan l3 traffic. I also tried using "l3s=
" mode that should to go through netfilter, but in that case, packets for v=
irtual IPs are rejected with a TCP reset. Virtual IPs in namespace seem not=
 visible to this mode.
> >
> > I'm wondering what would be the best way to make it happen:
> > - patch ipvlan to lookup for VIPs in namespaces
> > - patch netfilter ipvs NAT module to translate in root namespace
> > - any other better idea is welcome
> >
> > Please find below commands to reproduce the issue. In this example phys=
ical load balancer interface is enp4s0, virtual IP is 192.168.42.1 (to be e=
xported by a routing protocol, or route manually added to a client in same =
subnet as load balancer for testing), load balancer IP is 192.168.10.10, an=
d real server IP is 192.168.20.20
> >
> > - In root namespace:
> > ip netns add lvs
> > ip link add ipvlan0 link enp4s0 type ipvlan mode l3s
> > ip link set ipvlan0 up
> > ip link set ipvlan0 netns lvs
> >
> > - In lvs namespace (ip netns exec lvs bash):
> > ip addr add 192.168.42.1/32 dev ipvlan0
> > ip route add default via 192.168.10.10 dev ipvlan0 onlink
> > ipvsadm -A -t 192.168.42.1:80 -s rr
> > ipvsadm -a -t 192.168.42.1:80 -r 192.168.20.20:80 -m
> > iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.42.1/24 --vport =
80 -j SNAT --to-source 192.168.10.10
>
>         Make sure /proc/sys/net/ipv4/vs/conntrack is set to 1
> to allow IPVS to keep the netfilter conntracks for its
> packets. This is supported with the CONFIG_IP_VS_NFCT=3Dy
> kernel option.
>
> > What I'd expect: a packet outgoing from enp4s0 with source IP 192.168.1=
0.10 and destination IP 192.168.20.20
> > What I see from a test client:
> > - in l3 mode: a packet outgoing from enp4s0 with source client IP addre=
ss and destination 192.168.20.20 (hence missing source NAT). I also don't s=
ee any conntrack event when doing conntrack -E
> > - in l3s mode: connection reset sent to client. While reading l3s imple=
mentation, I wonder where route lookup is done in ipvlan_l3_rcv, it seems t=
hat namespaces' virtual IP addresses are not visible during this lookup, he=
nce the TCP RST.
>
Unfortunately iptables and IPvlan don't do well together, especially
the L3* modes. L3s mode is a little better but please keep in mind
iptables functionality that involves "forwarding" path, is simply not
compatible with IPvlan L3* modes. Your best bet is to use L2 mode and
perform all IPtables operations inside the namespace if possible.

Regards,
--mahesh..

> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>
