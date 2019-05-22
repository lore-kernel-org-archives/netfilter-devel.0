Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79668C18E7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 10:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57D3B20645
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 10:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfEVKFa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 06:05:30 -0400
Received: from mail.us.es ([193.147.175.20]:45934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbfEVKF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 06:05:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E58F1C40EE
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 12:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D549ADA708
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 12:05:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D3DDBDA703; Wed, 22 May 2019 12:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2DAFDA71A;
        Wed, 22 May 2019 12:05:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 May 2019 12:05:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 75AF84265A32;
        Wed, 22 May 2019 12:05:25 +0200 (CEST)
Date:   Wed, 22 May 2019 12:05:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v3]tests: py: fix python3.
Message-ID: <20190522100524.m65rnqoe3mlavmlj@salvia>
References: <20190522090704.145192-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522090704.145192-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Shekar,

Thanks for your patch, comments below.

On Wed, May 22, 2019 at 02:37:04PM +0530, Shekhar Sharma wrote:
> This patch solves the problem with the 'version' in the constructor of
> argparse (line 1325). A new argument has been added for printing the version.
> Now the file will run in python2 as well as python3.
>
> Thanks eric for the hint! :-)

Please, keep the original patch description between patch versions.

> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---

Here, after the '---' above, you can place incremental updates versus
previous patch version, for example:

v3: This patch solves the problem with the 'version' in the
    constructor of argparse (line 1325). A new argument has been added for
    printing the version. Now the file will run in python2 as well as
    python3. Thanks eric for the hint! :-)

More comments below.

>  tests/py/nft-test.py | 125 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 88 insertions(+), 37 deletions(-)
>
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 1c0afd0e..bb643ccc 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -13,6 +13,8 @@
>  # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
>  # infrastructure.
>
> +from __future__ import print_function
> +#from nftables import Nftables
>  import sys
>  import os
>  import argparse
> @@ -22,7 +24,6 @@ import json
>  TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
>  sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
>
> -from nftables import Nftables
>
>  TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
>  LOGFILE = "/tmp/nftables-test.log"
> @@ -171,27 +172,31 @@ def print_differences_error(filename, lineno, cmd):
>      print_error(reason, filename, lineno)
>
>
> -def table_exist(table, filename, lineno):
> +def table_exist(table, filename, lineno, netns):
>      '''
>      Exists a table.
>      '''
>      cmd = "list table %s" % table
> +    if netns:
> +        cmd = "ip netns exec ___nftables-container-test" + cmd

It seems you're mixing the fix for Python3 and with the netns support.

Please, keep two separated patches for this; policy is "one logic
change per patch", and this would include two logic changes.

Thanks.
