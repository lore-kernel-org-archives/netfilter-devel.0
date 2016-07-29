From: Florian Westphal <fw@strlen.de>
Subject: Re: NFQUEUE panic bug
Date: Fri, 29 Jul 2016 14:10:26 +0200
Message-ID: <20160729121026.GC26237@breakpoint.cc>
References: <CAOmdcgVGCZnoGCu1B4Z5w_EQLDLyfm==6fVvTttgZBqPGxuPeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Collins <daniel.collins@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39762 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbcG2MK2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2016 08:10:28 -0400
Content-Disposition: inline
In-Reply-To: <CAOmdcgVGCZnoGCu1B4Z5w_EQLDLyfm==6fVvTttgZBqPGxuPeQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Collins <daniel.collins@smoothwall.net> wrote:
> I've found a race condition which allows remotely triggering a kernel
> panic, should I post the details to this list, or somewhere else?

Is a fix already available?
if so just post to list.

If not please post bug report to coreteam so we can investigate.
