Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D01C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F9E206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfG3OnO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:43:14 -0400
Received: from correo.us.es ([193.147.175.20]:58964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbfG3OnO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:43:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F377011F023
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:43:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E451791F4
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:43:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA186DA732; Tue, 30 Jul 2019 16:43:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEE25FF6CC;
        Tue, 30 Jul 2019 16:43:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 16:43:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 883024265A2F;
        Tue, 30 Jul 2019 16:43:09 +0200 (CEST)
Date:   Tue, 30 Jul 2019 16:43:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chris PeBenito <chpebeni@linux.microsoft.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libiptc] libip6tc.h: Add extern "C" wrapping for C++
 linking.
Message-ID: <20190730144307.625q7berqsxnb7yu@salvia>
References: <20190715155855.4415-1-chpebeni@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715155855.4415-1-chpebeni@linux.microsoft.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Chris,

On Mon, Jul 15, 2019 at 11:58:55AM -0400, Chris PeBenito wrote:
[...]
> diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
> index 9aed80a0..eaf34d65 100644
> --- a/include/libiptc/libip6tc.h
> +++ b/include/libiptc/libip6tc.h
> @@ -12,6 +12,10 @@
>  #include <linux/netfilter_ipv6/ip6_tables.h>
>  #include <libiptc/xtcshared.h>
>  
> +#ifdef __cplusplus
> +extern "C" {
> +#endif

This patch is very small, it does not harm anyone I think.

However, please note that we've been discouraging people to use the
iptables blob interface for years.

This interface is prone to races (see the userspace lock and the -w
option in iptables) and the binary layout is obscure.

Not sure how advance you're in developing a userspace program using
this interface, if in early stage, I'd suggest you go for command (in
string format) pipe them to iptables-restore, which is what most
people do to implement third party software that generates rules for
iptables.

Thanks.
