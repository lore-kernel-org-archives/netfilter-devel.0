Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBC5C4167B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 15:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiK2Pv0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 10:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236051AbiK2PvN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 10:51:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346EF663E6
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 07:50:55 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p02sn-0007Mb-Jf; Tue, 29 Nov 2022 16:50:53 +0100
Date:   Tue, 29 Nov 2022 16:50:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 iptables-nft 3/3] xlate-test: avoid shell entanglements
Message-ID: <Y4YqXYpSSXqwE+bm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221129140542.28311-1-fw@strlen.de>
 <20221129140542.28311-4-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129140542.28311-4-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 29, 2022 at 03:05:42PM +0100, Florian Westphal wrote:
> Feed the nft expected output found in the .txlate test files to
> nft -f via pipe/stdin directly without the shell mangling it.
> 
> The shell step isn't needed anymore because xtables-translate no longer
> escapes quotes.
> 
> We only need to remove the "nft '" and trailing "'" because nft doesn't
> expect those.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  new in v2.
> 
>  xlate-test.py | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/xlate-test.py b/xlate-test.py
> index f3fcd797af90..b93bf0547213 100755
> --- a/xlate-test.py
> +++ b/xlate-test.py
> @@ -7,11 +7,11 @@ import shlex
>  import argparse
>  from subprocess import Popen, PIPE
>  
> -def run_proc(args, shell = False):
> +def run_proc(args, shell = False, input = None):
>      """A simple wrapper around Popen, returning (rc, stdout, stderr)"""
>      process = Popen(args, text = True, shell = shell,
> -                    stdout = PIPE, stderr = PIPE)
> -    output, error = process.communicate()
> +                    stdin = PIPE, stdout = PIPE, stderr = PIPE)
> +    output, error = process.communicate(input)
>      return (process.returncode, output, error)
>  
>  keywords = ("iptables-translate", "ip6tables-translate", "ebtables-translate")
> @@ -100,15 +100,15 @@ def test_one_replay(name, sourceline, expected, result):
>          fam = "ip6 "
>      elif srccmd.startswith("ebt"):
>          fam = "bridge "
> +
> +    expected = expected.removeprefix("nft '").removesuffix("'")

Does this work with multi-line expected? I guess this one should do:

| expected = [l.removeprefix("nft ").strip(" '") for l in expected.split("\n")]

(Note how I fixed it for "tickless" lines. ;)

Cheers, Phil
