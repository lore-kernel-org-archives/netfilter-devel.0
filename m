Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3E6C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7089D206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgD1WEe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:04:34 -0400
Received: from correo.us.es ([193.147.175.20]:55470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1WEe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 18:04:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A603211EB25
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:04:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 960B9DA736
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:04:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B8A2BAAAF; Wed, 29 Apr 2020 00:04:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 856A3DA736;
        Wed, 29 Apr 2020 00:04:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 00:04:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 691AA42EF4E0;
        Wed, 29 Apr 2020 00:04:28 +0200 (CEST)
Date:   Wed, 29 Apr 2020 00:04:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     michael-dev <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issues with nft typeof
Message-ID: <20200428220428.GA18203@salvia>
References: <adfe176a20d9b4f9f93ed7e783309ee9@fami-braun.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <adfe176a20d9b4f9f93ed7e783309ee9@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 28, 2020 at 03:51:46PM +0200, michael-dev wrote:
[...] 
> table bridge t {
>         set s3 {
>                 typeof meta ibrpvid
>                 elements = { 2, 3, 103 }
>         }
[...]
> }
> 
> So I'm unsure if this is a display error when reading back? Or is the wrong
> value written to the kernel?

Looks like wrong value written to the kernel:

# nft --debug=netlink -f /tmp/x
s3 t 0
s3 t 0
        element 00000100  : 0 [end]     element 00000200  : 0 [end]     element 00000300  : 0 [end]
                ^^^^^^^^

That should be 00000001 instead.

where /tmp/x contains:

table ip t {
        set s3 {
                typeof meta ibrpvid
                elements = { 1, 2, 3 }
        }
}

This seems to be related with the integer_type, that sets the
byteorder to BYTEORDER_INVALID (which is implicitly handled as
BYTEORDER_BIG_ENDIAN).

Could you give a try to the following patch?

If this works for you, I'd really appreciate if you could extend
testcases/sets/typeof_sets_0 to include the 'meta ibrpvid' usecase
above.

Thanks.

--T4sUOijqQbZv57TR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="set-elem-byteorder-fix.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index 8c227eb11402..597141317000 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3544,7 +3544,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	ctx->set = set;
 	if (set->init != NULL) {
-		expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
+		__expr_set_context(&ctx->ectx, set->key->dtype,
+				   set->key->byteorder, set->key->len, 0);
 		if (expr_evaluate(ctx, &set->init) < 0)
 			return -1;
 	}

--T4sUOijqQbZv57TR--
