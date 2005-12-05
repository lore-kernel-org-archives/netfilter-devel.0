From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Mon, 05 Dec 2005 14:51:48 +0900 (JST)
Message-ID: <200512050551.jB55pnS6006429@toshiba.co.jp>
References: <200512041710.jB4HA40F021665@toshiba.co.jp>
	<4393390C.4080301@fliegl.de> <439349DE.3060706@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: deti@fliegl.de, netfilter-devel@lists.netfilter.org, pablo@eurodev.net,
	romary@nikoon.com, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <439349DE.3060706@trash.net>
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
Date: Sun, 04 Dec 2005 20:56:14 +0100

> Deti Fliegl wrote:
> > Latest test was done with linux-2.6.15-rc5 which already contains this 
> > patch.
> > 
> > And here comes your oops...

Thanks a lot, Deti! This BUG_ON() is what I expected.

> Found it (I hope) :)

Great! I'll be able to sleep well tonight.

-- Yasuyuki Kozakai
