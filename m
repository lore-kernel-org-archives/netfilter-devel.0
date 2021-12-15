Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA58C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 23:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhLOX2j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 18:28:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56534 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhLOX2j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 18:28:39 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F0C98607E0;
        Thu, 16 Dec 2021 00:26:08 +0100 (CET)
Date:   Thu, 16 Dec 2021 00:28:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] build: doc: Update build_man.sh for
 doxygen 1.9.2
Message-ID: <Ybp6IlQAlAFVSdjQ@salvia>
References: <20211207224502.16008-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211207224502.16008-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A bit more details on this one? It's just a cosmetic issue?

On Wed, Dec 08, 2021 at 09:45:02AM +1100, Duncan Roe wrote:
> Cater for bold line number in del_def_at_lines()
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  doxygen/build_man.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
> index 852c7b8..c68876c 100755
> --- a/doxygen/build_man.sh
> +++ b/doxygen/build_man.sh
> @@ -96,7 +96,7 @@ fix_double_blanks(){
>  del_def_at_lines(){
>    linnum=1
>    while [ $linnum -ne 0 ]
> -  do mygrep "^Definition at line [[:digit:]]* of file" $target
> +  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
>      [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
>    done
>  }
> -- 
> 2.17.5
> 
