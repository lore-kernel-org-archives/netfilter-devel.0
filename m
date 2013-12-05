From: Florian Westphal <fw@strlen.de>
Subject: Re: libmnl [PATCH 2/5] examples: fix trivial error message
Date: Thu, 5 Dec 2013 15:27:46 +0100
Message-ID: <20131205142746.GH2767@breakpoint.cc>
References: <CAGCkEt1+dni9L0-5OYsPnoOhBZGB6XaRSQ9T_GKifSE4pwC_PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36591 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab3LEO1r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:27:47 -0500
Content-Disposition: inline
In-Reply-To: <CAGCkEt1+dni9L0-5OYsPnoOhBZGB6XaRSQ9T_GKifSE4pwC_PQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> Date: Thu, 7 Nov 2013 16:52:15 +0900
> Subject: [PATCH 2/5] examples: fix trivial error message

Something corrupted the patch formattig, breaking long lines,
converting tabs/spaces, etc:
patch: **** malformed patch at line 45: *attr, void *data)

> index a862912..901bd80 100644
> --- a/examples/netfilter/nf-log.c
> +++ b/examples/netfilter/nf-log.c
> @@ -39,14 +39,14 @@ static int parse_attr_cb(const struct nlattr
> *attr, void *data)

Here for example.

It would be nice if you could fix this (mail patch to yourself,
then check if it applies via 'patch -p1' or 'git am'.

If you resend, can you also include a 'Signed-off-by' tag?

After that, we can apply your change.

Thanks!
