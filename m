From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: EXPORT_SYMBOL missing in the kernel?
Date: Tue, 24 May 2011 23:32:49 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105242323290.2691@frira.zrqbmnf.qr>
References: <4DDBACA6.2060501@gmail.com> <1306244451.3026.42.camel@edumazet-laptop> <4DDBB71D.6080205@gmail.com> <alpine.LNX.2.01.1105241639150.32028@frira.zrqbmnf.qr> <4DDBD1FD.1070203@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:52379 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1EXVcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 17:32:51 -0400
In-Reply-To: <4DDBD1FD.1070203@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2011-05-24 17:42, Pierre Rondou wrote:
>
>The little complain about NATIVI
>(http://www.spinics.net/lists/netfilter-devel/msg18248.html) was
>that no kernel/Xtables developers told me they wanted the module
>inside the kernel/Xtables

But they did not say "don't want" either :)

Sorry, I must have skipped over that mail somehow. It's still in
my inbox, so that means the topic had not been closed.

The only other "excuse" I can give is that, on a closer look now, the
mail did not contain a merge request, just an offer for help.
(Wording: "If you believe that this module can be included is the
Linux Kernel or in the Xtables-addons framework, I'll be glad and
will help you in this task.")

If you, or somebody else, wants to have it merged, in either the
kernel or Xtables-addons, please send in a patch, and we will discuss
it from there on.

> While I'm sending you an e-mail, I may contribute to your very interesting
> "Writing Netfilter modules" ebook.

If you replace .pdf in the URL by .lyx, you can get at the source
of the document and make a patch against that if you like.
Other ways to convey your additions are also acceptable - it
is not required to be diff.
