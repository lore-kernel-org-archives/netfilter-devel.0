From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ip6tables functionality test is wanted
Date: Tue, 7 Jun 2011 11:01:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106071059120.25037@frira.zrqbmnf.qr>
References: <4DED2B6D.1020008@parallels.com> <4DED6489.4050205@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Konstantin Khorenko <khorenko@parallels.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:52173 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1FGJBG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:01:06 -0400
In-Reply-To: <4DED6489.4050205@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-07 01:36, Pablo Neira Ayuso wrote:

>On 06/06/11 21:33, Konstantin Khorenko wrote:
>> Dear All,
>> 
>> working on iptables IPv6 32bit compat kernel code implementation we need
>> to somehow test it.
>> i've spent some time searching for a good ip6tables test, but have to
>> admit that did not find any.
>> 
>> On the other hand i guess during the development new version of
>> "iptables" could be tested on some regression test suites.
>
>These regression tests are missing, we should have some indeed.
>
>Rusty already considered this in nfsim, but that project was not any
>longer supported (getting part of the kernel compile to compile in
>userspace with every version is a daunting task).
>
>> i'd very appreciate if someone can point me some test for ip6tables we
>> can use.
>> (Checking the kernel part is not important in our case - we can simply
>> compare the resulted chains/rules after the test execution with the list
>> taken on a native 32bit node,
>> so the most important thing is a list of valid ip6tables commands.)
>
>Sorry, we don't have them at the moment.

I have rule test files that were helpful during the Guided Option Parser 
implementation. I shall submit.

About compat, it is as simple as running an ELF32 executable of iptables 
to trigger its use.
