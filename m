Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DBBC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 09:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45F5D206C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 09:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfDIJ7L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 05:59:11 -0400
Received: from mxin.vub.ac.be ([134.184.129.114]:28191 "EHLO mxin.vub.ac.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbfDIJ7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 05:59:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2E+AAAEbKxc/wEauIZlGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQcBAQEBAQGBZYJ5gQMnhA6Ie4xOmkEBNgUChDQKAoYCOBIBAQMBAQk?=
 =?us-ascii?q?BAQEBAgICaRwMgnhNawEBAQEBASMCDWQBBSNWEAsOCgICJgICVwYTgyOBdQ+?=
 =?us-ascii?q?sfYEviDshgU4FgQsli16BQD+EIz6CSBkEGIRRglcDki6TWAmIBIwai0eJGC2?=
 =?us-ascii?q?RSI8yNyKBVjMaCBgYgyeCFhcUiEyFQT0BATEBCXgmE48yAQE?=
X-IPAS-Result: =?us-ascii?q?A2E+AAAEbKxc/wEauIZlGQEBAQEBAQEBAQEBAQcBAQEBA?=
 =?us-ascii?q?QGBZYJ5gQMnhA6Ie4xOmkEBNgUChDQKAoYCOBIBAQMBAQkBAQEBAgICaRwMg?=
 =?us-ascii?q?nhNawEBAQEBASMCDWQBBSNWEAsOCgICJgICVwYTgyOBdQ+sfYEviDshgU4Fg?=
 =?us-ascii?q?Qsli16BQD+EIz6CSBkEGIRRglcDki6TWAmIBIwai0eJGC2RSI8yNyKBVjMaC?=
 =?us-ascii?q?BgYgyeCFhcUiEyFQT0BATEBCXgmE48yAQE?=
Received: from ai01.vub.ac.be (HELO ai.vub.ac.be) ([134.184.26.1])
  by smtp.vub.ac.be with ESMTP; 09 Apr 2019 11:59:08 +0200
Received: from localhost (localhost [127.0.0.1])
        by ai.vub.ac.be (Postfix) with ESMTP id 90E58100DAE;
        Tue,  9 Apr 2019 11:59:08 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at ai.vub.ac.be
Received: from ai.vub.ac.be ([127.0.0.1])
        by localhost (ai.vub.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id 9lKKJGU2o4Gi; Tue,  9 Apr 2019 11:59:08 +0200 (CEST)
Received: from elitebook (ai86.vub.ac.be [134.184.26.86])
        by ai.vub.ac.be (Postfix) with ESMTPSA id 63A42100DAA;
        Tue,  9 Apr 2019 11:59:08 +0200 (CEST)
Message-ID: <f90ffd6e6f0ebd1f9e99a3d01f526bb92da97b2a.camel@ai.vub.ac.be>
Subject: Re: 5.0.7: WARNING: CPU: 1 PID: 169 at
 net/netfilter/nft_compat.c:82 and genreal protection fault
From:   Frederik Himpe <fhimpe@ai.vub.ac.be>
To:     Florian Westphal <fw@strlen.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Date:   Tue, 09 Apr 2019 11:59:08 +0200
In-Reply-To: <20190408201909.6mcgobkdnswyikfv@breakpoint.cc>
References: <306bc8c0e81422a73ccfcd0ac3ea2d79fc1df0b0.camel@ai.vub.ac.be>
         <20190408201909.6mcgobkdnswyikfv@breakpoint.cc>
Organization: Vrije Universiteit Brussel
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2019-04-08 at 22:19 +0200, Florian Westphal wrote:
> Frederik Himpe <fhimpe@ai.vub.ac.be> wrote:
> > I'm experiencing this reproducible bug every time shorewall6 is
> > restarted:
> > [   28.932323] WARNING: CPU: 1 PID: 169 at
> > net/netfilter/nft_compat.c:82 nft_xt_put.part.9+0x21/0x30
> > [nft_compat]
> [..]
> > [   29.015565] general protection fault: 0000 [#1] SMP PTI
> > [   29.015574] CPU: 3 PID: 2069 Comm: ip6tables-resto Tainted:
> > G        W   E     5.0.7 #1
> 
> Does this problem go away when you apply this commit on top of 5.0.7?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b8e204006340b7aaf32bd2b9806c692f6e0cb38a
> 
> If not, can you send a minimal reproducer?

Indeed, the problem does not happen any more with this patch applied to
5.0.7. Thanks!

-- 
Frederik Himpe <fhimpe@ai.vub.ac.be>
Vrije Universiteit Brussel

