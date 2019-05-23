Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A950C282E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5528820881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJn3d5d6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390772AbfEWTjY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 15:39:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46423 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390559AbfEWTjY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 15:39:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so3135048pls.13
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 12:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ODtJZkOMIQXDJ07If6u5vVfYLS8HO4jW6BccBOZirE4=;
        b=QJn3d5d6d4KHKVjgIQOwrSiF+klknzTVaiKc4O/4hGsHVB6BL43pYerBsOEWXSN9VX
         I2+Qe78lCW/q72UW8muxZLBP6Z9JWfr+BSKxZXDgoqOcOd5qJ+UpCU6nKGnCpTPlZTFd
         L/AwWr1mQUxze/ZBSlo9jL1H05uTsoafQUyOGUpiaKLkh3cCepBACzuthJP3/1n0d4mZ
         +mWjJFX/EjNA/RxAE+q3+z5pgzTKv/EV9wnl6NNGUKZrnAXYLqZL8vtrGcnq7gQzvcM7
         XwNFFFulnaeqHMM6ymCrud0zKIa3sSpkECHkh8xjQr4YXap4QUAdFIU1vHDPbN58QKMv
         eX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ODtJZkOMIQXDJ07If6u5vVfYLS8HO4jW6BccBOZirE4=;
        b=pNToLI+ATUrggj0IthAMP+3oc50yrIhYq5uEMqe2E5YENqhDL3FKnXqv08y9CyPM+q
         krUBh7nLseyAfX6xDa+J2CeJ7kASeXy6I/8RwKY/1kbQ1TAHTAHKj5sq/xdrVJOUAAce
         SEbS0meMV6VDXO3lw+H8V9rH9kVYnwt+GM6Kgy9cJT1abVQQLLVXClxzMOSrwsgi5Xjz
         0DFphApBFdzhIFVz/P/R8omQEhLJ1NXI0kvYeCPrAgj8nWbTkvElwiID6TTYFZXN9n3K
         mHCBK/KHeQhCfRrCTMGiq20+4OYDZysMpT8XdyusEVZy0zGqab578n6z8/kGSAA/tkBR
         s8lg==
X-Gm-Message-State: APjAAAU6U2l6xchcQEwvqjeF+M9GhJk33cYC5kIXE4msYzsf897JVeEn
        YW2nujfi6Ro4NIg+lGKncOC8QsIsOCo=
X-Google-Smtp-Source: APXvYqylDBQuiJjror+I1ac7XVmzetVLPDmcUVYftLGFS6v08PRnIP2JI7sFMpa5MQcNg1FMDprimA==
X-Received: by 2002:a17:902:21:: with SMTP id 30mr84239411pla.302.1558640363250;
        Thu, 23 May 2019 12:39:23 -0700 (PDT)
Received: from localhost.localdomain ([2405:204:e08c:113f:3445:8a22:76d:1471])
        by smtp.gmail.com with ESMTPSA id z4sm217711pfa.142.2019.05.23.12.39.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 12:39:22 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft v3]tests: py: fix python3.
Date:   Fri, 24 May 2019 01:09:08 +0530
Message-Id: <20190523193908.405176-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Yes, the '\' can be removed, will remove it if I make any other changes in the future.

Thanks Eric, Pablo and Shivani for all your hints :-).

Shekhar

On Fri, May 24, 2019, 12:45 AM shekhar sharma <shekhar250198@gmail.com> wrote:
Yes, the '\' can be removed, will remove it if I make any other changes in the future.

Thanks Eric, Pablo and Shivani for all your hints :-). 

Shekhar 

On Fri, May 24, 2019, 12:41 AM Eric Garver <eric@garver.life> wrote:
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
