From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_hashlimit: Do not print default
 timeout and burst
Date: Tue, 19 Dec 2017 15:01:19 +0100
Message-ID: <20171219140119.xioa2io52yvofdws@salvia>
References: <20171219122716.19710-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nmalykh@bilim.com, rv@wallfire.org, netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59346 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935389AbdLSOB1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 09:01:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33111E1516
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 15:01:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 246AB201C6
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 15:01:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171219122716.19710-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 19, 2017 at 05:57:16PM +0530, Harsha Sharma wrote:
> @@ -1340,7 +1345,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
>  	xt_xlate_add(xl, "flow table %s {", name);
>  	ret = hashlimit_mode_xlate(xl, cfg->mode, family,
>  				   cfg->srcmask, cfg->dstmask);
> -	xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
> +	if (!XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT)
> +		xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);

Better print cfg->expire if only if the default timeout is set.

        if (cfg->expire != XT_HASHLIMIT_XLATE_DEFAULT_TIMEOUT)
                ...

Same thing for burst. Thanks.
