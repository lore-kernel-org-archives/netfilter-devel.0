Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BEAC2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A153F2082E
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGRbq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:31:46 -0500
Received: from correo.us.es ([193.147.175.20]:49332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgBGRbq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 12:31:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABFB31228C7
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 18:31:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D9BCDA711
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 18:31:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 93188DA705; Fri,  7 Feb 2020 18:31:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99955DA70E;
        Fri,  7 Feb 2020 18:31:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 18:31:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 49B4042EFB80;
        Fri,  7 Feb 2020 18:31:43 +0100 (CET)
Date:   Fri, 7 Feb 2020 18:31:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] scanner: Extend asteriskstring definition
Message-ID: <20200207173140.hhqav2g6ckxnibmy@salvia>
References: <20200206113828.7306-1-phil@nwl.cc>
 <20200206113828.7306-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206113828.7306-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 06, 2020 at 12:38:28PM +0100, Phil Sutter wrote:
> Accept sole escaped asterisks as well as unescaped asterisks if
> surrounded by strings. The latter is merely cosmetic, but literal
> asterisk will help when translating from iptables where asterisk has no
> special meaning.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/scanner.l | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/scanner.l b/src/scanner.l
> index 99ee83559d2eb..da9bacee23eb5 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -120,7 +120,7 @@ numberstring	({decstring}|{hexstring})
>  letter		[a-zA-Z]
>  string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
>  quotedstring	\"[^"]*\"
> -asteriskstring	({string}\*|{string}\\\*)
> +asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\*{string})

Probably this:

        {string}\\\*{string})

instead of:

        {string}\*{string})

?

The escaping makes it probably clear that there is no support for
infix wildcard matching?

This asteriskstring rule is falling under the string rule in bison.
This is allowing to use \\\* for log messages too, and elsewhere.
