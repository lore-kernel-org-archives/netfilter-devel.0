Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAFCC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48FF0222A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKRV74 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:59:56 -0500
Received: from correo.us.es ([193.147.175.20]:51870 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfKRV74 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 16:59:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1AA111847B
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:59:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B31DDD1DBB
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:59:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8632DA72F; Mon, 18 Nov 2019 22:59:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E10A2202AE;
        Mon, 18 Nov 2019 22:59:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:59:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BC5D342EE38E;
        Mon, 18 Nov 2019 22:59:48 +0100 (CET)
Date:   Mon, 18 Nov 2019 22:59:50 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: nf_flow_table_offload: support
 tunnel match
Message-ID: <20191118215950.5xm6om55dd3krexs@salvia>
References: <1573819410-3685-1-git-send-email-wenxu@ucloud.cn>
 <20191115214827.lyu35l2y3nqusplh@salvia>
 <eb382034-7462-ef2c-4b76-518c488771f8@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb382034-7462-ef2c-4b76-518c488771f8@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 16, 2019 at 04:06:02PM +0800, wenxu wrote:
> 
> 在 2019/11/16 5:48, Pablo Neira Ayuso 写道:
> > On Fri, Nov 15, 2019 at 08:03:26PM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> This patch provide tunnel offload based on route lwtunnel. 
> >> The first two patches support indr callback setup
> >> Then add tunnel match and action offload
> > Could you provide a configuration script for this tunnel setup?
> >
> > Thanks.
> 
> The following is a simple configure for tunnel offload forward
> 
> 
> ip link add dev gre_sys type gretap key 1000
> 
> ip link add user1 type vrf table 1
> 
> ip l set dev gre1000 master user1
> 
> ip l set dev vf master user1
> 
> ip r a 10.0.0.7 dev vf table 1
> ip r a default via 10.0.0.100 encap ip id 1000 dst 172.168.0.7 key dev gre1000 table 1 onlink
> 
> nft add flowtable firewall fb1 { hook ingress priority 0 \;  flags offload \; devices = { gre1000, vf } \; }

Thanks for describing, but how does this work in software?

I'd appreciate if you can describe a configuration in software (no
offload) that I can use here for testing, including how you're
generating traffic there for testing.
