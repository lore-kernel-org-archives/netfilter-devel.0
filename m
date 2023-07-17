Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1F7C001B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jul 2023 09:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjGQJTj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jul 2023 05:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjGQJTi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2023 05:19:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E70A10DC;
        Mon, 17 Jul 2023 02:19:37 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:19:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net,
        guigom@riseup.net
Subject: Re: [ANNOUNCE] libnftnl 1.2.6 release
Message-ID: <ZLUHo/spWd98PMUS@calendula>
References: <ZK2KUlzZzlQ8/mKa@calendula>
 <36852014-p9pp-srp2-pn24-orr4385p70qo@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <36852014-p9pp-srp2-pn24-orr4385p70qo@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Mon, Jul 17, 2023 at 10:09:09AM +0200, Jan Engelhardt wrote:
> 
> On Tuesday 2023-07-11 18:58, Pablo Neira Ayuso wrote:
> >The Netfilter project proudly presents:
> >        libnftnl 1.2.6
> 
> Something is off here.
> With 1.2.5 I had:
> 
> /usr/lib/python3.11/site-packages/nftables
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg-info
> /usr/lib/python3.11/site-packages/nftables/__init__.py
> /usr/lib/python3.11/site-packages/nftables/__pycache__
> /usr/lib/python3.11/site-packages/nftables/__pycache__/__init__.cpython-311.pyc
> /usr/lib/python3.11/site-packages/nftables/__pycache__/nftables.cpython-311.pyc
> /usr/lib/python3.11/site-packages/nftables/nftables.py
> /usr/lib/python3.11/site-packages/nftables/schema.json
> 
> With 1.2.6 I get:
> 
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/PKG-INFO
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/SOURCES.txt
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/dependency_links.txt
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/not-zip-safe
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/EGG-INFO/top_level.txt
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__init__.py
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__pycache__
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__pycache__/__init__.cpython-311.pyc
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/__pycache__/nftables.cpython-311.pyc
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/nftables.py
> /usr/lib/python3.11/site-packages/nftables-0.1-py3.11.egg/nftables/schema.json
> 
> And then python3 -c 'import nftables' no longer wants to do anything with it:
> 
> Traceback (most recent call last):
>   File "<string>", line 1, in <module>
> ModuleNotFoundError: No module named 'nftables'
> 
> Looking at how other modules are laid out, I find e.g.
> 
> [...]
> /usr/lib/python3.11/site-packages/pycparser/plyparser.py
> /usr/lib/python3.11/site-packages/pycparser/yacctab.py
> /usr/lib/python3.11/site-packages/pycparser-2.21-py3.11.egg-info
> /usr/lib/python3.11/site-packages/pycparser-2.21-py3.11.egg-info/PKG-INFO
> /usr/lib/python3.11/site-packages/pycparser-2.21-py3.11.egg-info/SOURCES.txt
> [...]
> 
> So there is one directory level too much.

Could you revert:

1acc2fd48c75 ("py: replace distutils with setuptools")

I suspect the problem is in the update from distutil to setuptools.
