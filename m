Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E44C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 08:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73E7E206F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 08:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfKRI3g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:29:36 -0500
Received: from vxsys-smtpclusterma-05.srv.cat ([46.16.61.56]:33883 "EHLO
        vxsys-smtpclusterma-05.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbfKRI3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 03:29:36 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2019 03:29:35 EST
Received: from webmail.juaristi.eus (unknown [10.40.17.4])
        by vxsys-smtpclusterma-05.srv.cat (Postfix) with ESMTPA id 84A4824166;
        Mon, 18 Nov 2019 09:20:20 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 18 Nov 2019 09:20:20 +0100
From:   Ander Juaristi <a@juaristi.eus>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/py: Set a fixed timezone in nft-test.py
Reply-To: a@juaristi.eus
Mail-Reply-To: a@juaristi.eus
In-Reply-To: <20191116213218.14698-1-phil@nwl.cc>
References: <20191116213218.14698-1-phil@nwl.cc>
Message-ID: <547c39efa7f1d2230d08845a4e19ab5f@juaristi.eus>
X-Sender: a@juaristi.eus
User-Agent: Roundcube Webmail
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I had a hard time getting time zones right. Thank you.

Acked-by: Ander Juaristi <a@juaristi.eus>

El 2019-11-16 22:32, Phil Sutter escribió:
> Payload generated for 'meta time' matches depends on host's timezone 
> and
> DST setting. To produce constant output, set a fixed timezone in
> nft-test.py. Choose UTC-2 since most payloads are correct then, adjust
> the remaining two tests.
> 
> Fixes: 0518ea3f70d8c ("tests: add meta time test cases")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/py/any/meta.t         | 2 +-
>  tests/py/any/meta.t.payload | 2 +-
>  tests/py/nft-test.py        | 1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
> index 86e5d258605dc..327f973f1bd5a 100644
> --- a/tests/py/any/meta.t
> +++ b/tests/py/any/meta.t
> @@ -205,7 +205,7 @@ meta random eq 1;ok;meta random 1
>  meta random gt 1000000;ok;meta random > 1000000
> 
>  meta time "1970-05-23 21:07:14" drop;ok
> -meta time 12341234 drop;ok;meta time "1970-05-23 21:07:14" drop
> +meta time 12341234 drop;ok;meta time "1970-05-23 22:07:14" drop
>  meta time "2019-06-21 17:00:00" drop;ok
>  meta time "2019-07-01 00:00:00" drop;ok
>  meta time "2019-07-01 00:01:00" drop;ok
> diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
> index 402caae5cad8c..486d7aa566ea3 100644
> --- a/tests/py/any/meta.t.payload
> +++ b/tests/py/any/meta.t.payload
> @@ -1050,7 +1050,7 @@ ip test-ip4 input
>  # meta time "1970-05-23 21:07:14" drop
>  ip meta-test input
>    [ meta load time => reg 1 ]
> -  [ cmp eq reg 1 0x74a8f400 0x002bd849 ]
> +  [ cmp eq reg 1 0x43f05400 0x002bd503 ]
>    [ immediate reg 0 drop ]
> 
>  # meta time 12341234 drop
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index ce42b5ddb1cca..6edca3c6a5a2f 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -24,6 +24,7 @@ import tempfile
> 
>  TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
>  sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
> +os.environ['TZ'] = 'UTC-2'
> 
>  from nftables import Nftables
