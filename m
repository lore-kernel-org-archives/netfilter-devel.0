From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack & valgrind
Date: Thu, 10 Jan 2008 13:39:08 +0100
Message-ID: <478611EC.1050205@netfilter.org>
References: <d95317090801080112v662f7fcdk36b582d14557896d@mail.gmail.com> <d95317090801091757s5ba5bcbfnf066f011e3488761@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Gilad Benjamini <gilad.benjamini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42631 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753952AbYAJMhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:37:32 -0500
In-Reply-To: <d95317090801091757s5ba5bcbfnf066f011e3488761@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gilad Benjamini wrote:
> Is conntrack supposed to be "valgrind clean" ?
> I ran a few times "valgrind  --tool=memcheck --show-reachable=yes conntrack -L"
> and I always get different "Invalid read of size " messages.

# valgrind --tool=memcheck --show-reachable=yes conntrack -L
==15883== Memcheck, a memory error detector.
==15883== [...]
==15883==
tcp      6 [...]
==15883==
==15883== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 19 from 1)
==15883== malloc/free: in use at exit: 18 bytes in 1 blocks.
==15883== malloc/free: 19 allocs, 18 frees, 3,966 bytes allocated.
==15883== For counts of detected errors, rerun with: -v
==15883== searching for pointers to 1 not-freed blocks.
==15883== checked 100,072 bytes.
==15883==
==15883== LEAK SUMMARY:
==15883==    definitely lost: 0 bytes in 0 blocks.
==15883==      possibly lost: 0 bytes in 0 blocks.
==15883==    still reachable: 18 bytes in 1 blocks.
==15883==         suppressed: 0 bytes in 0 blocks.
==15883== Rerun with --leak-check=full to see details of leaked memory.

I can't reproduce the problem with current libraries and conntrack-tools 
SVN snapshots. Which version are you using?

--
Los honestos son inadaptados sociales -- Les Luthiers
