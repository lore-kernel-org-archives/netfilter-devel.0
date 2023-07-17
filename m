Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2FDC001DE
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jul 2023 08:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjGQIJt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jul 2023 04:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjGQIJq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2023 04:09:46 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190AF1732;
        Mon, 17 Jul 2023 01:09:22 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id EDEC05872FFD4; Mon, 17 Jul 2023 10:09:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id ED48360D6E2DB;
        Mon, 17 Jul 2023 10:09:09 +0200 (CEST)
Date:   Mon, 17 Jul 2023 10:09:09 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] libnftnl 1.2.6 release
In-Reply-To: <ZK2KUlzZzlQ8/mKa@calendula>
Message-ID: <36852014-p9pp-srp2-pn24-orr4385p70qo@vanv.qr>
References: <ZK2KUlzZzlQ8/mKa@calendula>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2023-07-11 18:58, Pablo Neira Ayuso wrote:
>The Netfilter project proudly presents:
>        libnftnl 1.2.6

Something is off here.
With 1.2.5 I had:

/usr/lib/python3.11/site-packages/nftables
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg-info
/usr/lib/python3.11/site-packages/nftables/__init__.py
/usr/lib/python3.11/site-packages/nftables/__pycache__
/usr/lib/python3.11/site-packages/nftables/__pycache__/__init__.cpython-311.pyc
/usr/lib/python3.11/site-packages/nftables/__pycache__/nftables.cpython-311.pyc
/usr/lib/python3.11/site-packages/nftables/nftables.py
/usr/lib/python3.11/site-packages/nftables/schema.json

With 1.2.6 I get:

/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/PKG-INFO
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/SOURCES.txt
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/dependency_links.txt
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/not-zip-safe
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/top_level.txt
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__init__.py
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__pycache__
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__pycache__/__init__.cpython-311.pyc
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__pycache__/nftables.cpython-311.pyc
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/nftables.py
/usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/schema.json

And then python3 -c 'import nftables' no longer wants to do anything with it:

Traceback (most recent call last):
  File "<string>", line 1, in <module>
ModuleNotFoundError: No module named 'nftables'

Looking at how other modules are laid out, I find e.g.

[...]
/usr/lib/python3.11/site-packages/pycparser/plyparser.py
/usr/lib/python3.11/site-packages/pycparser/yacctab.py
/usr/lib/python3.11/site-packages/pycparser-2.21-py3.11.egg-info
/usr/lib/python3.11/site-packages/pycparser-2.21-py3.11.egg-info/PKG-INFO
/usr/lib/python3.11/site-packages/pycparser-2.21-py3.11.egg-info/SOURCES.txt
[...]

So there is one directory level too much.
