Return-Path: <SRS0=UCCN=WL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC1EC3A589
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 14:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25ACD206C1
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 14:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbfHOOZw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Aug 2019 10:25:52 -0400
Received: from correo.us.es ([193.147.175.20]:54826 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731473AbfHOOZw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Aug 2019 10:25:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BE68DA7EA
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2019 16:25:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F46ED2CB5
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2019 16:25:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74F6DD2CAD; Thu, 15 Aug 2019 16:25:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F20EDA801;
        Thu, 15 Aug 2019 16:25:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Aug 2019 16:25:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E23E84265A2F;
        Thu, 15 Aug 2019 16:25:44 +0200 (CEST)
Date:   Thu, 15 Aug 2019 16:25:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] meta: add ibrpvid and ibrvproto support
Message-ID: <20190815142545.gvknivefzvr454fl@salvia>
References: <1565839996-4057-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565839996-4057-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 15, 2019 at 11:33:16AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This allows you to match the bridge pvid and vlan protocol, for
> instance:
> 
> nft add rule bridge firewall zones meta ibrvproto 0x8100
> nft add rule bridge firewall zones meta ibrpvid 100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  src/meta.c                  |  6 ++++++
>  tests/py/bridge/meta.t      |  2 ++
>  tests/py/bridge/meta.t.json | 26 ++++++++++++++++++++++++++

.payload is missing?
