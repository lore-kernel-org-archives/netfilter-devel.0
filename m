From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: compile error ip6t_REJECT.c and 2.4.27-rc5
Date: Sun, 08 Aug 2004 08:05:24 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408072305.IAA04601@toshiba.co.jp>
References: <761227.1091907394234.JavaMail.Administrator@pumbaa>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laforge@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: inet6@mail.be
In-Reply-To: <761227.1091907394234.JavaMail.Administrator@pumbaa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Robby <inet6@mail.be>
Date: Sat, 7 Aug 2004 21:36:34 +0200 (CEST)

> I'm getting an error as you can see below, there was also something with ULOG that errored,
> but since I didn't need that I went back in menuconfig and disabled it.
> This is with the patch-o-matic-ng CVS of 07/08/2004 at 13:14 CEST.
> It used to compile before (back with 2.4.25-rc3 and I still have it running).
> The machine is a RH7.3 box.

Oh, this is for 2.6 kernel. You can get reject target for 2.4 kernel
from http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/*checkout*/patch-o-matic-ng/REJECT/linux/net/ipv6/netfilter/ip6t_REJECT.c?rev=1.1

Harald, why don't you rescue version 1.1 from CVS tree for 2.4 kernel ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
