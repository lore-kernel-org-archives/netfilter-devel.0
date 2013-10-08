From: Anand Raj Manickam <anandrm@gmail.com>
Subject: iptables-nftables mnl_nft_batch_talk:: Invalid argument
Date: Tue, 8 Oct 2013 18:59:32 +0530
Message-ID: <CAEyr1FTqVgbM3zK-UAL0fHU4MRkYvf-xzNb7Cp7FQT3NQiMgXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48271 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3JHN3d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:29:33 -0400
Received: by mail-qa0-f54.google.com with SMTP id bv4so3763390qab.6
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Oct 2013 06:29:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When i run a simple rule like
# xtables -4 -A INPUT -s 1.1.1.1/32 -j ACCEPT
i get the following error.
mnl_nft_batch_talk:: Invalid argument
iptables: Invalid argument. Run `dmesg' for more information.

1579.346156] ip_tables: (C) 2000-2006 Netfilter Core Team
[ 1582.397561] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[ 1582.755111] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[ 1583.533624] Ebtables v2.0 registered
[ 1583.594789] ip6_tables: (C) 2000-2006 Netfilter Core Team
[ 2301.194401] Netfilter messages via NETLINK v0.30.
[ 2318.937750] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[1141676.975006] nf_tables_compat: (c) 2012 Pablo Neira Ayuso
<pablo@netfilter.org>

All the tool are updated to the latest , with 3.11 kernel
