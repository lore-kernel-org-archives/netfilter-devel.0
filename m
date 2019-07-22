Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71585C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3720E21738
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="sj3cZraB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfGVQ4D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:56:03 -0400
Received: from mx1.riseup.net ([198.252.153.129]:38042 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbfGVQ4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 12:56:02 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 49EF41A4BDD;
        Mon, 22 Jul 2019 09:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563814562; bh=dBW319YZLP824ARjlEpRMgpzcfu1moQcY06xWhkbf40=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=sj3cZraBy+gzxVEr7ibgHjpOQ1T7hySn02VlhEW8ek/qSWab9NJUIkj91zDlekRGQ
         PPmS+VJ4WelAvir1J0BrN/fTKIdsKI3RwviYqVUipNte/7DUmVr5nhv+YDPCnlVsAQ
         DQB1EH80sfUVul+S4g6yD2869WyiQofl/GpCGX/k=
X-Riseup-User-ID: 276D0351996F59704C86BA5D1064499A4CE6A2B6508285376888B368FAB6CE48
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 95A6322220C;
        Mon, 22 Jul 2019 09:55:42 -0700 (PDT)
Subject: Re: memleak when using "nft -f"
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Phil Sutter <phil@nwl.cc>
References: <8d5745ef-5199-4754-55ee-22c6c5994341@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <d41b858e-64a9-d8ae-275a-2b82b77fb7b8@riseup.net>
Date:   Mon, 22 Jul 2019 18:55:56 +0200
MIME-Version: 1.0
In-Reply-To: <8d5745ef-5199-4754-55ee-22c6c5994341@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Never mind, I found the problem. It was a patch on my local branch.
Sorry for the inconveniences.

On 7/22/19 6:16 PM, Fernando Fernandez Mancera wrote:
> Hi,
> 
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
> 
