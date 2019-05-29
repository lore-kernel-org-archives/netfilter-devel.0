Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2419AC04AB3
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 07:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0446120665
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 07:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfE2HtY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 03:49:24 -0400
Received: from mail.us.es ([193.147.175.20]:42854 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfE2HtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 03:49:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC985FB38E
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 09:49:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA787DA70A
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 09:49:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A011EDA710; Wed, 29 May 2019 09:49:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFC60DA707;
        Wed, 29 May 2019 09:49:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 09:49:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8D05C4265A32;
        Wed, 29 May 2019 09:49:09 +0200 (CEST)
Date:   Wed, 29 May 2019 09:49:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2]tests: json_echo: convert to py3
Message-ID: <20190529074909.uf5jujqvz26nuswi@salvia>
References: <20190528003653.7565-1-shekhar250198@gmail.com>
 <20190529074851.sjmnulacdufhhlmx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529074851.sjmnulacdufhhlmx@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 06:06:53AM +0530, Shekhar Sharma wrote:
> diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
> index 0132b139..dd7797fb 100755
> --- a/tests/json_echo/run-test.py
> +++ b/tests/json_echo/run-test.py
> @@ -1,5 +1,6 @@
> -#!/usr/bin/python2
> +#!/usr/bin/python
>  
> +from __future__ import print_function
>  import sys
>  import os
>  import json
> @@ -13,8 +14,8 @@ from nftables import Nftables
>  os.chdir(TESTS_PATH + "/../..")
>  
>  if not os.path.exists('src/.libs/libnftables.so'):
> -    print "The nftables library does not exist. " \
> -          "You need to build the project."
> +    print("The nftables library does not exist. "
> +          "You need to build the project.")
>      sys.exit(1)
>  
>  nftables = Nftables(sofile = 'src/.libs/libnftables.so')
> @@ -79,26 +80,26 @@ add_quota = { "add": {
>  # helper functions
>  
>  def exit_err(msg):
> -    print "Error: %s" % msg
> +    print("Error: %s" %msg)
>      sys.exit(1)
>  
>  def exit_dump(e, obj):
> -    print "FAIL: %s" % e
> -    print "Output was:"
> +    print("FAIL: {}".format(e))
> +    print("Output was:")
>      json.dumps(out, sort_keys = True, indent = 4, separators = (',', ': '))
>      sys.exit(1)
>  
>  def do_flush():
>      rc, out, err = nftables.json_cmd({ "nftables": [flush_ruleset] })
>      if not rc is 0:
> -        exit_err("flush ruleset failed: %s" % err)
> +        exit_err("flush ruleset failed: {}".format(err))
>  
>  def do_command(cmd):
>      if not type(cmd) is list:
>          cmd = [cmd]
>      rc, out, err = nftables.json_cmd({ "nftables": cmd })
>      if not rc is 0:
> -        exit_err("command failed: %s" % err)
> +        exit_err("command failed: {}".format(err))
>      return out
>  
>  def do_list_ruleset():
> @@ -123,7 +124,7 @@ def get_handle(output, search):
>              if not k in data:
>                  continue
>              found = True
> -            for key in search[k].keys():
> +            for key in list(search[k].keys()):

list() is not necessary, as Eric already mentioned, right?

Your patch is already in git.netfilter.org, so I have already pushed
it out BTW. If this is the case, just avoid this in your follow up
patches for other existing scripts. Thanks.
