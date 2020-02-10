Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D493C352A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 22:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111A720733
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 22:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBJWdt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 17:33:49 -0500
Received: from correo.us.es ([193.147.175.20]:56570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgBJWdt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 17:33:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2396AE8B61
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2020 23:33:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16977DA705
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2020 23:33:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0BC79DA703; Mon, 10 Feb 2020 23:33:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EDAADA701;
        Mon, 10 Feb 2020 23:33:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Feb 2020 23:33:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 01DEC426CCB9;
        Mon, 10 Feb 2020 23:33:46 +0100 (CET)
Date:   Mon, 10 Feb 2020 23:33:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft include v2 6/7] scanner: fix indesc_list stack to be
 in the correct order
Message-ID: <20200210223345.vvxnrb26ds5rhgoo@salvia>
References: <20200210101709.9182-1-fasnacht@protonmail.ch>
 <20200210101709.9182-7-fasnacht@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210101709.9182-7-fasnacht@protonmail.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 10:17:27AM +0000, Laurent Fasnacht wrote:
> This fixes the location displayed in error messages.
> 
> Signed-off-by: Laurent Fasnacht <fasnacht@protonmail.ch>
> ---
>  src/scanner.l | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/scanner.l b/src/scanner.l
> index 7f40c5c1..8407a2a1 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -668,7 +668,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  static void scanner_push_indesc(struct parser_state *state,
>  				struct input_descriptor *indesc)
>  {
> -	list_add_tail(&indesc->list, &state->indesc_list);
> +	if (!state->indesc) {
> +		list_add_tail(&indesc->list, &state->indesc_list);
> +	} else {
> +		list_add(&indesc->list, &state->indesc->list);
> +	}

Probably belongs to patch 4/7 ?
