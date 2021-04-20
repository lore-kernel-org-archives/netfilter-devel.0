Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FF0C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 09:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376EC601FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 09:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhDTJzP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 05:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhDTJzP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 05:55:15 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03978C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 02:54:43 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 2654F58634DAA; Tue, 20 Apr 2021 11:54:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 2273C60D220CA;
        Tue, 20 Apr 2021 11:54:41 +0200 (CEST)
Date:   Tue, 20 Apr 2021 11:54:41 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Duncan Roe <duncan.roe2@gmail.com>
cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
Subject: Re: [PATCH libnetfilter_queue 1/1] build: doc: `make distcheck`
 passes with doxygen enabled
In-Reply-To: <20210420042358.2829-2-duncan_roe@optusnet.com.au>
Message-ID: <3219so45-rsq1-8093-77pr-39oo80or6q@vanv.qr>
References: <20210420042358.2829-1-duncan_roe@optusnet.com.au> <20210420042358.2829-2-duncan_roe@optusnet.com.au>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2021-04-20 06:23, Duncan Roe wrote:
>-AS_IF([test "x$with_doxygen" = xyes], [
>+	    [create doxygen documentation])],
>+	    [with_doxygen="$withval"], [with_doxygen=yes])
>+
>+AS_IF([test "x$with_doxygen" != xno], [
> 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
> 	AC_CHECK_PROGS([DOT], [dot], [""])
> 	AS_IF([test "x$DOT" != "x"],
>@@ -48,6 +49,10 @@ AS_IF([test "x$with_doxygen" = xyes], [
> ])
> 
> AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
>+if test -z "$DOXYGEN"; then

If you use AS_IF above, you could also make use of it here :)

>+# move it out of the way and symlink the real one while we run doxygen.
>+	cd ..; [ $$(ls src | wc -l) -gt 8 ] ||\

This looks like it could break anytime (say, when it happens to get to 9
files). Can't it test for a specific filename or set of names?

>+       function main { set -e; cd man/man3; rm -f _*;\

The syntax for POSIX sh-compatible functions should be

	main() { ...

>+function setgroup { mv $$1.3 $$2.3; BASE=$$2; };\
>+function add2group { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\

Should be quoted, i.e. "$$@". Might as well do it for the other vars.
