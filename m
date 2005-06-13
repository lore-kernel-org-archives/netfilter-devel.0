From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [IPTABLES PATCH] chain name should not start with '!'
Date: Mon, 13 Jun 2005 09:50:18 +0900 (JST)
Message-ID: <200506130050.j5D0oJsU027172@toshiba.co.jp>
References: <200506030803.j5383iXf006561@toshiba.co.jp>
	<42AAFEF7.1030805@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42AAFEF7.1030805@trash.net>
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


From: Patrick McHardy <kaber@trash.net>
Date: Sat, 11 Jun 2005 17:10:47 +0200

> > This patch fixes the bug allows to create the chain with name "!".
>
> Is there a technical reason for this or is it just "cleanup"?

-F, -X, -L, -Z cannot take chain names which have prefix "!".

Of cause we can fix processing of their commands, but changing -N is
the easiest way and I think it's better to avoid to use confusing chain name.

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
