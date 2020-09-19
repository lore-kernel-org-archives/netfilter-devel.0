Return-Path: <SRS0=GOfq=C4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92F5C43464
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Sep 2020 16:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB8C208DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Sep 2020 16:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgISQD4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Sep 2020 12:03:56 -0400
Received: from correo.us.es ([193.147.175.20]:36424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgISQDz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Sep 2020 12:03:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26E7CEF433
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2020 17:54:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1897AFC5E0
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2020 17:54:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08282FC5E7; Sat, 19 Sep 2020 17:54:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0F53DA73D;
        Sat, 19 Sep 2020 17:54:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 19 Sep 2020 17:54:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A16E041E4800;
        Sat, 19 Sep 2020 17:54:05 +0200 (CEST)
Date:   Sat, 19 Sep 2020 17:54:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20200919155405.GA28410@salvia>
References: <cover.1598517739.git.lukas@wunner.de>
 <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lukas,

On Thu, Aug 27, 2020 at 10:55:03AM +0200, Lukas Wunner wrote:
[...]
> Overall, performance improves with this commit if neither netfilter nor
> traffic control is used. However it degrades a little if only traffic
> control is used, due to the "noinline", the additional outer static key
> and the added netfilter code:
> 
> * Before:       4730418pps 2270Mb/sec (2270600640bps)
> * After:        4759206pps 2284Mb/sec (2284418880bps)
> 
> * Before + tc:  4063912pps 1950Mb/sec (1950677760bps)
> * After  + tc:  4007728pps 1923Mb/sec (1923709440bps)
> 
> * After  + nft: 3714546pps 1782Mb/sec (1782982080bps)
[...]
> Commands to enable egress traffic control:
> tc qdisc add dev foo clsact
> tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'

1,6 0 0 0, means drop. This is a program with one instruction that
says "drop this packet".

> Commands to enable egress netfilter:
> nft add table netdev t
> nft add chain netdev t co \{ type filter hook egress device foo priority 0 \; \}
> nft add rule netdev t co ip daddr 4.3.2.1/32 drop

However, this is actually doing much more than that:

nft --debug=netlink add rule netdev t co ip daddr 4.3.2.1/32 drop
netdev 
  [ meta load protocol => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 4b @ network header + 16 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x01020304 ]
  [ immediate reg 0 drop ]

So this is comparing apples and pears in some way :-)

Then, I'd suggest the Netfilter ruleset to compare it with tc should be:

add table netdev t
add chain netdev t co { type filter hook egress device foo priority 0 ; policy drop; }

Would you redo these numbers using this ruleset to address Daniel's
comments regarding performance?

Moreover, Daniel also suggested dev_direct_xmit() path from AF_PACKET
allows packets to escape from policy, it seems this also needs to be
extended to add a hook there too.

Could you work on this and send a v2?

Thank you.
