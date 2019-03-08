Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0074AC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C513B2087C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfCHPu4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:50:56 -0500
Received: from mail.us.es ([193.147.175.20]:51106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfCHPuz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 10:50:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7CEE5E5399
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:50:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A74C6DA87D
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:50:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9947DDA87A; Fri,  8 Mar 2019 16:50:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B24F4DA796;
        Fri,  8 Mar 2019 16:50:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 16:50:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8DB144265A2F;
        Fri,  8 Mar 2019 16:50:49 +0100 (CET)
Date:   Fri, 8 Mar 2019 16:50:49 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling
 sctp_compute_cksum
Message-ID: <20190308155049.by7f4uzjxqnf3xu7@salvia>
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, Mar 03, 2019 at 04:17:21PM +0800, Xin Long wrote:
> sctp_hdr(skb) only works when skb->transport_header is set
> properly.
> 
> But in the path of nf_conntrack_in:
> 
>   sctp_packet() -> sctp_error() -> sctp_compute_cksum().
> 
> skb->transport_header is not guaranteed to be right value
> for sctp. It will cause to fail to check the checksum for
> sctp packets.
> 
> So fix it by setting skb transport_header before calling
> sctp_compute_cksum().

I see a few more calls to sctp_compute_cksum() in the netfilter tree.
I guess they are broken too.

In netfilter, skb->transport_header is never set from the input path,
I think this introduces an assymmetry with other transport protocols.

May we have a variant of sctp_compute_cksum() which does not rely on
sctp_hdr() instead?
