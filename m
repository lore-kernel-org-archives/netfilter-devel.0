From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: check_entry & module_refcount
Date: Wed, 06 Sep 2006 10:24:10 +0900 (JST)
Message-ID: <200609060124.k861OBle010614@toshiba.co.jp>
References: <200609041617.39950.dim@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dim@openvz.org
In-Reply-To: <200609041617.39950.dim@openvz.org>
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


Hello,

From: Dmitry Mishin <dim@openvz.org>
Date: Mon, 4 Sep 2006 16:17:39 +0400

> Hello, all!
> 
> Does anybody know why there is no module_put() on the error way after failed 
> standard_check() call in the check_entry() function? Previous xt_find_target()
> calls try_module_get() for all targets, without special checks for
> standard_target.

standard target is build in ip_tables.ko which has check_entry(), and
check_entry() cannot fail to get the module.

Then we doesn't set standard_target.me and try_module_{get,put}() do
nothing as result.

I think, the author thought that there is no necessary to call module_put()
there.

> If it is a bug, patch over net-2.6.19 is below.

This is not bug but cleanup. try_get_module() is called anyway, so calling
put_module() on error is logically good, I think.

BTW, This can apply to ip6_tables and arp_tables, too.

-- Yasuyuki Kozakai
