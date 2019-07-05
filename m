Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA56C46499
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 20:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B72A4216E3
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 20:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfGEUsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 16:48:41 -0400
Received: from mail.us.es ([193.147.175.20]:43226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbfGEUsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 16:48:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8836CFB6C3
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 22:48:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79258DA7B6
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 22:48:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6EB4CDA732; Fri,  5 Jul 2019 22:48:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C1CEDA704;
        Fri,  5 Jul 2019 22:48:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 22:48:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 573C64265A2F;
        Fri,  5 Jul 2019 22:48:37 +0200 (CEST)
Date:   Fri, 5 Jul 2019 22:48:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Update obsolete comments referring to
 ip_conntrack
Message-ID: <20190705204836.wfosjpa5q7thwohz@salvia>
References: <20190705085156.GA14117@jong.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705085156.GA14117@jong.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 05, 2019 at 11:51:57AM +0300, Yonatan Goldschmidt wrote:
> In 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.") the new
> generic nf_conntrack was introduced, and it came to supersede the
> old ip_conntrack.
> This change updates (some) of the obsolete comments referring to old
> file/function names of the ip_conntrack mechanism, as well as removes
> a few self-referencing comments that we shouldn't maintain anymore.
> 
> I did not update any comments referring to historical actions (e.g,
> comments like "this file was derived from ..." were left untouched,
> even if the referenced file is no longer here).

Patch does not apply, probably mangled by MUA?

# git am /tmp/yon.goldschmidt
Applying: netfilter: Update obsolete comments referring to ip_conntrack
error: patch failed: include/linux/netfilter/nf_conntrack_h323_asn1.h:1
error: include/linux/netfilter/nf_conntrack_h323_asn1.h: patch does not apply
error: patch failed: net/ipv4/netfilter/ipt_CLUSTERIP.c:416
error: net/ipv4/netfilter/ipt_CLUSTERIP.c: patch does not apply
error: patch failed: net/netfilter/nf_conntrack_core.c:1816
error: net/netfilter/nf_conntrack_core.c: patch does not apply
error: patch failed: net/netfilter/nf_conntrack_h323_asn1.c:1
error: net/netfilter/nf_conntrack_h323_asn1.c: patch does not apply
error: patch failed: net/netfilter/nf_conntrack_proto_icmp.c:215
error: net/netfilter/nf_conntrack_proto_icmp.c: patch does not apply
error: patch failed: net/netfilter/nf_nat_core.c:519
error: net/netfilter/nf_nat_core.c: patch does not apply
Patch failed at 0001 netfilter: Update obsolete comments referring to ip_conntrack
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
