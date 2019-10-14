Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3EDC4CECE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 20:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C28206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 20:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cc/tzzt6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbfJNUcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 16:32:32 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:40621 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733124AbfJNUcc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 16:32:32 -0400
Received: by mail-qt1-f173.google.com with SMTP id m61so27259352qte.7
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 13:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OOijvCFQg2cyoNXmGmIrIo5Pldhz2YznIINf0ZaR894=;
        b=Cc/tzzt6vznuyQzmW29WmTixHNZ0rFaxHxXC+BbAEgOFzLFgN1IcpsrUQtttFCDmsi
         /i/wr1PCiBRjAl1pw/MlYOn2NHp35EiJrxN3cnk00Rhn7LtVDVvUum11qHhY1Eg8/vYc
         1rndA1uTcXTobCO/URFrHFOkf3zngDuFUQ/T2NpZ2zRDCuSSC0eElDKDFa9a6ZwzYf4m
         clliMfPnUY2PCcrpIN2X3Vwpw6dtYIg+aywccxEbo+muEWAGeBEyFYjGN1PjR1EOCSpY
         XQ1rKHdBpy+5lEYq7RqeaKRBfV1VxO1JQb7ZoYr7PUEq7jSxebFIHEPoTNQ0rH1M4VSB
         HE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OOijvCFQg2cyoNXmGmIrIo5Pldhz2YznIINf0ZaR894=;
        b=CKyRlZjvzy1wAM99UrBa6JX5WtLNs0L/6g8YKz2JW87aSqOdKS1wYZCKZaWvty2Jcd
         SB6f+9yKwrfcRI22SPZhy8SF28CizwgTMnGBz0TKoBF6IEKAzNCjILG2exkuQtFPcvcb
         Ia00b4BH3IxHMl4nnUdtiFM2A7k3+hkObZL9OjlTvxdKmLwIEo3RSzBmEHGkVEpUykIa
         p4nt9Cdfvjt+KXDSPBl8XD2+vdf7P/zNwOcu/ijf/Y6TRTfmg94Ph85bPSRqjCuNBU7s
         WU3EBTdXTDbOh7u78JdztiK/lxYuOsAAkshFMVw6K6zLtbWQ1mTg4dEwRjitlQ9MGiU1
         3QtA==
X-Gm-Message-State: APjAAAV4Ucm3WgkvfPvmQpuL2UYMtHB7pOh6FKJrtHVhLh3bJT8QDIKh
        Fn8mtoKFm9o4F3UJ6x09gWUea3FCbvSFXA+jIEXrDK+C
X-Google-Smtp-Source: APXvYqz3n2WNb/510nPGqhQirgNCwIvSiFIPk06wZNFlsWF273QCuMasmIc5KPqD4Q2G1+yuaHn72QCBboHvAt3Faok=
X-Received: by 2002:ad4:4cc6:: with SMTP id i6mr33079750qvz.166.1571085151026;
 Mon, 14 Oct 2019 13:32:31 -0700 (PDT)
MIME-Version: 1.0
From:   Marco Sommella <marco.sommella@gmail.com>
Date:   Mon, 14 Oct 2019 21:32:18 +0100
Message-ID: <CABEZGrrOL118xtw_HJ6G9N-xidR8kjqmNbW8BB-kupnZNApKXw@mail.gmail.com>
Subject: xtables-addons GEOIP not matching chain
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,
My name is Marco, I'm writing here because at this page:
https://sourceforge.net/projects/xtables-addons/support is said that
is the best place to get help, I have a strange issue with
xtables-addons, in particular with xt_geoip module, please correct me
if I'm in the wrong place.

I'm using Ubuntu 18.04.3 LTS x64 4.15.0-1051 with all the packages updated,

I installed the following packages: xtables-addons-common pkg-config
xtables-addons-source libnet-cidr-lite-perl libtext-csv-xs-perl

And compiled xtables-addons-3.5 (Latest version).

The process for generating GeoIP database with xt_geoip_dl and
xt_geoip_build works and I can see the module xt_geoip loaded in the
kernel (lsmod) and geoip loaded in iptables (cat
/proc/net/ip_tables_matches).

My iptables configuration is simple: it's meant to LOG and DROP all
the connection attempts from country that are not whitelisted, into
specific:
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [3607180:3023592144]
:GEOIP - [0:0]
-A INPUT -m state --state ESTABLISHED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -d 10.0.0.0/8 -j ACCEPT
-A INPUT -d 172.16.0.0/12 -j ACCEPT
-A INPUT -d 192.168.0.0/16 -j ACCEPT
-A INPUT -i eth0 -m geoip ! --source-country IT,IE,GB  -j GEOIP
-A OUTPUT -o lo -j ACCEPT
-A GEOIP -m limit --limit 2/min -j LOG --log-prefix "GEOIP-Dropped: "
-A GEOIP -j DROP
COMMIT

The problem is that the chain GEOIP never get a hit, in fact the
packet count is zero:
# iptables -L -v -n
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination
4884K 3949M ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0            state ESTABLISHED
30094 2417K ACCEPT     all  --  lo     *       0.0.0.0/0
0.0.0.0/0
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0
10.0.0.0/8
   41 23221 ACCEPT     all  --  *      *       0.0.0.0/0
172.16.0.0/12
    0     0 ACCEPT     all  --  *      *       0.0.0.0/0
192.168.0.0/16
    0     0 GEOIP      all  --  eth0   *       0.0.0.0/0
0.0.0.0/0            -m geoip ! --source-country IT,IE,GB

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source
destination

Chain OUTPUT (policy ACCEPT 3609K packets, 3025M bytes)
 pkts bytes target     prot opt in     out     source
destination
 517K  810M ACCEPT     all  --  *      lo      0.0.0.0/0
0.0.0.0/0

Chain GEOIP (1 references)
 pkts bytes target     prot opt in     out     source
destination
    0     0 LOG        all  --  *      *       0.0.0.0/0
0.0.0.0/0            limit: avg 2/min burst 5 LOG flags 0 level 4
prefix "GEOIP-Dropped: "
    0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0

If I try to connect from an IP in another country the connection is not dropped.

Before the latest kernel upgrade I was running version 4.15.0-1043 and
the xtables-addons version compiled was 3.3 and all the GEOIP process
was working smoothly.

The only strange thing is that I saw the following is in /var/log/kern.log:
xt_geoip: loading out-of-tree module taints kernel.
xt_geoip: module verification failed: signature and/or required key
missing - tainting kernel

As the kernel module is loaded, this seems to be only a warning.

Can someone please help me with this?
Thanks a lot
