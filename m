From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 09:27:34 +0100
Message-ID: <474E77F6.8030003@trash.net>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp> <474E640F.4010401@trash.net> <200711290801.lAT81sf6014235@toshiba.co.jp> <Pine.LNX.4.64.0711290908240.22052@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38109 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbXK2I1j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:27:39 -0500
In-Reply-To: <Pine.LNX.4.64.0711290908240.22052@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 29 2007 17:01, Yasuyuki KOZAKAI wrote:
>>> BTW, judging by your last batch of xtables patches you seem to have
>>> managed to import the netfilter SVN in git. I keep getting errors
>>> related to paths:
>>>
>>> $ git-svnimport -v -C nf.git http://svn.netfilter.org/netfilter
>>> Initialized empty Git repository in /tmp/nf.git/.git/
>>> 1: Unrecognized path: 
>>> /patch-o-matic-ng/trunk/pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_nat_pptp.h
>>> 1: Unrecognized path: /patch-o-matic-ng/trunk/pptp-conntrack-nat/help
>>> 1: Unrecognized path: 
>>> /patch-o-matic-ng/trunk/pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
>>>
>>> It seems it switches the first directory and "trunk". Did you use
>>> git-svnimport or just git-svn for importing?
>> Actually, I have not succeeded to manage them. I manually do 'svn update'
>> on master branch on local git tree and commits updates, and create new branch
>> on git tree for my development.
>>
> Also, there is no indication that a move was done (e.g. r7117) but instead
> a hand copy. I prefer using native svn, or switching to git entirely.


I want to switch entirely, but first I have to manage to import the
repository :)

