Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E9FC33CB6
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFA022077B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgAPOJC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:09:02 -0500
Received: from correo.us.es ([193.147.175.20]:36784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgAPOJB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 09:09:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 546F22EFEAE
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:09:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4625DDA721
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 15:09:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D10BDA781; Thu, 16 Jan 2020 15:09:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2885EDA713;
        Thu, 16 Jan 2020 15:08:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 15:08:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0AAC342EF9E2;
        Thu, 16 Jan 2020 15:08:58 +0100 (CET)
Date:   Thu, 16 Jan 2020 15:08:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [net,v2] netfilter: nat: fix ICMP header corruption on ICMP
 errors
Message-ID: <20200116140857.ak3f744ewnlxdwfq@salvia>
References: <20200114080350.4693-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114080350.4693-1-eyal.birger@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 10:03:50AM +0200, Eyal Birger wrote:
> Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
> made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
> manipulation function for the outer packet on ICMP errors.
> 
> However, icmp_manip_pkt() assumes the packet has an 'id' field which
> is not correct for all types of ICMP messages.
> 
> This is not correct for ICMP error packets, and leads to bogus bytes
> being written the ICMP header, which can be wrongfully regarded as
> 'length' bytes by RFC 4884 compliant receivers.
> 
> Fix by assigning the 'id' field only for ICMP messages that have this
> semantic.

Applied, thanks.
