Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CC0C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Mar 2023 22:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCTWK3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCTWK2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58427AB1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2023 15:10:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1peNhu-0004Ag-HO; Mon, 20 Mar 2023 23:10:22 +0100
Date:   Mon, 20 Mar 2023 23:10:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Kyuwon Shim <Kyuwon.Shim@alliedtelesis.co.nz>
Cc:     "fw@strlen.de" <fw@strlen.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2] ulogd2: Avoid use after free in unregister on global
 ulogd_fds linked list
Message-ID: <20230320221022.GA4659@breakpoint.cc>
References: <1678233154187.35009@alliedtelesis.co.nz>
 <20230309012447.201582-1-kyuwon.shim@alliedtelesis.co.nz>
 <ZBL9TEfTBqwoEZH5@strlen.de>
 <7ee33839d49fe210dfb7347ea25724e9f43046e0.camel@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ee33839d49fe210dfb7347ea25724e9f43046e0.camel@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kyuwon Shim <Kyuwon.Shim@alliedtelesis.co.nz> wrote:
> Hi, Florian
> This is valgrind logs.
> 
> ==4797== Memcheck, a memory error detector
> ==4797== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et
> al.
> ==4797== Using Valgrind-3.19.0 and LibVEX; rerun with -h for copyright
> info
> ==4797== Command: ulogd -v -c /etc/ulogd.conf
> ==4797== Invalid read of size 4
> ==4797==    at 0x405F60: ulogd_unregister_fd (select.c:74)
> ==4797==    by 0x4E4E3DF: ??? (in /usr/lib/ulogd/ulogd_inppkt_NFLOG.so)
> ==4797==    by 0x405003: stop_pluginstances (ulogd.c:1335)
> ==4797==    by 0x405003: sigterm_handler_task (ulogd.c:1383)
> ==4797==    by 0x405153: call_signal_handler_tasks (ulogd.c:424)
> ==4797==    by 0x405153: signal_channel_callback (ulogd.c:443)
> ==4797==    by 0x406163: ulogd_select_main (select.c:105)
> ==4797==    by 0x403CF3: ulogd_main_loop (ulogd.c:1070)
> ==4797==    by 0x403CF3: main (ulogd.c:1649)
> ==4797==  Address 0x4a84f40 is 160 bytes inside a block of size 4,848
> free'd

Yuck, thanks for the backtrace.  I've applied the patch with an amended
changelog and a comment wrt. ::stop doing such things.
