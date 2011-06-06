From: Konstantin Khorenko <khorenko@parallels.com>
Subject: ip6tables functionality test is wanted
Date: Mon, 06 Jun 2011 23:33:01 +0400
Message-ID: <4DED2B6D.1020008@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:20989 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab1FFTdH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:33:07 -0400
Received: from [192.168.10.2] (ppp91-77-227-53.pppoe.mtu-net.ru [91.77.227.53])
	(authenticated bits=0)
	by relay.sw.ru (8.13.4/8.13.4) with ESMTP id p56JZDuU014669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 6 Jun 2011 23:35:16 +0400 (MSD)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear All,

working on iptables IPv6 32bit compat kernel code implementation we need to somehow test it.
i've spent some time searching for a good ip6tables test, but have to admit that did not find any.

On the other hand i guess during the development new version of "iptables" could be tested on some regression test suites.

i'd very appreciate if someone can point me some test for ip6tables we can use.
(Checking the kernel part is not important in our case - we can simply compare the resulted chains/rules after the test execution with the list taken on a native 32bit node,
so the most important thing is a list of valid ip6tables commands.)

Thank you in advance.

--
Best regards,
Konstantin Khorenko
