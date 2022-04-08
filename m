Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5970DC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 15:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiDHPxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 11:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiDHPxm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 11:53:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0AA2CC538
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 08:51:38 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C8F3964393;
        Fri,  8 Apr 2022 17:47:46 +0200 (CEST)
Date:   Fri, 8 Apr 2022 17:51:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH v2 0/9] extensions: Merge *_DNAT and *_REDIRECT
Message-ID: <YlBaBlnZozwUO7qq@salvia>
References: <20220331101211.10099-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220331101211.10099-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

LGTM.

On Thu, Mar 31, 2022 at 12:12:02PM +0200, Phil Sutter wrote:
> Second try, without fancy service name parsing in ranges this time.
> Instead, mention support for names outside of ranges in extensions man
> page.
> 
> Other changes since v1:
> - Fixed for garbage in output when listing multiple DNAT rules (due to
>   missing reinit of a static buffer.
> - Drop of last patch revealed a crash bug in service name parser.
> - Do not allow service names in ranges' upper boundary.
> - More test cases.
> 
> Phil Sutter (9):
>   man: DNAT: Describe shifted port range feature
>   Revert "libipt_[SD]NAT: avoid false error about multiple destinations
>     specified"
>   extensions: ipt_DNAT: Merge v1 and v2 parsers
>   extensions: ipt_DNAT: Merge v1/v2 print/save code
>   extensions: ipt_DNAT: Combine xlate functions also
>   extensions: DNAT: Rename from libipt to libxt
>   extensions: Merge IPv4 and IPv6 DNAT targets
>   extensions: Merge REDIRECT into DNAT
>   extensions: man: Document service name support in DNAT and REDIRECT
> 
>  extensions/GNUmakefile.in          |   4 +-
>  extensions/libip6t_DNAT.c          | 409 ------------------
>  extensions/libip6t_DNAT.t          |   4 +
>  extensions/libip6t_DNAT.txlate     |  11 -
>  extensions/libip6t_REDIRECT.c      | 170 --------
>  extensions/libip6t_REDIRECT.t      |   6 -
>  extensions/libip6t_REDIRECT.txlate |   5 -
>  extensions/libip6t_SNAT.c          |   9 +-
>  extensions/libipt_DNAT.c           | 507 ----------------------
>  extensions/libipt_DNAT.t           |   4 +
>  extensions/libipt_DNAT.txlate      |  14 -
>  extensions/libipt_REDIRECT.c       | 174 --------
>  extensions/libipt_REDIRECT.t       |   6 -
>  extensions/libipt_REDIRECT.txlate  |   5 -
>  extensions/libipt_SNAT.c           |   3 -
>  extensions/libxt_DNAT.c            | 650 +++++++++++++++++++++++++++++
>  extensions/libxt_DNAT.man          |   7 +-
>  extensions/libxt_DNAT.txlate       |  35 ++
>  extensions/libxt_REDIRECT.man      |   1 +
>  extensions/libxt_REDIRECT.t        |  16 +
>  extensions/libxt_REDIRECT.txlate   |  26 ++
>  21 files changed, 746 insertions(+), 1320 deletions(-)
>  delete mode 100644 extensions/libip6t_DNAT.c
>  delete mode 100644 extensions/libip6t_DNAT.txlate
>  delete mode 100644 extensions/libip6t_REDIRECT.c
>  delete mode 100644 extensions/libip6t_REDIRECT.t
>  delete mode 100644 extensions/libip6t_REDIRECT.txlate
>  delete mode 100644 extensions/libipt_DNAT.c
>  delete mode 100644 extensions/libipt_DNAT.txlate
>  delete mode 100644 extensions/libipt_REDIRECT.c
>  delete mode 100644 extensions/libipt_REDIRECT.t
>  delete mode 100644 extensions/libipt_REDIRECT.txlate
>  create mode 100644 extensions/libxt_DNAT.c
>  create mode 100644 extensions/libxt_DNAT.txlate
>  create mode 100644 extensions/libxt_REDIRECT.t
>  create mode 100644 extensions/libxt_REDIRECT.txlate
> 
> -- 
> 2.34.1
> 
