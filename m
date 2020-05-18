Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE5FC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 15:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C5420657
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 15:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgERPio (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 May 2020 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERPio (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 May 2020 11:38:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFBBC061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 08:38:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jahqk-0002o3-Bx; Mon, 18 May 2020 17:38:42 +0200
Date:   Mon, 18 May 2020 17:38:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 2/2] nfnl_osf: Improve error handling
Message-ID: <20200518153842.GK31506@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200515140330.13669-1-phil@nwl.cc>
 <20200515140330.13669-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515140330.13669-3-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two minor nits during final review:

On Fri, May 15, 2020 at 04:03:30PM +0200, Phil Sutter wrote:
[...]
> ---
> Changes since v1:
> - Don't use ulog_err() when complaining about missing fingerprints
>   argument, the use of strerror() with zero errno is misleading.
> - Don't print error on osf_load_line() failure when deleting and errno
>   is ENOENT. Upon add, NLM_F_EXCL is not set so EEXIST is basically
>   ignored, be equally error-tolerant upon deletion.

This change didn't make it into the commit message, although it's worth
mentioning.

[...]
> @@ -414,9 +416,11 @@ static int osf_load_entries(char *path, int del)
>  
>  		buf[len] = '\0';
>  
> -		err = osf_load_line(buf, len, del);
> -		if (err)
> -			break;
> +		rc = osf_load_line(buf, len, del);
> +		if (rc && (!del || errno == ENOENT)) {

Stupid typo here, it should read 'errno != ENOENT'.

I'll fix both before pushing upstream.

Cheers, Phil
