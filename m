From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 1/2] cleanup of unregistering ftp helper
 in init()
Date: Mon, 29 Aug 2005 21:40:38 +0900 (JST)
Message-ID: <200508291240.j7TCed74000090@toshiba.co.jp>
References: <200508161011.j7GABcK2028434@toshiba.co.jp>
	<20050826110202.GQ4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050826110202.GQ4226@rama.de.gnumonks.org>
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


From: Harald Welte <laforge@netfilter.org>
Date: Fri, 26 Aug 2005 13:02:02 +0200

> Thanks, I've applied it to my tree.  You forgot to remove the "__exit"
> qualifier from the "fini()" function, it is now called from the __init
> marked init() function.  I've fixed this up, too.

Thanks a lot!

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
