Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BECFC33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D2E20721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgAJLMX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:12:23 -0500
Received: from correo.us.es ([193.147.175.20]:49666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbgAJLMX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 06:12:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12A9415AB80
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 12:12:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05D22DA707
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 12:12:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF395DA720; Fri, 10 Jan 2020 12:12:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6765DA707;
        Fri, 10 Jan 2020 12:12:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 10 Jan 2020 12:12:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C9ABD42EE393;
        Fri, 10 Jan 2020 12:12:18 +0100 (CET)
Date:   Fri, 10 Jan 2020 12:12:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC libnetfilter_queue] src: Simplify struct pkt_buff
Message-ID: <20200110111218.rd5c7basrv24jxqg@salvia>
References: <20200110040925.16124-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110040925.16124-1-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 10, 2020 at 03:09:25PM +1100, Duncan Roe wrote:
> In struct pkt_buff:
> - We only ever needed any 2 of len, data and tail.

You can remove ->tail.

>   This has caused bugs in the past, e.g. commit 8a4316f31.
>   Delete len, and where the value of pktb->len was required,
>   use new PKTB_LEN macro.

I would leave pktb->len in please, it keeps things simple. Otherwise,
I would suggest to remove pktb->data_len, keep pktb->len in place and
reallocate the data buffer only in case of mangling.

> - head and data always had the same value.
>   head was in the minority, so replace with data where it was used.

This item above also looks fine.

Probably you can split this in several patches, one for each item.

Thanks.
