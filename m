Return-Path: <SRS0=EbRH=2B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0147C00454
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 21:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0A120637
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 21:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfLKVxg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 16:53:36 -0500
Received: from correo.us.es ([193.147.175.20]:59274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfLKVxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 16:53:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FCB420A54C
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2019 22:53:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 319FCDA70C
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2019 22:53:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 26ED3DA703; Wed, 11 Dec 2019 22:53:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16B48DA707;
        Wed, 11 Dec 2019 22:53:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 22:53:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E6D044265A5A;
        Wed, 11 Dec 2019 22:53:30 +0100 (CET)
Date:   Wed, 11 Dec 2019 22:53:31 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH nf-next 4/7] netfilter: nft_tunnel: also dump
 ERSPAN_VERSION
Message-ID: <20191211215331.blitmzrg66towyqp@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e64595c27468e392826f0afb5f18b68ce258787a.1575779993.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Dec 08, 2019 at 12:41:34PM +0800, Xin Long wrote:
> This is not necessary, but it'll be easier to parse in userspace,
> also given that other places like act_tunnel_key, cls_flower and
> ip_tunnel_core are also doing so.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
