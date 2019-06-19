Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E22C31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 12:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA634208CB
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 12:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfFSMxK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbfFSMxK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 08:53:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E8BB930860A5;
        Wed, 19 Jun 2019 12:52:57 +0000 (UTC)
Received: from egarver.localdomain (ovpn-121-240.rdu2.redhat.com [10.10.121.240])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 308A31001925;
        Wed, 19 Jun 2019 12:52:54 +0000 (UTC)
Date:   Wed, 19 Jun 2019 08:52:54 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     shekhar sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] nft-test.py: use tempfile module
Message-ID: <20190619125254.atenkuzvn4xzar5q@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        shekhar sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <CAN9XX2pWQY0Rz2cGv7V=v8+g0mUTNGWS4pf0FJwScmrNpC5Kjg@mail.gmail.com>
 <20190618182127.21110-1-eric@garver.life>
 <20190619103944.acxr3rw7cbj4eylh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619103944.acxr3rw7cbj4eylh@salvia>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 19 Jun 2019 12:53:10 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 19, 2019 at 12:39:44PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 18, 2019 at 02:21:27PM -0400, Eric Garver wrote:
> > os.tmpfile() is not in python3.
> 
> If I apply:
> 
> https://patchwork.ozlabs.org/patch/1116034/
> 
> and this patch, it's getting better, but still I hit one problem:
> 
> # python3 nft-test.py
> INFO: Log will be available at /tmp/nftables-test.log
> any/fwd.t: OK
> any/rt.t: OK
> any/queue.t: OK
> any/dup.t: OK
> any/log.t: OK
> Traceback (most recent call last):
>   File "nft-test.py", line 1455, in <module>
>     main()
>   File "nft-test.py", line 1423, in main
>     result = run_test_file(filename, force_all_family_option,
> specific_file)
>   File "nft-test.py", line 1291, in run_test_file
>     filename_path)
>   File "nft-test.py", line 846, in rule_add
>     rule_output.rstrip()) != 0:
>   File "nft-test.py", line 495, in set_check_element
>     if (cmp(rule1[:pos1], rule2[:pos2]) != 0):
> NameError: name 'cmp' is not defined

I will post a short series today to address this as well.
