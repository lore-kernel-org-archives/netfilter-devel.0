Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E66C2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0162206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfL3Lya (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:54:30 -0500
Received: from correo.us.es ([193.147.175.20]:48114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfL3Lya (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:54:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D0493C3A17
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:53:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1ADCDA70E
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:53:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7429DA701; Mon, 30 Dec 2019 12:53:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 984B5DA70E;
        Mon, 30 Dec 2019 12:53:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:53:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [185.124.28.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4E3C342EE38F;
        Mon, 30 Dec 2019 12:53:23 +0100 (CET)
Date:   Mon, 30 Dec 2019 12:53:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue 1/2] src: tcp.c: change 1 remaining
 pkt formal arg to pktb
Message-ID: <20191230115321.oganzk6xmfsylcmz@salvia>
References: <20191228012357.2474-1-duncan_roe@optusnet.com.au>
 <20191228012357.2474-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191228012357.2474-2-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 28, 2019 at 12:23:56PM +1100, Duncan Roe wrote:
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/extra/tcp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/src/extra/tcp.c b/src/extra/tcp.c
> index 8119843..2296bef 100644
> --- a/src/extra/tcp.c
> +++ b/src/extra/tcp.c
> @@ -188,17 +188,17 @@ int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
>   * \note This function recalculates the IPv4 and TCP checksums for you.
>   */
>  EXPORT_SYMBOL
> -int nfq_tcp_mangle_ipv4(struct pkt_buff *pkt,
> +int nfq_tcp_mangle_ipv4(struct pkt_buff *pktb,

Via git grep I can see more references to pkt instead pktb, if you
prefer pktb for consistency that's fine indeed. I'd suggest you send a
patch to update all the existing references in this tree to use pktb
as you do here.

Thanks.
