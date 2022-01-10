Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4BCC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jan 2022 00:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiAJAWO convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 19:22:14 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42586 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiAJAWO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 19:22:14 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E96516428F;
        Mon, 10 Jan 2022 01:19:22 +0100 (CET)
Date:   Mon, 10 Jan 2022 01:22:08 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v4 00/32] Fixes for compiler warnings
Message-ID: <Ydt8MDizCy1PNDQl@salvia>
References: <20211130105600.3103609-1-jeremy@azazel.net>
 <Ya6MyhseW80+w0FY@salvia>
 <YdM8BYK5U+CMU+ow@salvia>
 <YdYgPpxjhPP7IsiO@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <YdYgPpxjhPP7IsiO@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 05, 2022 at 10:48:30PM +0000, Jeremy Sowden wrote:
> From e45879a7ea5529c26f369c297295332143ee8420 Mon Sep 17 00:00:00 2001
> From: Jeremy Sowden <jeremy@azazel.net>
> Date: Wed, 5 Jan 2022 22:37:21 +0000
> Subject: [PATCH] output: SQLITE3: remove unused variable
> 
> There's local variable left over from a previous tidy-up.  Remove it.

Applied, thanks

> Fixes: 67b0be90f16f ("output: SQLITE3: improve mapping of fields to DB columns")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  output/sqlite3/ulogd_output_SQLITE3.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
> index 51eab782cc9d..0a9ad67edcff 100644
> --- a/output/sqlite3/ulogd_output_SQLITE3.c
> +++ b/output/sqlite3/ulogd_output_SQLITE3.c
> @@ -320,7 +320,6 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
>  	}
>  
>  	for (col = 0; col < num_cols; col++) {
> -		char *underscore;
>  		struct field *f;
>  
>  		/* prepend it to the linked list */
> -- 
> 2.34.1
> 



