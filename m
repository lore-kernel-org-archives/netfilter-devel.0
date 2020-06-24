Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C97C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B9A2084D
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbgFXKzb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:55:31 -0400
Received: from correo.us.es ([193.147.175.20]:45302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgFXKza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 06:55:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C15E6E8E86
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:55:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2DB8DA84A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:55:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B1C11DA840; Wed, 24 Jun 2020 12:55:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 736E2DA796;
        Wed, 24 Jun 2020 12:55:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 12:55:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5790242EF42A;
        Wed, 24 Jun 2020 12:55:27 +0200 (CEST)
Date:   Wed, 24 Jun 2020 12:55:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel =?iso-8859-1?Q?Gr=F6ber?= <dxld@darkboxed.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnf_ct resend PATCH 5/8] Add asizeof() macro
Message-ID: <20200624105526.GA20575@salvia>
References: <20200623123403.31676-1-dxld@darkboxed.org>
 <20200623123403.31676-6-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623123403.31676-6-dxld@darkboxed.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 23, 2020 at 02:34:00PM +0200, Daniel Gröber wrote:
> Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
> ---
>  include/internal/internal.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/internal/internal.h b/include/internal/internal.h
> index 859724b..68c5ef0 100644
> --- a/include/internal/internal.h
> +++ b/include/internal/internal.h
> @@ -40,6 +40,8 @@
>  #define IPPROTO_DCCP 33
>  #endif
>  
> +#define asizeof(x) (sizeof(x) / sizeof(*x))

Please call this ARRAY_SIZE.

Thanks.
