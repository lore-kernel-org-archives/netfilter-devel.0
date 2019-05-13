Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC118C04AB1
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCA12085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfEMJWS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 05:22:18 -0400
Received: from mail.us.es ([193.147.175.20]:35442 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbfEMJWS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 05:22:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6FB131C4384
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:22:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FC52DA706
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:22:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 54D31DA717; Mon, 13 May 2019 11:22:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D337DA709;
        Mon, 13 May 2019 11:22:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:22:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D5D144265A32;
        Mon, 13 May 2019 11:22:11 +0200 (CEST)
Date:   Mon, 13 May 2019 11:22:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jagdish Motwani <j.k.motwani@gmail.com>
Cc:     netdev@vger.kernel.org,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_queue:fix reinject verdict handling
Message-ID: <20190513092211.isxyzpytenvocbx2@salvia>
References: <20190508183114.7507-1-j.k.motwani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508183114.7507-1-j.k.motwani@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jagdish,

On Thu, May 09, 2019 at 12:01:14AM +0530, Jagdish Motwani wrote:
> From: Jagdish Motwani <jagdish.motwani@sophos.com>
> 
> In case of more than 1 nf_queues, hooks between them are being executed
> more than once.

This refers to NF_REPEAT, correct?

I think this broke with 960632ece6949. If so, it would be good to add
the following tag to this patch then. It's useful for robots
collecting fixes for -stable kernels.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")

> Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>

Thanks.
