Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8296AC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jan 2022 16:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbiAQQeD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 11:34:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60058 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiAQQeD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 11:34:03 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DC39460026;
        Mon, 17 Jan 2022 17:31:05 +0100 (CET)
Date:   Mon, 17 Jan 2022 17:33:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: fix compiler warnings
Message-ID: <YeWadfWhW/QxtvIE@salvia>
References: <20220117154252.13420-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220117154252.13420-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 17, 2022 at 04:42:52PM +0100, Florian Westphal wrote:
> .... those do not indicate bugs, but they are distracting.
> 
> 'exp_filter_add' at filter.c:513:2:
> __builtin_strncpy specified bound 16 equals destination size [-Wstringop-truncation]
> read_config_yy.y:1625: warning: '__builtin_snprintf' output may be truncated before the last format character [-Wformat-truncation=]
>  1625 |         snprintf(policy->name, CTD_HELPER_NAME_LEN, "%s", $2);
> read_config_yy.y:1399: warning: '__builtin_snprintf' output may be ...
>  1399 |         snprintf(conf.stats.logfile, FILENAME_MAXLEN, "%s", $2);
> read_config_yy.y:707: warning: '__builtin_snprintf' output may be ...
>   707 |         snprintf(conf.local.path, UNIX_PATH_MAX, "%s", $2);
> read_config_yy.y:179: warning: '__builtin_snprintf' output may be ...
>   179 |         snprintf(conf.lockfile, FILENAME_MAXLEN, "%s", $2);
> read_config_yy.y:124: warning: '__builtin_snprintf' output may be ...
>   124 |         snprintf(conf.logfile, FILENAME_MAXLEN, "%s", $2);
> 
> ... its because the _MAXLEN constants are one less than the output
> buffer size, i.e. could use either .._MAXLEN + 1 or sizeof, this uses
> sizeof().

LGTM, thanks
