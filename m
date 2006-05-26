From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] nf_conntrack: optimize hash calculation of tuple
Date: Fri, 26 May 2006 23:17:12 +0900 (JST)
Message-ID: <20060526.231712.10715846.yoshfuji@linux-ipv6.org>
References: <447703F2.90401@trash.net>
	<20060526.224556.19965528.yoshfuji@linux-ipv6.org>
	<447707EB.7000401@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <447707EB.7000401@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

In article <447707EB.7000401@trash.net> (at Fri, 26 May 2006 15:51:39 +0200), Patrick McHardy <kaber@trash.net> says:

> Assuming you're talking the modula operation: gcc can't do that,
> a modula operation can only be represented by a shift for a small
> subset of the possible values. ...

Sorry, I misunderstood here.

--yoshfuji
