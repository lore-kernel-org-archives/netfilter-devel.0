Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C09C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39554208C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfISJPL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:15:11 -0400
Received: from correo.us.es ([193.147.175.20]:59158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730506AbfISJPK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 05:15:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E4294A707E
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 11:15:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2022BDA840
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 11:15:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15EFBDA7B6; Thu, 19 Sep 2019 11:15:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E013D2B1E;
        Thu, 19 Sep 2019 11:15:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 11:15:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A690B4265A5A;
        Thu, 19 Sep 2019 11:15:04 +0200 (CEST)
Date:   Thu, 19 Sep 2019 11:15:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v6 0/8] netfilter: nf_tables_offload: support
 tunnel offload
Message-ID: <20190919091503.v4tfdmk7av2g2q3o@salvia>
References: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
 <ff59a395-b823-6e49-8241-8f2841523a87@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff59a395-b823-6e49-8241-8f2841523a87@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 18, 2019 at 04:02:51PM +0800, wenxu wrote:
> Hi pablo,
> 
> Any comments for this series?

Merge window is closed since Sunday. Last pull request was sent last
friday. Will get back to this one merge window reopens. Sorry.
