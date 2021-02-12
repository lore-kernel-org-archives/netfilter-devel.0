Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE719C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 18:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFDA64DBA
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 18:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhBLSDH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 13:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhBLSDE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 13:03:04 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79322C061756;
        Fri, 12 Feb 2021 10:02:25 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b9so510676ejy.12;
        Fri, 12 Feb 2021 10:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GQgEcIkoxwTqPRvy9e36k1BAwElKdvgBPKpg2hQjyqE=;
        b=o7vlo6QFlFqsHxUV+hZED5V6DNYDvCzdGZU+E0OaoIwWSWWuutrDkEBb+q0wBPMMAL
         prkJi9bs1JPCG9GYJrdlcDXxkiBZc3Uwe7/NdpvwvJFao3UXCYdq4i26q2QbFcqB129m
         1kxeU2LOW4o10DtRk7iIW7bqOBLpZWKWZZRIBZgvh8O+Sek2+zIFFMmLFjENHp3tTHKL
         r9Oh2IrE5X3IKxlqKo6Jsjc9wfyNSCRIbM+ihbCRBQYaCurPo+XVHC+NPsvhHNKdy30T
         ja7IgkonjRZlxLnaqY5M0mrvJNnmAe3pR7woVdJR8JFr4K8dIkSwH4VPRGsu1qEpxHbb
         fipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQgEcIkoxwTqPRvy9e36k1BAwElKdvgBPKpg2hQjyqE=;
        b=ubOvP3uhF5NzoymRvucWM0c8MhPoUvVOwDDZYMAueOC6qluebg4W6uFODdbmo1JpbV
         qI5UqO6bcTzeFLb0xwgPp1yScwG86mXEz/lqWxPlrwCt0mNMgQfTZW8JVKLWGm61ePv5
         N3QYx+N0wGH/CroK11VcGc9cSO5VfFushGSr2O11rRIVC5K3gw0XZNXtfccGuEyFzifW
         FOxUsGAyvprKuegi7r6p5lNca6pNEtSmTwBIOXDVAwJn2BqSmBR9jRe60yvYkTZcSrLQ
         z+O4n6IYzKLKxWYqAfpk+XgaEj2nXw9fZveIOGpZ+QkpdUOP64Nc7i1l5xMgeb0UtHNb
         LNcg==
X-Gm-Message-State: AOAM532RgfrYoavBLBvwZTfxnmgorXX4PbT8J8f0P+YekBy/w8g7cF68
        72EusFu0YZWmiCLSvznUTYo=
X-Google-Smtp-Source: ABdhPJwTV1ItIEgObBXppG0B/JbsnbIfCZ5vrrPZK4nJHx91TrN7LF4TLe/6NmoDgYbi9hRKidhUTw==
X-Received: by 2002:a17:907:9810:: with SMTP id ji16mr3995370ejc.394.1613152944075;
        Fri, 12 Feb 2021 10:02:24 -0800 (PST)
Received: from bzorp (BC248012.dsl.pool.telekom.hu. [188.36.128.18])
        by smtp.gmail.com with ESMTPSA id i4sm6628483eje.90.2021.02.12.10.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 10:02:23 -0800 (PST)
Date:   Fri, 12 Feb 2021 19:02:21 +0100
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, Martin Gignac <martin.gignac@gmail.com>,
        netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210212180221.GA3914830@bzorp>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
 <20210208154915.GF16570@breakpoint.cc>
 <20210208164750.GM3158@orbyte.nwl.cc>
 <20210208171444.GH16570@breakpoint.cc>
 <20210209135625.GN3158@orbyte.nwl.cc>
 <20210212000507.GD2766@breakpoint.cc>
 <20210212114042.GZ3158@orbyte.nwl.cc>
 <20210212122007.GE2766@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212122007.GE2766@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 12, 2021 at 01:20:07PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > I didn't find a better way to conditionally parse two following args as
> > strings instead of just a single one. Basically I miss an explicit end
> > condition from which to call BEGIN(0).
> 
> Yes, thats part of the problem.
> 
> > > Seems we need allow "{" for "*" and then count the {} nests so
> > > we can pop off a scanner state stack once we make it back to the
> > > same } level that we had at the last state switch.
> > 
> > What is the problem?
> 
> Detect when we need to exit the current start condition.
> 
> We may not even be able to do BEGIN(0) if we have multiple, nested
> start conditionals. flex supports start condition stacks, but that
> still leaves the exit/closure issue.
> 
> Example:
> 
> table chain {
>  chain bla {  /* should start to recognize rules, but
> 		 we did not see 'rule' keyword */
> 	ip saddr { ... } /* can't exit rule start condition on } ... */
> 	ip daddr { ... }
>  }  /* should disable rule keywords again */
> 
>  chain dynamic { /* so 'dynamic' is a string here ... */
>  }
> }
> 
> I don't see a solution, perhaps add dummy bison rule(s)
> to explicitly signal closure of e.g. a rule context?

You can always push/pop the flexer state from bison code blocks, maybe
that's what you mean on "dummy bison rules".

Trigger the state from bison and make sure it ends.

Something like this:

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 11e899ff..d8107181 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2397,7 +2397,10 @@ chain_policy             :       ACCEPT          { $$ = NF_ACCEPT; }
 identifier             :       STRING
                        ;
 
-string                 :       STRING
+string                 :       { yy_push_state(scanner, STRING); } __string { yy_pop_state(scanner); }
+                       ;
+
+__string               :       STRING
                        |       QUOTED_STRING
                        |       ASTERISK_STRING
                        ;

-- 
Bazsi
