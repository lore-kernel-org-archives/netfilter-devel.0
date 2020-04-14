Return-Path: <SRS0=Os75=56=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3813C2BB1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Apr 2020 21:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97696206A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Apr 2020 21:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633810AbgDNVXq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 17:23:46 -0400
Received: from correo.us.es ([193.147.175.20]:45406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633777AbgDNVXn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 17:23:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89D79DA711
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2020 23:23:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7AF1EFA551
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2020 23:23:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 70A80FA525; Tue, 14 Apr 2020 23:23:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 352B9FA52A;
        Tue, 14 Apr 2020 23:23:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 14 Apr 2020 23:23:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 14AD64301DE0;
        Tue, 14 Apr 2020 23:23:39 +0200 (CEST)
Date:   Tue, 14 Apr 2020 23:23:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] libnetfilter_conntrack.pc.in: add LIBMNL_LIBS to
 Libs.Private
Message-ID: <20200414212338.gyceilnksvwrxucl@salvia>
References: <20200412121841.1070903-1-fontaine.fabrice@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412121841.1070903-1-fontaine.fabrice@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Apr 12, 2020 at 02:18:41PM +0200, Fabrice Fontaine wrote:
> Since version 1.0.8 and commit
> c1c0f16c1fedb46547c2e104beeaaeac5933b214, libnetfilter_conntrack depends
> on libmnl so add it to Libs.Private.
> 
> Otherwise, applications such as dnsmasq will fail to link on:
> 
> /home/buildroot/autobuild/instance-0/output-1/host/bin/arm-linux-gcc -Wl,-elf2flt -static -o dnsmasq cache.o rfc1035.o util.o option.o forward.o network.o dnsmasq.o dhcp.o lease.o rfc2131.o netlink.o dbus.o bpf.o helper.o tftp.o log.o conntrack.o dhcp6.o rfc3315.o dhcp-common.o outpacket.o radv.o slaac.o auth.o ipset.o domain.o dnssec.o blockdata.o tables.o loop.o inotify.o poll.o rrfilter.o edns0.o arp.o crypto.o dump.o ubus.o metrics.o -L/home/buildroot/autobuild/instance-0/output-1/host/bin/../arm-buildroot-uclinux-uclibcgnueabi/sysroot/usr/lib -lnetfilter_conntrack -L/home/buildroot/autobuild/instance-0/output-1/host/bin/../arm-buildroot-uclinux-uclibcgnueabi/sysroot/usr/lib -lnfnetlink
> /home/buildroot/autobuild/instance-0/output-1/host/opt/ext-toolchain/arm-buildroot-uclinux-uclibcgnueabi/bin/ld.real: /home/buildroot/autobuild/instance-0/output-1/host/bin/../arm-buildroot-uclinux-uclibcgnueabi/sysroot/usr/lib/libnetfilter_conntrack.a(api.o): in function `nfct_fill_hdr.constprop.4':
> api.c:(.text+0x34): undefined reference to `mnl_nlmsg_put_header'

Applied, thanks.

I think:

* libnetfilter_acct
* libnetfilter_cthelper
* libnetfilter_cttimeout
* libnetfilter_log
* libnetfilter_queue

need a similar fix.

> Fixes:
>  - http://autobuild.buildroot.org/results/3fdc2cba20162eb86eaa5c49a056fb40fb18a392
> 
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> ---
>  libnetfilter_conntrack.pc.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libnetfilter_conntrack.pc.in b/libnetfilter_conntrack.pc.in
> index 857f993..fbd7132 100644
> --- a/libnetfilter_conntrack.pc.in
> +++ b/libnetfilter_conntrack.pc.in
> @@ -12,5 +12,5 @@ Version: @VERSION@
>  Requires: libnfnetlink
>  Conflicts:
>  Libs: -L${libdir} -lnetfilter_conntrack
> -Libs.private: @LIBNFNETLINK_LIBS@
> +Libs.private: @LIBNFNETLINK_LIBS@ @LIBMNL_LIBS@
>  Cflags: -I${includedir}
> -- 
> 2.25.1
> 
