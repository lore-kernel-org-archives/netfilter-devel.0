From: AllKind <AllKind@fastest.cc>
Subject: Re: [ANNOUNCE] ipset 6.21 released
Date: Wed, 05 Mar 2014 08:04:49 +0100
Message-ID: <5316CC91.2080704@fastest.cc>
References: <alpine.DEB.2.10.1403042207250.17838@blackhole.kfki.hu>
Reply-To: AllKind@fastest.cc
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41842 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbaCEHDG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:03:06 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id F1A8120B4B
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2014 02:03:05 -0500 (EST)
In-Reply-To: <alpine.DEB.2.10.1403042207250.17838@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.03.2014 22:12, Jozsef Kadlecsik wrote:
> Hi,
>
> I'm happy to announce ipset 6.21, which, besides bugfixes and corrections,
> includes the new set type hash:ip,mark from Vytas Dauksa and the forceadd
> option from Josh Hunt. See the updated manpage about these new features.
[...]

Hello,

unfortunately the utils were not updated with this release.

You can download the newest version of ipset_bash_completion including 
markmask and forceadd support from here:

https://sourceforge.net/projects/ipset-bashcompl/files/latest/download?source=navbar


Also a newer and more powerful version of ipset_list is available here:

https://sourceforge.net/projects/ipset-list/files/latest/download


Something that also might be useful to you is the current development 
version of iptables-bash_completion, which includes the features that 
are currently only available via the netfilter git repository:

https://sourceforge.net/p/ipt-bashcompl/code/ci/dev/tree/

Best regards

AllKind

