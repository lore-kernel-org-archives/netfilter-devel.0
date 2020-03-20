Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BD0C4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 19:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15A8020767
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 19:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgCTTFT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 15:05:19 -0400
Received: from correo.us.es ([193.147.175.20]:39672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTTFT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 15:05:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4F27EB46E
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 20:04:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D39D8DA3A1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 20:04:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C96AEDA39F; Fri, 20 Mar 2020 20:04:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BE12FC53E;
        Fri, 20 Mar 2020 20:04:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 20:04:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3C61442EE38E;
        Fri, 20 Mar 2020 20:04:42 +0100 (CET)
Date:   Fri, 20 Mar 2020 20:05:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nf_flow_table_offload: set
 hw_stats_type of flow_action_entry to FLOW_ACTION_HW_STATS_ANY
Message-ID: <20200320190513.cnp5relamfe5a35x@salvia>
References: <1584709029-20268-1-git-send-email-wenxu@ucloud.cn>
 <20200320130459.fxpsaebyoq4c6em2@salvia>
 <6644e52d-27d6-ec38-0435-def39ce6caf0@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6644e52d-27d6-ec38-0435-def39ce6caf0@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 20, 2020 at 09:55:35PM +0800, wenxu wrote:
> 
> 在 2020/3/20 21:04, Pablo Neira Ayuso 写道:
> > On Fri, Mar 20, 2020 at 08:57:09PM +0800, wenxu@ucloud.cn wrote:
> > > From: wenxu <wenxu@ucloud.cn>
> > > 
> > > Set hw_stats_type of flow_action_entry to FLOW_ACTION_HW_STATS_ANY to
> > > follow the driver behavior.
> > Now you have to explain me how you are going to use this.
> > 
> > There is no support for packet/bytes stats right now.
> > 
> > Thank you.
> 
> The FLOW_ACTION_HW_STATS_ANY flags is the default behavior and
> can avoid the failure of flow inserting. We don't nedd to use this.

OK, no worries, I'll keep back this patch. Thank you.
