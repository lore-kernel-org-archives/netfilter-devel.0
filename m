From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Resend ULOGD PATCH] Add event output and make event mask	configurable
  in NFCT.
Date: Sat, 05 Apr 2008 17:29:20 +0200
Message-ID: <47F79AD0.5010805@netfilter.org>
References: <47E99B88.9090200@netfilter.org> <12064930002868-git-send-email-eric@inl.fr> <47EA188B.4090807@netfilter.org> <20080405102137.GC5333@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55320 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752125AbYDEP3h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:29:37 -0400
In-Reply-To: <20080405102137.GC5333@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> I've tested and applied all my not applied ulogd2 patches other current
> subversion tree. They apply cleanly. I've published a git tree which
> contains this patches.
> 
> Git tree: http://home.regit.org/~regit/git/ulogd2.git
> Gitweb: http://home.regit.org/cgi-bin/gitweb.cgi?p=ulogd2.git;a=shortlog;h=ML
> 
> The ML branch is the one containing all the patches.

I'm not against the fact of having you all personal git trees with your
developments. However, it make more sense to me to keep development
trees if you have something that will take some time (for different
reasons [1]) to get into mainline, like for example, Krisztian Kovacs's
tproxy.

For ulogd patches or, in general, patches for whatever that has been
posted in the ML. I think it's a bit too much as we'll keep in sync as
soon as I apply them, and that will happen once I remove a bit the load
of work that I have on top of me :)

Of course, this is my personal opinion.

[1] features that requires several patch-rounds in order to discuss the
best solution, features that implies intrusive changes, etc.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
