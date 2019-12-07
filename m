Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED91BC2D0BE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 18:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3EB521835
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 18:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfLGSwh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Dec 2019 13:52:37 -0500
Received: from correo.us.es ([193.147.175.20]:51028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfLGSwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Dec 2019 13:52:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72D97508CEC
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2019 19:52:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6375ADA710
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Dec 2019 19:52:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57AECDA705; Sat,  7 Dec 2019 19:52:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52320DA705;
        Sat,  7 Dec 2019 19:52:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Dec 2019 19:52:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 27B1D4265A5A;
        Sat,  7 Dec 2019 19:52:32 +0100 (CET)
Date:   Sat, 7 Dec 2019 19:52:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marco Oliverio <marco.oliverio@tanaza.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, rocco.folino@tanaza.com
Subject: Re: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Message-ID: <20191207185232.eau34ble7eigv2vq@salvia>
References: <20191202185430.31367-1-marco.oliverio@tanaza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202185430.31367-1-marco.oliverio@tanaza.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 07:54:30PM +0100, Marco Oliverio wrote:
> Bridge packets that are forwarded have skb->dst == NULL and get
> dropped by the check introduced by
> b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
> return true when dst is refcounted).
> 
> To fix this we check skb_dst() before skb_dst_force(), so we don't
> drop skb packet with dst == NULL. This holds also for skb at the
> PRE_ROUTING hook so we remove the second check.

Applied, thanks.
