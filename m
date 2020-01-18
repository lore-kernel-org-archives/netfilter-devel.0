Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD390C32771
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89E5D24683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 20:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgARUoC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 15:44:02 -0500
Received: from correo.us.es ([193.147.175.20]:55786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbgARUoB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 15:44:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E1D039626C
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:44:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60BDEDA712
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 21:44:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5656DDA70F; Sat, 18 Jan 2020 21:44:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DD00DA715;
        Sat, 18 Jan 2020 21:43:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:43:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 50ACD41E4800;
        Sat, 18 Jan 2020 21:43:58 +0100 (CET)
Date:   Sat, 18 Jan 2020 21:43:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: Simplify struct pkt_buff: remove
 tail
Message-ID: <20200118204357.dg5b7qo5aqbesg4s@salvia>
References: <20200117113203.17313-1-duncan_roe@optusnet.com.au>
 <20200117140955.23823-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117140955.23823-1-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 18, 2020 at 01:09:55AM +1100, Duncan Roe wrote:
[...]
> diff --git a/src/internal.h b/src/internal.h
> index 0cfa425..dafb33a 100644
> --- a/src/internal.h
> +++ b/src/internal.h
> @@ -9,6 +9,7 @@
>  #else
>  #	define EXPORT_SYMBOL
>  #endif
> +#define PKTB_TAIL (pktb->data + pktb->len)

Instead of a macro, I'd suggest you add (something like):

static inline uint8_t *pktb_tail(struct pktbuff *pktb)
{
        return pktb->data + pktb->len;
}

Thanks.
