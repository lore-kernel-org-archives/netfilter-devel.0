Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26DDC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 19:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjKITPE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjKITPE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 14:15:04 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F276D3A84
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 11:15:01 -0800 (PST)
Received: from [78.30.43.141] (port=49966 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r1AUU-00G2PD-AE; Thu, 09 Nov 2023 20:15:00 +0100
Date:   Thu, 9 Nov 2023 20:14:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 01/12] tests: shell: export DIFF to use it from
 feature scripts
Message-ID: <ZU0vsd5zUuf3mSdm@calendula>
References: <20231109162304.119506-1-pablo@netfilter.org>
 <20231109162304.119506-2-pablo@netfilter.org>
 <f887b55faf6c8467b90fb2363cb780ee7aa51f2c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f887b55faf6c8467b90fb2363cb780ee7aa51f2c.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 09, 2023 at 06:49:21PM +0100, Thomas Haller wrote:
> On Thu, 2023-11-09 at 17:22 +0100, Pablo Neira Ayuso wrote:
> > export DIFF so it can be used from feature scripts to probe the
> > kernel.
> > 
> > +DIFF="$(which diff)"
> > +if [ ! -x "$DIFF" ] ; then
> > +	DIFF=true
> > +fi
> > +export DIFF
> 
> 
> what is the purpose of having $DIFF variable at all?
> Why not require to have `diff` installed?
> 
> Maybe that justification is somewhere in the history of the project. If
> so, could you drop one line in the commit message what the point is?

It is all available in git annotate:

68310ba0f9c2 ("tests: shell: Search diff tool once and for all")
7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")

I just need to move it around so I can use it from feature scripts.
If you prefer I can just use 'diff' instead from the feature scripts.
