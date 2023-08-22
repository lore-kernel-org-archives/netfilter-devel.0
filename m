Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685D2EE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 16:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbjHVQEs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 12:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbjHVQEs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 12:04:48 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD5310F
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 09:04:46 -0700 (PDT)
Received: from [78.30.34.192] (port=47842 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYTs1-000xhb-26; Tue, 22 Aug 2023 18:04:44 +0200
Date:   Tue, 22 Aug 2023 18:04:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r()
 functions
Message-ID: <ZOTcl0ffTS0IVr0a@calendula>
References: <20230822081318.1370371-1-thaller@redhat.com>
 <20230822081318.1370371-2-thaller@redhat.com>
 <ZOR3za+Z+1X0VnIo@calendula>
 <f5680cd01051242a87f768f5770b062c199971b1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5680cd01051242a87f768f5770b062c199971b1.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 22, 2023 at 01:39:20PM +0200, Thomas Haller wrote:
> Hi Pablo,
> 
> One more consideration, that I didn't realize before. Sorry about that.
> 
> localtime() will always call tzset(). And localtime_r() is documented
> that it may not call it.
> 
>   https://linux.die.net/man/3/localtime_r
> 
> I checked implementations, AFAIS, musl will always call do_tzset()
> ([1]). glibc will only ensure that tzset() was called at least once
> ([2]).
> 
> [1] https://git.musl-libc.org/cgit/musl/tree/src/time/__tz.c?id=83b858f83b658bd34eca5d8ad4d145f673ae7e5e#n369
> [2] https://codebrowser.dev/glibc/glibc/time/tzset.c.html#577
> 
> It's not clear to me, whether it would be more correct/desirable to
> always call tzset() before localtime_r(). I think it would only matter,
> if the timezone were to change (e.g. update /etc/localtime).
>
> nftables calls localtime_r() from print/parse functions. Presumably, we
> will print/parse several timestamps during a larger operation, it would
> be odd to change/reload the timezone in between or to meaningfully
> support that.

You mean, timezone change while there is a 'list ruleset' command
might be an issue is what you mean?

> I think it is all good, nothing to change. Just to be aware of.
