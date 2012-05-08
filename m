From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables ulog-cprange
Date: Wed, 9 May 2012 00:36:11 +0200
Message-ID: <20120508223611.GA18723@1984>
References: <4FA98904.3070008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Gaurav Sinha <vgsinha@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40579 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368Ab2EHWgO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 18:36:14 -0400
Content-Disposition: inline
In-Reply-To: <4FA98904.3070008@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Gaurav,

On Tue, May 08, 2012 at 01:58:44PM -0700, Gaurav Sinha wrote:
> Hi All,
> 
> I am getting this error which points out the ulog-cprange that I am
> using is incorrect. It
> should be a value in between 1-50. The man page says 0 is allowed
> too, i.e. any number of
> bytes. But, I cannot configure zero as well.
> 
> Is zero no longer supported? Probably the man page is not updated
> with this information.
> 
> iptables v1.4.12.2: ULOG: bad value for option "--ulog-cprange", or out of
> range (1-50).
> 
> Try `iptables -h' or 'iptables --help' for more information.
> Error: [iptables -t raw -I MY_PREROUTING_HOOK 1 -i eth0 -j ULOG
> --ulog-nlgroup 2 --ulog-cprange 64 --ulog-qthreshold 10] failed - 512

A bug was accidentally introduced in:

1f2474a libipt_ULOG: use guided option parser

I have applied the following patch to resolve this issue:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=6111382a6c27e73c1cef1777c1253be0453a9dbb;hp=8db1044ba608a78035bbf89007aab6b6d8ff6f68

Thanks for reporting the problem.
