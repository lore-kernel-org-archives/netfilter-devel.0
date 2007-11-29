From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 08:02:39 +0100
Message-ID: <474E640F.4010401@trash.net>
References: <474C4B67.3000200@trash.net> <200711290249.lAT2nkEr004081@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36445 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbXK2HCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:02:42 -0500
In-Reply-To: <200711290249.lAT2nkEr004081@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 27 Nov 2007 17:52:55 +0100
> 
>> I have a large number of pending patches for iptables for new
>> matches and targets. I'm not going apply patches for new things
>> unless they are at least in a -rc kernel, so we have a chance to
>> fix mistakes. So my question is whether we're ready to release
>> the current iptables -rc anytime soon (before/when 2.6.24 is
>> released) or whether we're more likely going to need until 2.6.25,
>> in which case I would apply them now.
>>
>> Any opinions?
> 
> Please wait a few hours at least to release iptables. Just after sending
> this mail, I'll moves some libipt_*.man to libxt_*.man and remove
> libip6t_state.c which I forgot to remove.


Don't worry, I think releasing in time for 2.6.24 would be enough.

BTW, judging by your last batch of xtables patches you seem to have
managed to import the netfilter SVN in git. I keep getting errors
related to paths:

$ git-svnimport -v -C nf.git http://svn.netfilter.org/netfilter
Initialized empty Git repository in /tmp/nf.git/.git/
1: Unrecognized path: 
/patch-o-matic-ng/trunk/pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_nat_pptp.h
1: Unrecognized path: /patch-o-matic-ng/trunk/pptp-conntrack-nat/help
1: Unrecognized path: 
/patch-o-matic-ng/trunk/pptp-conntrack-nat/linux/include/linux/netfilter_ipv4/ip_conntrack_pptp.h

It seems it switches the first directory and "trunk". Did you use
git-svnimport or just git-svn for importing?

