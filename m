Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BE8C2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FBDA20838
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBGRD4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:03:56 -0500
Received: from correo.us.es ([193.147.175.20]:39540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbgBGRD4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 12:03:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72E5411EBA5
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 18:03:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 657AADA715
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 18:03:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 64E50DA712; Fri,  7 Feb 2020 18:03:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F557DA71F;
        Fri,  7 Feb 2020 18:03:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 18:03:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C98F942EFB80;
        Fri,  7 Feb 2020 18:03:52 +0100 (CET)
Date:   Fri, 7 Feb 2020 18:03:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] scanner: remove indescs and indescs_idx
 attributes from the parser, and directly use indesc_list
Message-ID: <20200207170347.fs2r5keqsgecrevl@salvia>
References: <20200205122858.20575-1-fasnacht@protonmail.ch>
 <20200205122858.20575-4-fasnacht@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205122858.20575-4-fasnacht@protonmail.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 05, 2020 at 12:30:24PM +0000, Laurent Fasnacht wrote:
[...]
> @@ -915,15 +919,14 @@ void scanner_push_buffer(void *scanner, const struct input_descriptor *indesc,
>  {
>  	struct parser_state *state = yyget_extra(scanner);
>  	YY_BUFFER_STATE b;
> +	struct input_descriptor *new_indesc;
>  
> -	state->indesc = xzalloc(sizeof(struct input_descriptor));
> -	state->indescs[state->indesc_idx] = state->indesc;
> -	state->indesc_idx++;
> +	new_indesc = xzalloc(sizeof(struct input_descriptor));

I'd appreciate if you could split initially cleanups in separated
patches. Like adding this new variable.

> -	memcpy(state->indesc, indesc, sizeof(*state->indesc));
> -	state->indesc->data = buffer;
> -	state->indesc->name = NULL;
> -	list_add_tail(&state->indesc->list, &state->indesc_list);
> +	memcpy(new_indesc, indesc, sizeof(*new_indesc));
> +	new_indesc->data = buffer;
> +	new_indesc->name = NULL;
> +	scanner_push_indesc(state, new_indesc);
>  
>  	b = yy_scan_string(buffer, scanner);
>  	assert(b != NULL);
> @@ -940,35 +943,22 @@ void *scanner_init(struct parser_state *state)
>  	return scanner;
>  }
>  
> -static void input_descriptor_destroy(const struct input_descriptor *indesc)
> -{
> -	if (indesc->name)
> -		xfree(indesc->name);
> -	xfree(indesc);
> -}

Or removing this function, actually there is no need to check if
indesc->name != NULL, so just:

        xfree(indesc->name);
        xfree(indesc);

is probably fine while you are here.

That will make it easier for us to track changes.

Thanks!
