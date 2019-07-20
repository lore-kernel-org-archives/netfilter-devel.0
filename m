Return-Path: <SRS0=YHPx=VR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9674EC76186
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 20:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DEED20838
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jul 2019 20:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfGTUV6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 16:21:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41382 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfGTUV6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 16:21:58 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hovrh-0007pT-9i; Sat, 20 Jul 2019 22:21:57 +0200
Date:   Sat, 20 Jul 2019 22:21:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: osf: fix snprintf -Wformat-truncation warning
Message-ID: <20190720202157.GB22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20190718110145.13361-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190718110145.13361-1-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Thu, Jul 18, 2019 at 01:01:46PM +0200, Fernando Fernandez Mancera wrote:
> Fedora 30 uses very recent gcc (version 9.1.1 20190503 (Red Hat 9.1.1-1)),
> osf produces following warnings:
> 
> -Wformat-truncation warning have been introduced in the version 7.1 of gcc.
> Also, remove a unneeded address check of "tmp + 1" in nf_osf_strchr().
> 
> nfnl_osf.c: In function ‘nfnl_osf_load_fingerprints’:
> nfnl_osf.c:292:39: warning: ‘%s’ directive output may be truncated writing
> up to 1023 bytes into a region of size 128 [-Wformat-truncation=]
>   292 |   cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
>       |                                       ^~
> nfnl_osf.c:292:9: note: ‘snprintf’ output between 2 and 1025 bytes into a
> destination of size 128
>   292 |   cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> nfnl_osf.c:302:46: warning: ‘%s’ directive output may be truncated writing
> up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
>   302 |    cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
>       |                                              ^~
> nfnl_osf.c:302:10: note: ‘snprintf’ output between 1 and 1024 bytes into a
> destination of size 32
>   302 |    cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> nfnl_osf.c:309:49: warning: ‘%s’ directive output may be truncated writing
> up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
>   309 |   cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
>       |                                                 ^~
> nfnl_osf.c:309:9: note: ‘snprintf’ output between 1 and 1024 bytes into a
> destination of size 32
>   309 |   cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> nfnl_osf.c:317:47: warning: ‘%s’ directive output may be truncated writing
> up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
>   317 |       snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
>       |                                               ^~
> nfnl_osf.c:317:7: note: ‘snprintf’ output between 1 and 1024 bytes into a
> destination of size 32
>   317 |       snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
>       |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  src/nfnl_osf.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
> index be3fd81..c99f8f3 100644
> --- a/src/nfnl_osf.c
> +++ b/src/nfnl_osf.c
> @@ -81,7 +81,7 @@ static char *nf_osf_strchr(char *ptr, char c)
>  	if (tmp)
>  		*tmp = '\0';
>  
> -	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
> +	while (tmp && isspace(*(tmp + 1)))
>  		tmp++;
>  
>  	return tmp;
> @@ -212,7 +212,7 @@ static int osf_load_line(char *buffer, int len, int del,
>  			 struct netlink_ctx *ctx)
>  {
>  	int i, cnt = 0;
> -	char obuf[MAXOPTSTRLEN];
> +	char obuf[MAXOPTSTRLEN + 1];
>  	struct nf_osf_user_finger f;
>  	char *pbeg, *pend;
>  	struct nlmsghdr *nlh;
> @@ -289,7 +289,7 @@ static int osf_load_line(char *buffer, int len, int del,
>  	pend = nf_osf_strchr(pbeg, OSFPDEL);
>  	if (pend) {
>  		*pend = '\0';
> -		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
> +		cnt = snprintf(obuf, sizeof(obuf), "%.128s", pbeg);

Not a big deal, but sizeof() and hard-coding the "precision" doesn't mix
well in my opinion. I've solved this like so:

		i = sizeof(obuf);
		cnt = snprintf(obuf, i, "%.*s,", i - 2, pbeg);

(i - 2) to leave space for the trailing comma and nul-char. Also note
that your patch drops the trailing comma, I guess that's a bug.

Maybe you want to have a look at my patch (Message-ID
20190720185226.8876-2-phil@nwl.cc) and incorporate what's useful into
yours? It's your code, so you should know better how to fix things. :)

Thanks, Phil
