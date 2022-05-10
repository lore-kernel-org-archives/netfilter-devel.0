Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A512C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 May 2022 09:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbiEJKCv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 May 2022 06:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239413AbiEJKCs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 May 2022 06:02:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 190311668A9;
        Tue, 10 May 2022 02:58:48 -0700 (PDT)
Date:   Tue, 10 May 2022 11:58:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Sven Auhagen <Sven.Auhagen@voleatech.de>,
        0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf_flowtable]  2cd764935d:
 kernel-selftests.netfilter.nft_flowtable.sh.ipsec_tunnel_mode_for_ns1/ns2.fail
Message-ID: <Yno3VXOUEzAOSdDe@salvia>
References: <20220427071515.qfgqbs6uzoowwnkg@SvensMacbookPro.hq.voleatech.com>
 <20220510092803.GA3969@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220510092803.GA3969@xsang-OptiPlex-9020>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, May 10, 2022 at 05:28:03PM +0800, kernel test robot wrote:
[...] 
> # selftests: netfilter: nft_flowtable.sh
> # PASS: netns routing/connectivity: ns1 can reach ns2
> # FAIL: file mismatch for ns1 -> ns2
> # -rw------- 1 root root 227328 May  8 22:05 /tmp/tmp.fnnwOCWcA4
> # -rw------- 1 root root 99388 May  8 22:05 /tmp/tmp.LL8ohakyGQ
> # FAIL: file mismatch for ns1 <- ns2
> # -rw------- 1 root root 296960 May  8 22:05 /tmp/tmp.1DlwdJLSUX
> # -rw------- 1 root root 15584 May  8 22:05 /tmp/tmp.HnObAriWng
> # FAIL: flow offload for ns1/ns2:
> # table inet filter {
> # 	flowtable f1 {
> # 		hook ingress priority 0
> # 		devices = { veth0, veth1 }
> # 	}
> # 
> # 	chain forward {
> # 		type filter hook forward priority 0; policy drop;
> # 		oif "veth1" tcp dport 12345 flow offload @f1 counter packets 0 bytes 0
> # 		tcp dport 12345 meta length > 200 ct mark set 0x00000001 counter packets 14 bytes 103660
> # 		tcp flags fin,rst ct mark set 0x00000000 accept
> # 		meta length > 1500 accept comment "something-to-grep-for"
> # 		tcp sport 12345 ct mark 0x00000001 counter packets 57 bytes 8220 log prefix "mark failure " drop
> # 		ct state established,related accept
> # 		meta length < 200 oif "veth1" tcp dport 12345 counter packets 1 bytes 60 accept
> # 		meta l4proto icmp accept
> # 		meta l4proto ipv6-icmp accept
> # 	}
> # }
> # /dev/stdin:4:73-74: Error: syntax error, unexpected to, expecting newline or semicolon
> #       meta iif "veth0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
> #                                                                         ^^

What nftables userspace version is kbuild robot using?

It seems this rule fails to load, looks like a unrelated issue?
