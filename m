Return-Path: <SRS0=bD7Q=5E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFC8C4332D
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 20:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B468206D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 20:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCSUHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:07:42 -0400
Received: from correo.us.es ([193.147.175.20]:52928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgCSUHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 16:07:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4CC1120828
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 21:07:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0F55FC5F1
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 21:07:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3651FC5EE; Thu, 19 Mar 2020 21:07:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D872AFC5EA;
        Thu, 19 Mar 2020 21:07:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Mar 2020 21:07:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BB09342EFB81;
        Thu, 19 Mar 2020 21:07:07 +0100 (CET)
Date:   Thu, 19 Mar 2020 21:07:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_flow_table_offload: fix potential
 NULL pointer dereference for dst_cache in handling lwtstate
Message-ID: <20200319200738.v3h63ozhpl5zpkrw@salvia>
References: <1584593565-23692-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584593565-23692-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 19, 2020 at 12:52:45PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> All the handler in flow_offload_work_handler can be used by both
> nft-flowtable and act_ct-flowtable. Flowtable in act_ct zero the
> dst_cache ptr in the flow_offload.

Applied as:

  netfilter: flowtable: fix NULL pointer dereference in tunnel offload support

  The tc ct action does not cache the route in the flowtable entry.

thank you.
