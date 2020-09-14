Return-Path: <SRS0=xYKs=CX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C23BC433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 10:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37EB520829
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 10:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgINKqa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Sep 2020 06:46:30 -0400
Received: from correo.us.es ([193.147.175.20]:41338 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgINKqK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 06:46:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 74B8FF258B
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:46:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65444DA793
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:46:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5AF56DA789; Mon, 14 Sep 2020 12:46:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 420BDDA789;
        Mon, 14 Sep 2020 12:46:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Sep 2020 12:46:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2463A42EF9E1;
        Mon, 14 Sep 2020 12:46:06 +0200 (CEST)
Date:   Mon, 14 Sep 2020 12:46:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Gopal Yadav <gopunop@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Solves Bug 1388 - Combining --terse with --json has no
 effect
Message-ID: <20200914104605.GA1617@salvia>
References: <CAAUOv8iVoKLZxx1xGVLj-=k4pSNyES5SWaaScx=17WV789Kw3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAUOv8iVoKLZxx1xGVLj-=k4pSNyES5SWaaScx=17WV789Kw3Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Gopal,

On Fri, Sep 11, 2020 at 11:04:57PM +0530, Gopal Yadav wrote:
> Solves Bug 1388 - Combining --terse with --json has no effect
> 
> Signed-off-by: Gopal Yadav <gopunop@gmail.com>
> ---
>  src/json.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/json.c b/src/json.c
> index a9f5000f..702cf6eb 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -147,7 +147,8 @@ static json_t *set_print_json(struct output_ctx
> *octx, const struct set *set)
>          list_for_each_entry(i, &set->init->expressions, list)
>              json_array_append_new(array, expr_print_json(i, octx));
> 
> -        json_object_set_new(root, "elem", array);
> +        if (!(octx->flags & NFT_CTX_OUTPUT_TERSE))
> +            json_object_set_new(root, "elem", array);
>      }

I suggest you update your patch and send a v2 using:

        if (!nft_output_terse(octx) && set->init && set->init->size > 0) {
                ...

It would be also good if you can add a test. For instance, have a look at:

        tests/shell/testcases/transactions/0049huge_0

which also adds a shell tests for json. You can just get back the
listing in json and compare it. I suggest you use the
testcases/listing/ folder to store this new test.

Please, also check you MUA, it seems it mangles your attachments.

Thanks.
