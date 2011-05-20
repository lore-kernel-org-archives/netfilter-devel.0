From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtoptions + quota: parse and store 64bit values?
Date: Fri, 20 May 2011 16:06:55 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105201606010.24270@frira.zrqbmnf.qr>
References: <BANLkTi=cn4RQSDt3bAGrpSxdd7A4FttVew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: JP Abgrall <jpa@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44282 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933417Ab1ETOG5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 10:06:57 -0400
In-Reply-To: <BANLkTi=cn4RQSDt3bAGrpSxdd7A4FttVew@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-05-19 05:26, JP Abgrall wrote:

>Without this change, my kernel's xt_quota.c::quota_mt_check() doesn't
>see the values.

>The xtables_strtoul() would cram a long long into a long.
>The parse_int would try to cram a UINT64 into a long.
>The quota_parse would just ignore whatever value was parsed.

Thanks, taken.


>@@ -47,6 +47,7 @@ static void quota_parse(struct xt_option_call *cb)
> 	xtables_option_parse(cb);
> 	if (cb->invert)
> 		info->flags |= XT_QUOTA_INVERT;
>+	info->quota = cb->val.u64;
> }
>
> static struct xtables_match quota_match = {

I replaced this by XTOPT_PUT as it should have been.
