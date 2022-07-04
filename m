Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C1EC43334
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jul 2022 01:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiGDB2K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGDB2I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Jul 2022 21:28:08 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE6F638E
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2022 18:28:07 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id o2so9074527yba.7
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Jul 2022 18:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=h1OuuSFHXwBotGYEzziWI1mTIYAkSXutDn9AXsQrULw=;
        b=ZI032cueFd8ThrS+u8uJem3RAeTr4E4+DY5nYOIy6s2J6A9720MTpX4FsJXw4XsiWi
         VxDwg0K54PdsF3+eSL9vcduPhgQl5RrF0rp31aSCoXQ0grssU3Lo4Qj/TyHqy/NgQF8+
         Z3gEYs1HEDBTMjAb6OBKwivI2Lm4X/18zbb2lU7cclEXbsx63nNvloXWc70/1CS7al4R
         xB6zxQM/j/NHOxLBDQKEVx4rvbY7YHKg26DAc6RSk3QYu8QN/p/aos7Sd+5SXr3AUISN
         apguuWfgnEVtcJ+zdt5ckF2Q/oLO6RTdTrHRSWjB6QjEuC5VO6l7+OkwkTYxRwN0b6XN
         HmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=h1OuuSFHXwBotGYEzziWI1mTIYAkSXutDn9AXsQrULw=;
        b=WUeTggsNTnfYV+ey6UroohpGB9/gzdKjb4sYlU/12OBKtziCswZWkizk24IOkw/oEs
         xRe3+/CwniFafAcrXRWdr8bVZ0oyrsRJ+Dl4cUZALh39bZc2IFIhGmLd5zyo7MfmdxEN
         /lPbANV8Vobt3ruwQ/QFG+uv1mIAVLKncrX94lXnsdM0O6CLtwITeavIxTSOm63xZ0ns
         BsbRc9Rqrul6UQ/zl/C7VJ0O6+uHkfscn98jdMfr/ev8ZeeY3J90ua4y5v76QfEdA5A7
         ebFjszAKh0oEnD2xhCdZ1eufo0aixJizSgJjIIHtDlO5toOwpTddHH+jVVnBWyb1oZd/
         zi3w==
X-Gm-Message-State: AJIora9tNh3nGk3JINynV9IJ+4QfeQeR1ps3vZiM4GazfauDO+E1sFBU
        ZdPPZqAfMfWpy8z4GmrfSG3CRywn5M6QLaP3ef+a+b73QHQ=
X-Google-Smtp-Source: AGRyM1v7zcxq9tx7iz/0honUWQ1h+e33msZY7nr44xh2b5V9t9vCNrfXsCB6mYcomCgEreeJYdYiJdwtq2nXvqh9ndM=
X-Received: by 2002:a05:6902:1186:b0:64e:b02c:4f99 with SMTP id
 m6-20020a056902118600b0064eb02c4f99mr27824579ybu.165.1656898086220; Sun, 03
 Jul 2022 18:28:06 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Mon, 4 Jul 2022 09:27:55 +0800
Message-ID: <CAGnHSEkTTLwL9X8DxUPkVSw=3QvNFP8ttFC4kRp3exYQJEkeQA@mail.gmail.com>
Subject: [BUG] ARP packet "parsing" broken in output hook of arp and netdev
 family table
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

I have the following tables to showcase the issue:

table netdev meh {
    chain input {
        type filter hook ingress device "bridge0" priority filter;
policy accept;
        arp saddr ether 36:b0:4a:e2:72:ea arp daddr ether
00:00:00:00:00:00 log prefix "netdev in: " flags all
    }

    chain output {
        type filter hook egress device "bridge0" priority filter; policy accept;
        arp saddr ether c2:76:e5:71:e1:de arp daddr ether
36:b0:4a:e2:72:ea log prefix "netdev out: " flags all
    }
}
table bridge meh {
    chain input {
        type filter hook input priority filter; policy accept;
        arp saddr ether 36:b0:4a:e2:72:ea arp daddr ether
00:00:00:00:00:00 log prefix "bridge in: " flags all
    }

    chain output {
        type filter hook output priority filter; policy accept;
        arp saddr ether c2:76:e5:71:e1:de arp daddr ether
36:b0:4a:e2:72:ea log prefix "bridge out: " flags all
    }
}
table arp meh {
    chain input {
        type filter hook input priority filter; policy accept;
        arp saddr ether 36:b0:4a:e2:72:ea arp daddr ether
00:00:00:00:00:00 log prefix "arp in: " flags all
    }

    chain output {
        type filter hook output priority filter; policy accept;
        arp saddr ether c2:76:e5:71:e1:de arp daddr ether
36:b0:4a:e2:72:ea log prefix "arp out: " flags all
    }
}

which get me the following logs:

bridge in: IN=temp_tap OUT= MACSRC=36:b0:4a:e2:72:ea
MACDST=ff:ff:ff:ff:ff:ff MACPROTO=0806 ARP HTYPE=1 PTYPE=0x0800
OPCODE=1 MACSRC=36:b0:4a:e2:72:ea IPSRC=192.168.150.253
MACDST=00:00:00:00:00:00 IPDST=192.168.150.1
netdev in: IN=bridge0 OUT= MACSRC=36:b0:4a:e2:72:ea
MACDST=ff:ff:ff:ff:ff:ff MACPROTO=0806 ARP HTYPE=1 PTYPE=0x0800
OPCODE=1 MACSRC=36:b0:4a:e2:72:ea IPSRC=192.168.150.253
MACDST=00:00:00:00:00:00 IPDST=192.168.150.1
arp in: IN=bridge0 OUT= MACSRC=36:b0:4a:e2:72:ea
MACDST=ff:ff:ff:ff:ff:ff MACPROTO=0806 ARP HTYPE=1 PTYPE=0x0800
OPCODE=1 MACSRC=36:b0:4a:e2:72:ea IPSRC=192.168.150.253
MACDST=00:00:00:00:00:00 IPDST=192.168.150.1
arp out: IN= OUT=bridge0 MACSRC=8a:ff:ff:00:00:00
MACDST=00:00:1c:dc:90:74 MACPROTO=0000 ARP HTYPE=14000 PTYPE=0x4ae2
OPCODE=49782
netdev out: IN= OUT=bridge0 MACSRC=c2:76:e5:71:e1:de
MACDST=36:b0:4a:e2:72:ea MACPROTO=0806 ARP HTYPE=14000 PTYPE=0x4ae2
OPCODE=49782
bridge out: IN= OUT=temp_tap MACSRC=c2:76:e5:71:e1:de
MACDST=36:b0:4a:e2:72:ea MACPROTO=0806 ARP HTYPE=1 PTYPE=0x0800
OPCODE=2 MACSRC=c2:76:e5:71:e1:de IPSRC=192.168.150.1
MACDST=36:b0:4a:e2:72:ea IPDST=192.168.150.253

For some reasons, it seems that the Ethernet frame / SKB? (which
contains the *outbound* ARP packet) is not "parsed" correctly in the
arp and netdev family tables. As you can see, in case of arp family
table, MAC{SRC,DST,PROTO} have values that came from nowhere (and
therefore `ether sdddr|daddr` does not work as expected). In the case
of netdev family table, MAC{SRC,DST,PROTO} were fine, but it still try
to get the ARP header from the wrong place / offset (although `arp
saddr|daddr ether` works fine, as you can see). By contrast,
everything seems fine with the bridge family table.

Note that 14000 (HTYPE) is 0x36b0, with 0x4ae2 (PTYPE) they were the
first four octets of the expected MACDST. (Although not logged, HLEN
and PLEN would be 0x72 and 0xea respectively.) 47982 is 0xc276, which
were the first two octets of the expected MACSRC.

Tested with kernel 5.18.9. (The issue first came to my knowledge
through the post here: https://serverfault.com/q/1104251/569990)

Regards,
Tom
