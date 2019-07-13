Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBFFC31E40
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 18:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C12920848
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 18:45:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8JUmKLA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfGMSpW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 14:45:22 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:39914 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbfGMSpV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 14:45:21 -0400
Received: by mail-ed1-f52.google.com with SMTP id m10so11915881edv.6
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Jul 2019 11:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rZ421yy419gBa9zp5kiXF44KKjufyUDiz9clkqW4qfM=;
        b=m8JUmKLATCYMexNllXLbAmZ/yqKujnJ+d0BbEVxBUCq1edvkjfwDLNaggsfq5cPl3f
         ypr4o0FSHQmTl/xDTonvT/Yg3O/MgUxUjXyxc4Y7uiORZ0X+pzCQhUDbagb92t2V045X
         daXY8n2a24v+pnH4KGCoRJOFxvuLW76+ET1tYLYsULGXBXcGX0OXug3W5YJ7KF37sSsd
         BsHZgxdxlB52bolU1fyENzu002so3uZQLWMzqd2pP8ZEfHwwqdWdH0wZYAqM9LTwYRHT
         FdabqOloGR+WDRFu1UUh2NIXttPGX8mBGU/pdby11gyjX3F1tYWpJ3qCTBpHyws+6XpB
         OaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rZ421yy419gBa9zp5kiXF44KKjufyUDiz9clkqW4qfM=;
        b=UbFLMBkjfPnCtAEGSbccZaSQ2ESjhMdFP/1GrdkATafdVZpFU2HREl8YUF85LKBrxs
         14+y6UNg2jicWiPWCnmDXozbjuw1XbfJGEqk3eYuOrXRYpX6sC+K1dd3YY04b3XcWsft
         pNY3nGWnJdh0wbCgFmSa9/eBm5tasbeiViY3XBqrFNpmdj44wgYz390G99GRDXv9h+Cl
         kiEOdXBQzsNPp7VsZrX89DMhMTLkR1I1GM/+rNK6j4rwTjMxREmGIMevU/CWr/RP8QzO
         rhwq2LYFeCyQwkre7gL1sZ1nJqsZP7JL0JOjOo0opUEOuOG5DtVD+xFMASf7Jq74xm8D
         IQFw==
X-Gm-Message-State: APjAAAUq0F0aYUEEuFwH/kcsIBekxBAFNaKwuLVQYXhCDPpiNHmCYyeU
        tqwM3EzIVP46xo5Qo+SRFLOFu1Ujo2Ofbcb2fPcG5u3J
X-Google-Smtp-Source: APXvYqxa4/upk/diAroUK+A+lN4PS4DASu/wn0U4vo9mmvhJOnmt345PMfz+bkefNuWF29MD7HMQsRKemPCgSRuWTJ8=
X-Received: by 2002:a17:906:318e:: with SMTP id 14mr13673871ejy.85.1563043519108;
 Sat, 13 Jul 2019 11:45:19 -0700 (PDT)
MIME-Version: 1.0
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Sat, 13 Jul 2019 21:45:08 +0300
Message-ID: <CADxRZqwxBCV6G2OMjuv3S49MsDeSuAHfN8vnVSFm_Uvv1BD1Og@mail.gmail.com>
Subject: [sparc64] nft bus error
To:     netfilter-devel@vger.kernel.org
Cc:     coreteam@netfilter.org,
        debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!

Getting nft (libnftnl) bus error with sparc64 linux machine.

using git version of libnftnl and nftables (installed under /opt/nft):
mator@ttip:/1/mator/libnftnl$ git desc
libnftnl-1.1.3-7-ga6a2d0c
mator@ttip:/1/mator/libnftnl$ cd ../nftables/
mator@ttip:/1/mator/nftables$ git desc
v0.9.1-25-g87c0bee

# which nft
/opt/nft/sbin/nft
# nft  list tables
table ip sshguard
table ip6 sshguard
(loading some rules)
# nft -f /etc/nft.rules
# nft  list tables
Bus error
(run under gdb)
# gdb -q /opt/nft/sbin/nft
Reading symbols from /opt/nft/sbin/nft...done.
(gdb) set args list tables
(gdb) run
Starting program: /opt/nft/sbin/nft list tables

Program received signal SIGBUS, Bus error.
0xfff8000100946490 in nftnl_udata_get_u32 (attr=0x10000106e30) at udata.c:127
127             return *data;
(gdb) bt
#0  0xfff8000100946490 in nftnl_udata_get_u32 (attr=0x10000106e30) at
udata.c:127
#1  0xfff8000100168db8 in netlink_delinearize_set (ctx=0x7feffffee08,
nls=0x100001076e0) at netlink.c:568
#2  0xfff800010016929c in list_set_cb (nls=0x100001076e0,
arg=0x7feffffee08) at netlink.c:647
#3  0xfff800010094083c in nftnl_set_list_foreach
(set_list=0x10000107640, cb=0xfff8000100169278 <list_set_cb>,
data=0x7feffffee08) at set.c:780
#4  0xfff80001001693a4 in netlink_list_sets (ctx=0x7feffffee08,
h=0x10000107160) at netlink.c:668
#5  0xfff800010013ba90 in cache_init_objects (ctx=0x7feffffee08,
flags=127) at rule.c:161
#6  0xfff800010013be98 in cache_init (ctx=0x7feffffee08, flags=127) at
rule.c:220
#7  0xfff800010013c0b8 in cache_update (nft=0x10000106a20, flags=127,
msgs=0x7fefffff140) at rule.c:258
#8  0xfff800010018cca4 in nft_evaluate (nft=0x10000106a20,
msgs=0x7fefffff140, cmds=0x7fefffff130) at libnftables.c:406
#9  0xfff800010018cf4c in nft_run_cmd_from_buffer (nft=0x10000106a20,
buf=0x10000106d40 "list tables") at libnftables.c:447
#10 0x0000010000002088 in main (argc=3, argv=0x7fefffff618) at main.c:316
(gdb)




# cat /etc/nft.rules
# Translated by iptables-restore-translate v1.8.3 on Sat Jul 13 10:53:36 2019
add table ip filter
add chain ip filter INPUT { type filter hook input priority 0; policy accept; }
add chain ip filter FORWARD { type filter hook forward priority 0;
policy accept; }
add chain ip filter OUTPUT { type filter hook output priority 0;
policy accept; }
# -t filter -A INPUT -p tcp --dport 22 -m set --match-set sshguard4 src -j DROP
add rule ip filter INPUT iifname "lo" counter accept
add rule ip filter INPUT ct state related,established counter accept
add rule ip filter INPUT ct state new  tcp dport 22 counter accept
add rule ip filter INPUT ip saddr 10.8.1.0/24 counter accept
add rule ip filter INPUT ip protocol icmp counter accept
add rule ip filter INPUT ip protocol udp udp dport 33434-33529 counter accept
add rule ip filter INPUT iifname "eth0" ip saddr 10.190.2.0/24 ct
state new  tcp dport 445 counter accept
add rule ip filter INPUT iifname "eth0" ip saddr 10.190.2.0/24 ct
state new  udp dport 445 counter accept
add rule ip filter INPUT iifname "eth0" ip saddr 192.168.158.0/24 ct
state new  tcp dport 445 counter accept
add rule ip filter INPUT iifname "eth0" ip saddr 192.168.158.0/24 ct
state new  udp dport 445 counter accept
add rule ip filter INPUT ip protocol tcp tcp dport { 80,443} counter accept
add rule ip filter INPUT counter drop
add table ip nat
add chain ip nat PREROUTING { type nat hook prerouting priority -100;
policy accept; }
add chain ip nat INPUT { type nat hook input priority 100; policy accept; }
add chain ip nat OUTPUT { type nat hook output priority -100; policy accept; }
add chain ip nat POSTROUTING { type nat hook postrouting priority 100;
policy accept; }
# Completed on Sat Jul 13 10:53:36 2019


machine info:

nftables$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/sparc64-linux-gnu/8/lto-wrapper
Target: sparc64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian
8.3.0-7' --with-bugurl=file:///usr/share/doc/gcc-8/README.Bugs
--enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++ --prefix=/usr
--with-gcc-major-version-only --program-suffix=-8
--program-prefix=sparc64-linux-gnu- --enable-shared
--enable-linker-build-id --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --libdir=/usr/lib
--enable-nls --enable-clocale=gnu --enable-libstdcxx-debug
--enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new
--enable-gnu-unique-object --disable-libquadmath
--disable-libquadmath-support --enable-plugin --enable-default-pie
--with-system-zlib --disable-libphobos --enable-objc-gc=auto
--enable-multiarch --disable-werror --with-cpu-32=ultrasparc
--enable-targets=all --with-long-double-128 --enable-multilib
--enable-checking=release --build=sparc64-linux-gnu
--host=sparc64-linux-gnu --target=sparc64-linux-gnu
Thread model: posix
gcc version 8.3.0 (Debian 8.3.0-7)

nftables$ ld -V
GNU ld (GNU Binutils for Debian) 2.32.51.20190707
  Supported emulations:
   elf64_sparc
   elf32_sparc

# ldconfig -V
ldconfig (Debian GLIBC 2.28-10) 2.28

# uname -a
Linux ttip 5.2.0-rc6-00001-g9014143bab2f #1064 SMP Sat Jul 13 21:36:42
MSK 2019 sparc64 GNU/Linux
