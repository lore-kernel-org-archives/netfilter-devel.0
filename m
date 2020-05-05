Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21516C47254
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 12:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2068206A5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 12:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgEEMai (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 08:30:38 -0400
Received: from correo.us.es ([193.147.175.20]:53662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgEEMai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 08:30:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC2BB39626D
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 14:30:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC30B1158E9
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 14:30:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DB4271158F4; Tue,  5 May 2020 14:30:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80F73207A1
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 14:30:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 14:30:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 668EA42EF9E0
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 14:30:34 +0200 (CEST)
Date:   Tue, 5 May 2020 14:30:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200505123034.GA16780@salvia>
References: <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
 <20200429132840.GA3833@dimstar.local.net>
 <20200429191047.GB3833@dimstar.local.net>
 <20200429191643.GA16749@salvia>
 <20200429203029.GD3833@dimstar.local.net>
 <20200429210512.GA14508@salvia>
 <20200430063404.GF3833@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430063404.GF3833@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

On Thu, Apr 30, 2020 at 04:34:04PM +1000, Duncan Roe wrote:
[..]
> Oh well in that case, how about:
> 
> >	struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buf_size, void *data, size_t len, size_t extra);

Getting better. But why do you still need 'extra'?

> I.e. exactly as you suggested in
> https://www.spinics.net/lists/netfilter-devel/msg65830.html except s/head/buf/
> 
> And we tell users to dimension buf to NFQ_BUFFER_SIZE. We don't even need to
> expose pktb_head_size().

NFQ_BUFFER_SIZE tells what is the maximum netlink message size coming
from the kernel. That netlink message contains metadata and the actual
payload data.

The pktbuff structure helps you deal with the payload data, not the
netlink message itself.
