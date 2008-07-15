From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: wrong result with conntrack_create, expect_create
Date: Tue, 15 Jul 2008 12:18:41 +0200
Message-ID: <487C7981.2030906@netfilter.org>
References: <6cb26d8b0807150129m30c71f89o4def08f1623d287d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: wang feng <feng.wangs@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59591 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753654AbYGOKS5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:18:57 -0400
In-Reply-To: <6cb26d8b0807150129m30c71f89o4def08f1623d287d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

wang feng wrote:
> Hello,
> I have done some test based on the libnetfilter_conntrack-0.0.96,something is
> wrong with the samples under utils:
> 
> conntrack_create:
>  TEST: create conntrack (0)(Success)
> it should create a conntrack with src:1.1.1.1, dst:2.2.2.2
> but: conntrack_get:
> ipv4     2 tcp      6 98 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=0
> bytes=0 [UNREPLIED] src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=0 bytes=0
> mark=0 use=2
> 
> expect_create:
> TEST: add master conntrack (0)(Success)
> TEST: create expectation (-1)(Invalid argument)

You probably forgot to insmod:

* nf_conntrack_ipv4
* nf_conntrack_ftp, which is required to run the expect_create test.

I'm going to add a note in the sources of the test now.

> I have debugged, the parameters passed to the api are not wrong, something in
> nflink(nfnl_query) perhaps not works...
> 
> see also bug#548,someone can help me to debug to see what happen with
> it? thanks...

Please, confirm that this fixes your problem.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
