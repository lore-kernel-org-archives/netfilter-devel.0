From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ip6tables functionality test is wanted
Date: Tue, 07 Jun 2011 01:36:41 +0200
Message-ID: <4DED6489.4050205@netfilter.org>
References: <4DED2B6D.1020008@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Konstantin Khorenko <khorenko@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51582 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab1FFXgv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:36:51 -0400
In-Reply-To: <4DED2B6D.1020008@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/06/11 21:33, Konstantin Khorenko wrote:
> Dear All,
> 
> working on iptables IPv6 32bit compat kernel code implementation we need
> to somehow test it.
> i've spent some time searching for a good ip6tables test, but have to
> admit that did not find any.
> 
> On the other hand i guess during the development new version of
> "iptables" could be tested on some regression test suites.

These regression tests are missing, we should have some indeed.

Rusty already considered this in nfsim, but that project was not any
longer supported (getting part of the kernel compile to compile in
userspace with every version is a daunting task).

> i'd very appreciate if someone can point me some test for ip6tables we
> can use.
> (Checking the kernel part is not important in our case - we can simply
> compare the resulted chains/rules after the test execution with the list
> taken on a native 32bit node,
> so the most important thing is a list of valid ip6tables commands.)

Sorry, we don't have them at the moment.
