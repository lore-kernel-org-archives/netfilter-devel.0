Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1869AC28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 15:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E94862343A
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 15:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfE3PCz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 11:02:55 -0400
Received: from mail.us.es ([193.147.175.20]:51644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfE3PCz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 11:02:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15B03E2D93
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 17:02:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1B91DA79B
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 17:02:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F0D27DA709; Thu, 30 May 2019 17:02:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D457DA70D;
        Thu, 30 May 2019 17:02:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 17:02:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 59F3E4265A31;
        Thu, 30 May 2019 17:02:50 +0200 (CEST)
Date:   Thu, 30 May 2019 17:02:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ash Hughes <sehguh.hsa@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrackd: Use strdup in lexer
Message-ID: <20190530150249.4uuyyrykpy4c7oo7@salvia>
References: <20190527205943.GA16450@ash-clevo.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527205943.GA16450@ash-clevo.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ash,

On Mon, May 27, 2019 at 09:59:43PM +0100, Ash Hughes wrote:
> Use strdup in the config file lexer to copy strings to
> yylval.string. This should solve the "[ERROR] unknown layer 3
> protocol" problem here:
> https://www.spinics.net/lists/netfilter/msg58628.html

Thanks, this indeed fixes the problem.

One request below:
> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index 1d510ed..1cb9cce 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -117,6 +117,7 @@ logfile_bool : T_LOG T_OFF
>  logfile_path : T_LOG T_PATH_VAL
>  {
>  	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
> +    free($2);
   ^^^^

Could you submit a v2 using 8-char tab indentation instead of spaces?

Thanks!
