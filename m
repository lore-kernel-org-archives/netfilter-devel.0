Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAB8C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 02:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1887B613FA
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 02:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhDUCSY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbhDUCSX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 22:18:23 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC00BC06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 19:17:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j7so18869299pgi.3
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 19:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2L8ZwojvvSoBmeVaKOs918O1wAMzTFDjXKRVmxAvPlY=;
        b=M+wXcKEoC25M1hXBvOOvX1rLOZAIvUZa+9gfzAwXme1xkYjXEco7/u7NzSwWbbJwhu
         ko6aO7Z9KHUKlw01W/OpZXOkGH7mliDSGVj3w4iRZmzfvOZGa7y6UGDeQLy+cPqV69Rr
         uYJSFgYwpsa8/C9Mp3GKN1sALNHOe9ac903oBHA+svtyI/Q7m0wB1bdHgjf/1nssxzUW
         Sl/dAMuyvZtPiiGsrwQlfIGO2d0bBmmWH3tYSG3Ym9pMBZjY0NPK44qwVcWC2jh6SJSV
         jTpiAilDjv3IQCRGj/pgk+Sr3eqcQy34B4QrOiTfKbN6gcbLZzGo3UUL8FmeL0V1rTic
         hymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2L8ZwojvvSoBmeVaKOs918O1wAMzTFDjXKRVmxAvPlY=;
        b=gyUhdV2UTe1FBAiCzOsco63hGGoJhTHhJWMTfBKRLOPShJ0jUFs/jqWrz8cUE06NPR
         vZRzRUf+iey7Xm2E1sBGfWvbxZIWDvaXEiPUdm6da+CsAPNi4GCU8Bzdo9NIGRN7arzu
         29ZYeMrmOAhDmJXQZi598KM4sQFkZ8jHOBhP/xrz4sJb4B5pCKkBFcpJFBOyZWj58DRF
         Foiu3/SLqSpZ/2i+KWk9npP8NNp5yU8ra7ESExrShzk3B6S/BNxazkDzW5QJW50V2lM6
         mHs+UgAaAAYwGfysIYYaEqK0dzRfC6gBT0saSbY+dFvaXxbsbxq9xN5PKzH5xqomxsHx
         akiQ==
X-Gm-Message-State: AOAM53108Sp+Yt8XI0DHufe9jXPR9oaCMRN1cSQRcbloUqmojTUZmS+a
        7+ETBlQevhdSgQBdOSSAyCcXmDLh/5WFkg==
X-Google-Smtp-Source: ABdhPJwLBOlH5QG6bGOCpUWTP06l5BTxU+tHjA7V9w89LtTqMNs/3H+aL8k0DO6S1vP6i0pn6p3Aag==
X-Received: by 2002:a62:a515:0:b029:263:214f:27ff with SMTP id v21-20020a62a5150000b0290263214f27ffmr7234664pfm.4.1618971470276;
        Tue, 20 Apr 2021 19:17:50 -0700 (PDT)
Received: from smallstar.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id h9sm277008pgl.67.2021.04.20.19.17.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Apr 2021 19:17:49 -0700 (PDT)
From:   Duncan Roe <duncan.roe2@gmail.com>
X-Google-Original-From: Duncan Roe <dunc@smallstar.local.net>
Date:   Wed, 21 Apr 2021 12:17:45 +1000
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
Subject: Re: [PATCH libnetfilter_queue 1/1] build: doc: `make distcheck`
 passes with doxygen enabled
Message-ID: <20210421021745.GA9334@smallstar.local.net>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
References: <20210420042358.2829-1-duncan_roe@optusnet.com.au>
 <20210420042358.2829-2-duncan_roe@optusnet.com.au>
 <3219so45-rsq1-8093-77pr-39oo80or6q@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3219so45-rsq1-8093-77pr-39oo80or6q@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Tue, Apr 20, 2021 at 11:54:41AM +0200, Jan Engelhardt wrote:
>
> On Tuesday 2021-04-20 06:23, Duncan Roe wrote:
> >-AS_IF([test "x$with_doxygen" = xyes], [
> >+	    [create doxygen documentation])],
> >+	    [with_doxygen="$withval"], [with_doxygen=yes])
> >+
> >+AS_IF([test "x$with_doxygen" != xno], [
> > 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
> > 	AC_CHECK_PROGS([DOT], [dot], [""])
> > 	AS_IF([test "x$DOT" != "x"],
> >@@ -48,6 +49,10 @@ AS_IF([test "x$with_doxygen" = xyes], [
> > ])
> >
> > AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
> >+if test -z "$DOXYGEN"; then
>
> If you use AS_IF above, you could also make use of it here :)

Happy to do that, but could you spell out the actual line please? My grasp of m4
is tenuous at best - I only copy stuff that I see working elsewhere.

In this case I copied Florian Westphal's code from 3622e606.
>
> >+# move it out of the way and symlink the real one while we run doxygen.
> >+	cd ..; [ $$(ls src | wc -l) -gt 8 ] ||\
>
> This looks like it could break anytime (say, when it happens to get to 9
> files). Can't it test for a specific filename or set of names?

OK I can test for existence of Makefile.in.
>
> >+       function main { set -e; cd man/man3; rm -f _*;\
>
> The syntax for POSIX sh-compatible functions should be
>
> 	main() { ...

Rats! I had it that way, but the old fixmanpages.sh had 'function' so I changed
it to minimise the diff. Will change back to POSIX way in v2.
>
> >+function setgroup { mv $$1.3 $$2.3; BASE=$$2; };\
> >+function add2group { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\
>
> Should be quoted, i.e. "$$@". Might as well do it for the other vars.

"Should be"? We're dealing with man page names. If unquoted $$@ fails, we've got
other problems. Or is it a style thing? Do you want I should quote $$BASE, $$1 &
$$2 as well?
