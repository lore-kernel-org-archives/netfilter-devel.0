Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3A3C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 12:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30BF610C8
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 12:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349402AbhICMxx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 08:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbhICMxx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 08:53:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E3DC061575
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Sep 2021 05:52:52 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mM8gc-0007bo-EJ; Fri, 03 Sep 2021 14:52:50 +0200
Date:   Fri, 3 Sep 2021 14:52:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-test.py: print with color escapes only
 when stdout isatty
Message-ID: <20210903125250.GK7616@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20210902113307.2368834-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902113307.2368834-1-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Sep 02, 2021 at 01:33:07PM +0200, Štěpán Němec wrote:
> When the output doesn't go to a terminal (typical case: log files),
> the escape sequences are just noise.
> 
> Signed-off-by: Štěpán Němec <snemec@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>

With one minor nit:

> diff --git a/iptables-test.py b/iptables-test.py
> index 90e07feed365..e8fc0c75a43e 100755
> --- a/iptables-test.py
> +++ b/iptables-test.py
> @@ -32,22 +32,25 @@ EXTENSIONS_PATH = "extensions"
>  LOGFILE="/tmp/iptables-test.log"
>  log_file = None
>  
> +STDOUT_IS_TTY = sys.stdout.isatty()
>  
> -class Colors:
> -    HEADER = '\033[95m'
> -    BLUE = '\033[94m'
> -    GREEN = '\033[92m'
> -    YELLOW = '\033[93m'
> -    RED = '\033[91m'
> -    ENDC = '\033[0m'
> +def maybe_colored(color, text):
> +    terminal_sequences = {
> +        'green': '\033[92m',
> +        'red': '\033[91m',
> +    }
> +
> +    return (
> +        terminal_sequences[color] + text + '\033[0m' if STDOUT_IS_TTY else text
> +    )

I would "simplify" this into:

| if not sys.stdout.isatty():
| 	return text
| return terminal_sequences[color] + text + '\033[0m'

But what's beautiful in C might be ugly in Python and I'm blind to that
aspect. ;)

Cheers, Phil
