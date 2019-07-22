Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD92C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 972912199C
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbfGVQ6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:58:49 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:46236 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfGVQ6t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 12:58:49 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hpbeB-0005V2-81; Mon, 22 Jul 2019 18:58:47 +0200
Date:   Mon, 22 Jul 2019 18:58:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: memleak when using "nft -f"
Message-ID: <20190722165847.GM22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <8d5745ef-5199-4754-55ee-22c6c5994341@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d5745ef-5199-4754-55ee-22c6c5994341@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

On Mon, Jul 22, 2019 at 06:16:14PM +0200, Fernando Fernandez Mancera wrote:
> I have found a memleak when using "nft -f".
> 
> Example file (test-memleak):
> 
> add table ip foo
> add chain ip foo bar {type filter hook input priority filter;}
> 
> # valgrind --leak-check=full nft -f test-memleak
> 
> ==12624== Memcheck, a memory error detector
> ==12624== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
> ==12624== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
> ==12624== Command: nft -f policy_test
> ==12624==
> ==12624==
> ==12624== HEAP SUMMARY:
> ==12624==     in use at exit: 7 bytes in 1 blocks
> ==12624==   total heap usage: 59 allocs, 58 frees, 242,068 bytes allocated
> ==12624==
> ==12624== 7 bytes in 1 blocks are definitely lost in loss record 1 of 1
> ==12624==    at 0x483577F: malloc (vg_replace_malloc.c:299)
> ==12624==    by 0x4C4FDB9: strdup (strdup.c:42)
> ==12624==    by 0x488403D: xstrdup (utils.c:75)
> ==12624==    by 0x48A7C0F: nft_lex (scanner.l:641)
> ==12624==    by 0x489827B: nft_parse (parser_bison.c:5482)
> ==12624==    by 0x4889797: nft_parse_bison_filename (libnftables.c:395)
> ==12624==    by 0x4889797: nft_run_cmd_from_filename (libnftables.c:498)
> ==12624==    by 0x10A616: main (main.c:318)
> ==12624==
> ==12624== LEAK SUMMARY:
> ==12624==    definitely lost: 7 bytes in 1 blocks
> ==12624==    indirectly lost: 0 bytes in 0 blocks
> ==12624==      possibly lost: 0 bytes in 0 blocks
> ==12624==    still reachable: 0 bytes in 0 blocks
> ==12624==         suppressed: 0 bytes in 0 blocks
> ==12624==
> ==12624== For counts of detected and suppressed errors, rerun with: -v
> ==12624== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)
> 
> I have been trying to debug this but I was not able to find where is the
> problem.

The trace indicates memory allocated for a STRING is lost (overwritten).
Maybe the defined destructor in src/parser_bison.y is not called? Note
that I don't see that memleak on my testing VM.

Cheers, Phil
