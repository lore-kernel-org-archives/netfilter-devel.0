From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Status of IPv6 conn-tracking in 2.4.x series ?
Date: Thu, 13 Nov 2003 22:03:21 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311131303.WAA28664@toshiba.co.jp>
References: <20031113010159.GD835@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: matti.aarnio@zmailer.org
In-Reply-To: <20031113010159.GD835@mea-ext.zmailer.org>
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

From: Matti Aarnio <matti.aarnio@zmailer.org>
Date: Thu, 13 Nov 2003 03:01:59 +0200

> Dear Netfilter-devel,
> 
> Could somebody tell to me, what is present status in IPv6
> connection-tracking filters of netfilter codes ?  Having
> browsed your CVS, there are some versions of such, and
> tantalizing glimpses of somebody doing development in
> some bitkeeper somewhere...

If you want to use ip6_conntrack ASAP, you can find the patch in archives
of this list(24 Sep. 2003).

Or in USAGI kernel, too. http://www.linux-ipv6.org/

BTW, this patch works only with Linux 2.6. If you want to use it with
Linux 2.4, some changes are needed. ex) replace synchronize_net() to
br_write_{un}lock_bh(), fix the codes related to nf_reinject() in
ip6_conntrack_reasm.c.

----------------------------------------
Yasuyuki KOZAKAI

Communication Platform Laboratory,
Corporate Research & Development Center,
Toshiba Corporation

yasuyuki.kozakai@toshiba.co.jp
----------------------------------------
