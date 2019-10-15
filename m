Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711C2ECE58F
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 22:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF9720659
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 22:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387793AbfJOWwy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 18:52:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36888 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728043AbfJOWwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 18:52:53 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 82B51362300
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 09:52:39 +1100 (AEDT)
Received: (qmail 5722 invoked by uid 501); 15 Oct 2019 22:52:38 -0000
Date:   Wed, 16 Oct 2019 09:52:38 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnfnetlink 0/1] Minimally resurrect doxygen
 documentation
Message-ID: <20191015225238.GA5350@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=4XNw1tWER03Oy7dQwWYA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Oct 14, 2019 at 01:02:22PM +1100, Duncan Roe wrote:
> libnfnetlink has good doxygen documentation but there was no output when
> doxygen was run.
>
> Patch 1/1 fixes that,
> but on rebuilding there were a number warnings of the form:
>
> right-hand operand of comma expression has no effect [-Wunused-value]
>
> *This was not introduced by patch 1/1*
>
> Instead, it is caused by the definition of "prefetch" in include/linux_list.h:
>
>  #define prefetch(x) 1
>
> the Linux kernel has:
>
>  #define prefetch(x) __builtin_prefetch(x)
>
> I see 3 ways to get back to a clean compile:
>
> 1. Suppress the warnings with a pragma
>
> 2. Reinstate the Linux definition of prefetch
>
> 3. Expunge prefetch from the header file
>
> I have made all 3, please indicate which one you'd like.
>
> 1. & 2. are 1-liners while 3. is multiline.
>
> 3. allows of extra simplifications, such as defining a macro in a single
> line or fewer lines than before. In some places I could also delete the fragment
> "&& ({ 1;})".
>
>
> Duncan Roe (1):
>   src: Minimally resurrect doxygen documentation
>
>  configure.ac         |   2 +-
>  doxygen.cfg.in       | 180 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux_list.h |   9 +++
>  src/iftable.c        |   9 +++
>  src/libnfnetlink.c   |  17 ++++-
>  5 files changed, 215 insertions(+), 2 deletions(-)
>  create mode 100644 doxygen.cfg.in
>
> --
> 2.14.5
>
Any feedback on this?

Exposing the documentation would be uncontroversial surely?

In regard to compiler warnings, alternative 1 entails least effort to review,
since the code remains unchanged.

Cheers ... Duncan.
