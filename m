From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] examples: Fix memory leaks detected by Valgrind
Date: Mon, 4 Sep 2017 22:49:47 +0200
Message-ID: <20170904204947.GA14775@salvia>
References: <1504010976-13897-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:50070 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdIDUuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 16:50:15 -0400
Content-Disposition: inline
In-Reply-To: <1504010976-13897-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 29, 2017 at 06:19:36PM +0530, Shyam Saini wrote:
> ==11688== HEAP SUMMARY:
> ==11688==     in use at exit: 40 bytes in 1 blocks
> ==11688==   total heap usage: 7 allocs, 6 frees, 220 bytes allocated
> ==11688==
> ==11688== 40 bytes in 1 blocks are definitely lost in loss record 1 of 1
> ==11688==    at 0x4C2AB80: malloc (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==11688==    by 0x5068955: mnl_nlmsg_batch_start (nlmsg.c:441)
> ==11688==    by 0x40133B: main (nft-chain-add.c:103)
> ==11688==
> ==11688== LEAK SUMMARY:
> ==11688==    definitely lost: 40 bytes in 1 blocks
> ==11688==    indirectly lost: 0 bytes in 0 blocks
> ==11688==      possibly lost: 0 bytes in 0 blocks
> ==11688==    still reachable: 0 bytes in 0 blocks
> ==11688==         suppressed: 0 bytes in 0 blocks
> 
> ==11831== HEAP SUMMARY:
> ==11831==     in use at exit: 40 bytes in 1 blocks
> ==11831==   total heap usage: 7 allocs, 6 frees, 220 bytes allocated
> ==11831==
> ==11831== 40 bytes in 1 blocks are definitely lost in loss record 1 of 1
> ==11831==    at 0x4C2AB80: malloc (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==11831==    by 0x5068955: mnl_nlmsg_batch_start (nlmsg.c:441)
> ==11831==    by 0x401154: main (nft-chain-del.c:79)
> ==11831==
> ==11831== LEAK SUMMARY:
> ==11831==    definitely lost: 40 bytes in 1 blocks
> ==11831==    indirectly lost: 0 bytes in 0 blocks
> ==11831==      possibly lost: 0 bytes in 0 blocks
> ==11831==    still reachable: 0 bytes in 0 blocks
> ==11831==         suppressed: 0 bytes in 0 blocks

Applied, thanks.
