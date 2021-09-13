Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC34C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA31610A2
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbhIMPnR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245001AbhIMPnK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:43:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F044AC0251AE
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 08:05:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mPnWX-0005su-Tg; Mon, 13 Sep 2021 17:05:33 +0200
Date:   Mon, 13 Sep 2021 17:05:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-test.py: print with color escapes only
 when stdout isatty
Message-ID: <20210913150533.GA22465@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20210902113307.2368834-1-snemec@redhat.com>
 <20210903125250.GK7616@orbyte.nwl.cc>
 <20210903164441+0200.281220-snemec@redhat.com>
 <20210903153420.GM7616@orbyte.nwl.cc>
 <20210906110438+0200.839986-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210906110438+0200.839986-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Sep 06, 2021 at 11:04:38AM +0200, Štěpán Němec wrote:
> On Fri, 03 Sep 2021 17:34:20 +0200
> Phil Sutter wrote:
> 
> > On Fri, Sep 03, 2021 at 04:44:41PM +0200, Štěpán Němec wrote:
> >> On Fri, 03 Sep 2021 14:52:50 +0200
> >> Phil Sutter wrote:
> >> 
> >> > With one minor nit:
> >> >
> >> >> diff --git a/iptables-test.py b/iptables-test.py
> >> >> index 90e07feed365..e8fc0c75a43e 100755
> >> >> --- a/iptables-test.py
> >> >> +++ b/iptables-test.py
> >> >> @@ -32,22 +32,25 @@ EXTENSIONS_PATH = "extensions"
> >> >>  LOGFILE="/tmp/iptables-test.log"
> >> >>  log_file = None
> >> >>  
> >> >> +STDOUT_IS_TTY = sys.stdout.isatty()
> >> >>  
> >> >> -class Colors:
> >> >> -    HEADER = '\033[95m'
> >> >> -    BLUE = '\033[94m'
> >> >> -    GREEN = '\033[92m'
> >> >> -    YELLOW = '\033[93m'
> >> >> -    RED = '\033[91m'
> >> >> -    ENDC = '\033[0m'
> >> >> +def maybe_colored(color, text):
> >> >> +    terminal_sequences = {
> >> >> +        'green': '\033[92m',
> >> >> +        'red': '\033[91m',
> >> >> +    }
> >> >> +
> >> >> +    return (
> >> >> +        terminal_sequences[color] + text + '\033[0m' if STDOUT_IS_TTY else text
> >> >> +    )
> >> >
> >> > I would "simplify" this into:
> >> >
> >> > | if not sys.stdout.isatty():
> >> > | 	return text
> >> > | return terminal_sequences[color] + text + '\033[0m'
> >> 
> >> ...which could be further simplified by dropping 'not' and swapping the
> >> two branches.
> >
> > My change was mostly about reducing the long line, i.e. cosmetics. ;)
> 
> Ah, I see. I agree it's not the prettiest thing, but it's still in 80
> columns (something that can't be said about a few other lines in the
> script).
> 
> > One other thing I just noticed, you're dropping the other colors'
> > definitions. Maybe worth keeping them?
> 
> Is it? I couldn't find anything but red and green ever being used since
> 2012 when the file was added.
> 
> > Also I'm not too happy about the Python exception if an unknown color
> > name is passed to maybe_colored(). OTOH though it's just a test script
> > and such bug is easily identified.
> 
> Yes, it's a helper function in a test script, not some kind of public
> API. I don't see how maybe_colored('magenta', ...) is different in that
> respect or more likely than print(Colors.MAGENTA + ...) previously.

OK, fine. I'm convinced. :)

Applied, thanks!
