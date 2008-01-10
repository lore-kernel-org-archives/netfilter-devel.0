From: "Gilad Benjamini" <gilad.benjamini@gmail.com>
Subject: Re: conntrack & valgrind
Date: Thu, 10 Jan 2008 12:21:15 -0800
Message-ID: <d95317090801101221w5ac29c19i2e6e9d493dfa1114@mail.gmail.com>
References: <d95317090801080112v662f7fcdk36b582d14557896d@mail.gmail.com>
	 <d95317090801091757s5ba5bcbfnf066f011e3488761@mail.gmail.com>
	 <478611EC.1050205@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:42355 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYAJUVQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:21:16 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1292119wah.23
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Jan 2008 12:21:15 -0800 (PST)
In-Reply-To: <478611EC.1050205@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am actually not sure what version combination I initially had. Some
mix-n-match.
I tried this on my Ubuntu, with the latest binary packages from
apt-get, and got the same errors.
I then tried downloading latest release (having some local problem
with snapshots)
conntrack-tools-0.9.5.tar.bz2
libnetfilter_conntrack-0.0.82.tar.bz2
libnfnetlink-0.0.30.tar.bz2
... and conntrack failed to compile ;-(

At this point I gave up. I'll wait for the next releases and try again

2008/1/10, Pablo Neira Ayuso <pablo@netfilter.org>:
> Gilad Benjamini wrote:
> > Is conntrack supposed to be "valgrind clean" ?
> > I ran a few times "valgrind  --tool=memcheck --show-reachable=yes conntrack -L"
> > and I always get different "Invalid read of size " messages.
>
> # valgrind --tool=memcheck --show-reachable=yes conntrack -L
> ==15883== Memcheck, a memory error detector.
> ==15883== [...]
> ==15883==
> tcp      6 [...]
> ==15883==
> ==15883== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 19 from 1)
> ==15883== malloc/free: in use at exit: 18 bytes in 1 blocks.
> ==15883== malloc/free: 19 allocs, 18 frees, 3,966 bytes allocated.
> ==15883== For counts of detected errors, rerun with: -v
> ==15883== searching for pointers to 1 not-freed blocks.
> ==15883== checked 100,072 bytes.
> ==15883==
> ==15883== LEAK SUMMARY:
> ==15883==    definitely lost: 0 bytes in 0 blocks.
> ==15883==      possibly lost: 0 bytes in 0 blocks.
> ==15883==    still reachable: 18 bytes in 1 blocks.
> ==15883==         suppressed: 0 bytes in 0 blocks.
> ==15883== Rerun with --leak-check=full to see details of leaked memory.
>
> I can't reproduce the problem with current libraries and conntrack-tools
> SVN snapshots. Which version are you using?
>
> --
> Los honestos son inadaptados sociales -- Les Luthiers
>
