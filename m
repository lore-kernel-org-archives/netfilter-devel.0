Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAF7C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A374424679
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLSXfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:35:45 -0500
Received: from correo.us.es ([193.147.175.20]:55030 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfLSXfp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 18:35:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE7ABC39F4
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 00:35:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C03BCDA705
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 00:35:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3C12DA702; Fri, 20 Dec 2019 00:35:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73F36DA702;
        Fri, 20 Dec 2019 00:35:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Dec 2019 00:35:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 56DC942EF42A;
        Fri, 20 Dec 2019 00:35:40 +0100 (CET)
Date:   Fri, 20 Dec 2019 00:35:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 3/3] netfilter: nf_flow_table_offload: fix the nat
 port mangle.
Message-ID: <20191219233540.u6sebinip62v3bnk@salvia>
References: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
 <1576572767-19779-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576572767-19779-4-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 17, 2019 at 04:52:47PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> For dnat:
> The original dir maybe modify the dst port to src port of reply dir
> The reply dir maybe modify the src port to dst port of origin dir
> 
> For snat:
> The original dir maybe modify the src port to dst port of reply dir
> The reply dir maybe modify the dst port to src port of reply dir

Good catch.

Probably this description is better, and good for the record:

                SNAT         after mangling
    original   A -> B   =>    _FW_ -> B
     reply     B -> FW  =>       B -> _A_

                DNAT         after mangling
    original   A -> FW  =>       A -> _B_
     reply     B -> A   =>     _FW_-> A

This patch is also fixing incorrect 7acd9378dc652 BTW.

Thanks.
