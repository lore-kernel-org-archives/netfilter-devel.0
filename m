Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231C1C04AAC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 10:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02B0D20657
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 10:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfETKwV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 06:52:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35218 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfETKwV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 06:52:21 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hSftz-0007fV-Jt; Mon, 20 May 2019 12:52:19 +0200
Date:   Mon, 20 May 2019 12:52:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: iptables: Testsuites in release tarballs?
Message-ID: <20190520105219.GN4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

IIRC, we have three distinct testsuites in iptables git repo:

* xlate-test.py, cases in extensions/*.txlate
* iptables-test.py, cases in extensions/*.t
* iptables/tests/shell/run-tests.sh, cases in .../testcases

Of those, only the first and last ones are included in release tarballs.
Is there a specific reason why iptables-test.py is left out?

Thanks, Phil
