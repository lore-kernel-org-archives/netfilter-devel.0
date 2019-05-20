Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98662C04E87
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 11:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E5720815
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 11:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732612AbfETLT0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 07:19:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35266 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732362AbfETLT0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 07:19:26 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hSgKB-0007rk-Fu; Mon, 20 May 2019 13:19:23 +0200
Date:   Mon, 20 May 2019 13:19:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables: Testsuites in release tarballs?
Message-ID: <20190520111923.GO4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190520105219.GN4851@orbyte.nwl.cc>
 <20190520110112.oyju3c2uc5jmxgxg@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520110112.oyju3c2uc5jmxgxg@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, May 20, 2019 at 01:01:12PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > IIRC, we have three distinct testsuites in iptables git repo:
> > 
> > * xlate-test.py, cases in extensions/*.txlate
> > * iptables-test.py, cases in extensions/*.t
> > * iptables/tests/shell/run-tests.sh, cases in .../testcases
> > 
> > Of those, only the first and last ones are included in release tarballs.
> > Is there a specific reason why iptables-test.py is left out?
> 
> No idea, I guess its just historic artefact.

Indeed, hitting the history books revealed this one:

4b187eeed49dc ("build: don't include tests in released tarball")

It is from 2013, the other two testsuites are from 2017/2018. :)

Thanks, Phil
