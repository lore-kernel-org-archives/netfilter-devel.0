Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF515C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFC4A21E6D
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfEaQCt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 12:02:49 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33186 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbfEaQCt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 12:02:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWjzT-0005Rr-7l; Fri, 31 May 2019 18:02:47 +0200
Date:   Fri, 31 May 2019 18:02:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: avoid unnecessary rebuild of iptables when
 rerunning configure
Message-ID: <20190531160247.nv62gthqq4pkp4bu@breakpoint.cc>
References: <20190531064938.11923-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531064938.11923-1-jengelh@inai.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> Running configure always touches xtables/xtables-version.h, which
> causes parts to rebuild even when the configuration has not changed.
> (`./configure; make; ./configure; make;`).
> 
> This can be avoided if the AC_CONFIG_FILES mechanism is replaced by
> one that does a compare and leaves an existing xtables-version.h
> unmodified if the sed result stays the same when it re-runs.

bash autogen.sh
./configure
make

build ends with:
Making all in include
make[2]: Entering directory
'/home/fw/git/netfilter.org/iptables/include'
make[2]: *** No rule to make target 'xtables-version.h', needed by 'all-am'.  Stop.
make[2]: Leaving directory '/home/fw/git/netfilter.org/iptables/include'
make[1]: *** [Makefile:501: all-recursive] Error 1
