Return-Path: <SRS0=IJRP=TQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDDBC04AAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 19:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6481206A3
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 19:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEPTbx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 May 2019 15:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfEPTbx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 May 2019 15:31:53 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D601B711F5;
        Thu, 16 May 2019 19:31:52 +0000 (UTC)
Received: from egarver.localdomain (ovpn-126-19.rdu2.redhat.com [10.10.126.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B1B760BE5;
        Thu, 16 May 2019 19:31:51 +0000 (UTC)
Date:   Thu, 16 May 2019 15:31:51 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: py: fix python3.
Message-ID: <20190516193151.gmc6cxqvomdcrspf@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190515174354.5980-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515174354.5980-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 16 May 2019 19:31:52 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Shekhar,

Please use git-format-patch option "-v" next revision.

On Wed, May 15, 2019 at 11:13:54PM +0530, Shekhar Sharma wrote:
> This changes all the python2 files to python3.
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
[..]
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 1c0afd0e..35c5d0e5 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -436,7 +436,7 @@ def set_delete(table, filename=None, lineno=None):
>      '''
>      Deletes set and its content.
>      '''
> -    for set_name in all_set.keys():
> +    for set_name in list(all_set.keys()):
>          # Check if exists the set
>          if not set_exist(set_name, table, filename, lineno):
>              reason = "The set %s does not exist, " \
> @@ -1002,9 +1002,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
>      :param debug: temporarily set these debug flags
>      '''
>      global log_file
> -    print >> log_file, "command: %s" % cmd
> +    print("command: %s" % cmd, file= log_file)

python2 throws a syntax error here.

    $ python2 -m py_compile tests/py/nft-test.py                                                                                                                                                                                            
      File "tests/py/nft-test.py", line 1005                                                                                                                                                                                                                                        
        print("command: %s" % cmd, file= log_file)

    SyntaxError: invalid syntax

I think you need to add this to the top of the file:

    from __future__ import print_function

>      if debug_option:
> -        print cmd
> +        print(cmd)
>  
>      if debug:
>          debug_old = nftables.get_debug()
[..]
> @@ -1353,15 +1353,15 @@ def main():
>      signal.signal(signal.SIGTERM, signal_handler)
>  
>      if os.getuid() != 0:
> -        print "You need to be root to run this, sorry"
> +        print("You need to be root to run this, sorry") 

nit: This adds a space at the end which git-am complains about.
