Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E975AC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91D320854
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbfJOP6D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:58:03 -0400
Received: from correo.us.es ([193.147.175.20]:52070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731528AbfJOP6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 11:58:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDE9CBA1B9
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:57:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1181BAACC
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:57:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6C432DC79; Tue, 15 Oct 2019 17:57:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8C0DDA8E8;
        Tue, 15 Oct 2019 17:57:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 17:57:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9554F42EE38F;
        Tue, 15 Oct 2019 17:57:56 +0200 (CEST)
Date:   Tue, 15 Oct 2019 17:57:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 6/6] obj/tunnel: Fix for undefined behaviour
Message-ID: <20191015155758.ifghnxbbtgfnpdmt@salvia>
References: <20191015141658.11325-1-phil@nwl.cc>
 <20191015141658.11325-7-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015141658.11325-7-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 04:16:58PM +0200, Phil Sutter wrote:
> Cppcheck complains: Shifting signed 32-bit value by 31 bits is undefined
> behaviour.
> 
> Indeed, NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR enum value is 31. Make sure
> behaviour is as intended by shifting unsigned 1.
> 
> Fixes: ea63a05272f54 ("obj: add tunnel support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
