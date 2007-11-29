From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 17:01:53 +0900 (JST)
Message-ID: <200711290801.lAT81sf6014235@toshiba.co.jp>
References: <474C4B67.3000200@trash.net>
	<200711290249.lAT2nkEr004081@toshiba.co.jp>
	<474E640F.4010401@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:50269 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbXK2ICB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:02:01 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id lAT81xiT005160
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 17:01:59 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id lAT81wMe012660
	for netfilter-devel@vger.kernel.org; Thu, 29 Nov 2007 17:01:58 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id lAT81wHS021438
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 17:01:58 +0900 (JST)
In-Reply-To: <474E640F.4010401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>

> Don't worry, I think releasing in time for 2.6.24 would be enough.

Thanks.

> BTW, judging by your last batch of xtables patches you seem to have
> managed to import the netfilter SVN in git. I keep getting errors
> related to paths:
> 
> $ git-svnimport -v -C nf.git http://svn.netfilter.org/netfilter
> Initialized empty Git repository in /tmp/nf.git/.git/
> 1: Unrecognized path: 
> /patch-o-matic-ng/trunk/pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_nat_pptp.h
> 1: Unrecognized path: /patch-o-matic-ng/trunk/pptp-conntrack-nat/help
> 1: Unrecognized path: 
> /patch-o-matic-ng/trunk/pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
> 
> It seems it switches the first directory and "trunk". Did you use
> git-svnimport or just git-svn for importing?

Actually, I have not succeeded to manage them. I manually do 'svn update'
on master branch on local git tree and commits updates, and create new branch
on git tree for my development.

-- Yasuyuki Kozakai
