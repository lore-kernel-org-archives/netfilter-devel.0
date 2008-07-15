From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: wrong result with conntrack_create, expect_create
Date: Tue, 15 Jul 2008 12:33:39 +0200
Message-ID: <487C7D03.30003@netfilter.org>
References: <6cb26d8b0807150129m30c71f89o4def08f1623d287d@mail.gmail.com> <487C7981.2030906@netfilter.org> <487C7AB2.3050800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: wang feng <feng.wangs@gmail.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38068 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754850AbYGOKd5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:33:57 -0400
In-Reply-To: <487C7AB2.3050800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> wang feng wrote:
>>> Hello,
>>> I have done some test based on the
>>> libnetfilter_conntrack-0.0.96,something is
>>> wrong with the samples under utils:
>>>
>>> conntrack_create:
>>>  TEST: create conntrack (0)(Success)
>>> it should create a conntrack with src:1.1.1.1, dst:2.2.2.2
>>> but: conntrack_get:
>>> ipv4     2 tcp      6 98 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0
>>> packets=0
>>> bytes=0 [UNREPLIED] src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=0
>>> bytes=0
>>> mark=0 use=2
>>>
>>> expect_create:
>>> TEST: add master conntrack (0)(Success)
>>> TEST: create expectation (-1)(Invalid argument)
>>
>> You probably forgot to insmod:
>>
>> * nf_conntrack_ipv4
>> * nf_conntrack_ftp, which is required to run the expect_create test.
>>
>> I'm going to add a note in the sources of the test now.
> 
> Ideally we would simply autoload the modules on create requests.
> That would also be a first step to fix the NAT dependencies.

I'll include that in my next patchset.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
