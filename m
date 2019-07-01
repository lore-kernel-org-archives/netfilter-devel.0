Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6714AC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4828C2146F
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfGAS0A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:26:00 -0400
Received: from mail.us.es ([193.147.175.20]:53556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfGASZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 14:25:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1539E6D99A
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:25:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04A971021A6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:25:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EE86210219C; Mon,  1 Jul 2019 20:25:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07CFD6DA85;
        Mon,  1 Jul 2019 20:25:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Jul 2019 20:25:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DACBA4265A2F;
        Mon,  1 Jul 2019 20:25:55 +0200 (CEST)
Date:   Mon, 1 Jul 2019 20:25:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 3/3] libnftables: export public symbols only
Message-ID: <20190701182555.6wkueskff6pmwuwy@salvia>
References: <156197834773.14440.15033673835278456059.stgit@endurance>
 <156197840229.14440.6449813194254743291.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156197840229.14440.6449813194254743291.stgit@endurance>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 12:53:28PM +0200, Arturo Borrero Gonzalez wrote:
[...]
> With this patch, libnftables symbols are:
> 
> % dpkg-gensymbols -q -plibnftables -v0.9.1 -O -esrc/.libs/libnftables.so.1
> libnftables.so.1 libnftables #MINVER#
>  nft_ctx_add_include_path@Base 0.9.1
>  nft_ctx_buffer_error@Base 0.9.1
>  nft_ctx_buffer_output@Base 0.9.1
>  nft_ctx_clear_include_paths@Base 0.9.1
>  nft_ctx_free@Base 0.9.1
>  nft_ctx_get_dry_run@Base 0.9.1
>  nft_ctx_get_error_buffer@Base 0.9.1
>  nft_ctx_get_output_buffer@Base 0.9.1
>  nft_ctx_new@Base 0.9.1
>  nft_ctx_output_get_debug@Base 0.9.1
>  nft_ctx_output_get_flags@Base 0.9.1
>  nft_ctx_output_set_debug@Base 0.9.1
>  nft_ctx_output_set_flags@Base 0.9.1
>  nft_ctx_set_dry_run@Base 0.9.1
>  nft_ctx_set_error@Base 0.9.1
>  nft_ctx_set_output@Base 0.9.1
>  nft_ctx_unbuffer_error@Base 0.9.1
>  nft_ctx_unbuffer_output@Base 0.9.1
>  nft_run_cmd_from_buffer@Base 0.9.1
>  nft_run_cmd_from_filename@Base 0.9.1

Applied, thanks Arturo.
