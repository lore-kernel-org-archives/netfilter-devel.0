From: "Adelson O. Junior" <jroliv@gmail.com>
Subject: Re: NFNETLINK answers: No such file or directory
Date: Thu, 19 Jun 2008 15:32:08 -0300
Message-ID: <7b0a40830806191132o2ac8beao16b0526dff6cf976@mail.gmail.com>
References: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
	 <485A3E81.5070100@netfilter.org>
	 <7b0a40830806190650g6ccacd5br3bc3c9088c73dd2c@mail.gmail.com>
	 <485A6744.9060607@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:43969 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYFSScM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:32:12 -0400
Received: by wx-out-0506.google.com with SMTP id h29so259906wxd.4
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2008 11:32:09 -0700 (PDT)
In-Reply-To: <485A6744.9060607@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey Pablo, thanks.
Really, as you said, we use a very old version, but these versions was
approved with the app.
I tried to find any report of this problem in the netfilter's
bugzilla, without success.
We will test the most recent versions with our app, but I would just
to understand the bug, if really is a bug this problem, to know the
impact on the system.
I never used git before, but I will learn to try see the changes on
the releases.

[]'s

On Thu, Jun 19, 2008 at 11:03 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Adelson O. Junior wrote:
> > Hi, thanks for reply
> >
> > I'm using the versions:
> >
> > libnfnetlink-0.0.25-1
> > libnetfilter_conntrack-0.0.50-2
> > conntrack-1.0-0.1.beta2
> >
> > We have an application Java based that uses this tools, and uses these versions.
> > I need to know which of this packets is causing the problem, and which
> > version is fixing it, before a apply new versions on the Java App.
> > There are any place thats show the problems fixed in each version?
>
> Yes, you can look for the changes on Netfilter's git [1] and the
> website. However, those versions are from the caveman era and the amount
> of changes is cumbersome. I strongly recommend you to upgrade. Make sure
> you use a Linux kernel version >= 2.6.18.
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers



--
[]'s
