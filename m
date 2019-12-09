Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFCCC43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 16:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D587B2073D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 16:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfLIQGb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 11:06:31 -0500
Received: from correo.us.es ([193.147.175.20]:53574 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfLIQGb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 11:06:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C91A117749
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 17:06:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20885DA711
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 17:06:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15FFBDA70D; Mon,  9 Dec 2019 17:06:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A21FDA702;
        Mon,  9 Dec 2019 17:06:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 17:06:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E71934265A5A;
        Mon,  9 Dec 2019 17:06:25 +0100 (CET)
Date:   Mon, 9 Dec 2019 17:06:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        geert@linux-m68k.org, jiri@mellanox.com
Subject: Re: [PATCH net] net: flow_dissector: fix tcp flags dissection on
 big-endian
Message-ID: <20191209160626.npmosk2ehmiuthya@salvia>
References: <20191209155530.3050-1-pablo@netfilter.org>
 <20191209160430.owxiyydj57mnjw2l@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209160430.owxiyydj57mnjw2l@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 09, 2019 at 05:04:30PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> Please, withdraw this patch.
>
> I can fix this by using TCPHDR_* definitions.

Oh actually, that's only true for my nf_flow_table_offload code.

But not for the flow dissector code, which is using tcp_flag_word().

I will revamp and send v2.
