Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11458C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 15:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBBCF2064B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 15:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfKZPiz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 10:38:55 -0500
Received: from correo.us.es ([193.147.175.20]:41400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfKZPiz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 10:38:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E619E6EAD8
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 16:38:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7CDBB8007
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 16:38:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD784B8004; Tue, 26 Nov 2019 16:38:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D395AB7FF6;
        Tue, 26 Nov 2019 16:38:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 Nov 2019 16:38:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ACDA342EE38F;
        Tue, 26 Nov 2019 16:38:49 +0100 (CET)
Date:   Tue, 26 Nov 2019 16:38:50 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191126153850.pblaoj4xklfz5jgv@salvia>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 26, 2019 at 02:30:02PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Hello Florian,
>
> Thank you very much for your reply. Once I changed to Input chain type, the rule worked. It seems iptables DO allow the same rule configuration see below:
>
> -A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
> -A KUBE-SERVICES -d 57.131.151.19/32 -p tcp -m comment --comment "default/portal:portal has no endpoints" -m tcp --dport 8989 -j REJECT --reject-with icmp-port-unreachable

static struct xt_target reject_tg_reg __read_mostly = {
        .name           = "REJECT",
        .family         = NFPROTO_IPV4,
        .target         = reject_tg,
        .targetsize     = sizeof(struct ipt_reject_info),
        .table          = "filter",
        .hooks          = (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
                          (1 << NF_INET_LOCAL_OUT),
        .checkentry     = reject_tg_check,
        .me             = THIS_MODULE,
};
