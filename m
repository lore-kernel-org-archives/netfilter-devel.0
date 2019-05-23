Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B183C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E16C22133D
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbfEWTLE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 15:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388061AbfEWTLD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 15:11:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E060A300502A;
        Thu, 23 May 2019 19:11:02 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-215.rdu2.redhat.com [10.10.122.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0110A19735;
        Thu, 23 May 2019 19:11:00 +0000 (UTC)
Date:   Thu, 23 May 2019 15:10:59 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4] tests: py: fix python3
Message-ID: <20190523191059.cgvbmg32bo533cpv@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190523182622.386876-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523182622.386876-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 23 May 2019 19:11:03 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 23, 2019 at 11:56:22PM +0530, Shekhar Sharma wrote:
> This version of the patch converts the file into python3 and also uses
> .format() method to make the print statments cleaner.
> 
> The version history of this topic is:
> 
> v1: conversion to py3 by changing print statements.
> v2: adds the '__future__' package for compatibility with py2 and py3.
> v3: solves the 'version' problem in argparse by adding a new argument.
> v4: uses .format() method to make the print statements cleaner.
> 
> 
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---

Acked-by: Eric Garver <eric@garver.life>

>  tests/py/nft-test.py | 47 ++++++++++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 1c0afd0e..ab26d08d 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
[..]
> @@ -1353,15 +1358,15 @@ def main():
>      signal.signal(signal.SIGTERM, signal_handler)
>  
>      if os.getuid() != 0:
> -        print "You need to be root to run this, sorry"
> +        print("You need to be root to run this, sorry")
>          return
>  
>      # Change working directory to repository root
>      os.chdir(TESTS_PATH + "/../..")
>  
>      if not os.path.exists('src/.libs/libnftables.so'):
> -        print "The nftables library does not exist. " \
> -              "You need to build the project."
> +        print("The nftables library does not exist. " \
> +              "You need to build the project.")

nit: The trailing '\' can be removed now that the strings are inside
parenthesis. I don't think it's worth rerolling the patch though.
