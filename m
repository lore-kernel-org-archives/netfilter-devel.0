Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F097C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B6A9229EB
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfGWT0t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 15:26:49 -0400
Received: from mail.us.es ([193.147.175.20]:37502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfGWT0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 15:26:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9BB3F2690
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:26:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AA63DA708
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:26:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 900B6CE158; Tue, 23 Jul 2019 21:26:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78D96DA708;
        Tue, 23 Jul 2019 21:26:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 21:26:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 241E84265A2F;
        Tue, 23 Jul 2019 21:26:45 +0200 (CEST)
Date:   Tue, 23 Jul 2019 21:26:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] nfnl_osf: fix snprintf -Wformat-truncation
 warning
Message-ID: <20190723192643.fgebvf5wdbs4zzvx@salvia>
References: <20190721192415.12204-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190721192415.12204-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 21, 2019 at 09:24:15PM +0200, Fernando Fernandez Mancera wrote:
> Fedora 30 uses very recent gcc (version 9.1.1 20190503 (Red Hat 9.1.1-1)),
> osf produces following warnings:
> 
> -Wformat-truncation warning have been introduced in the version 7.1 of gcc.
> Also, remove a unneeded address check of "tmp + 1" in nf_osf_strchr().

nfnl_osf.c: In function ‘osf_load_line’:
nfnl_osf.c:372:14: error: ‘subtype’ undeclared (first use in this
function)
  372 |   i = sizeof(subtype);
      |              ^~~~~~~

Hitting this here after this patch.
