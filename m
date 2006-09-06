From: Patrick McHardy <kaber@trash.net>
Subject: Re: check_entry & module_refcount
Date: Wed, 06 Sep 2006 20:23:05 +0200
Message-ID: <44FF1209.2000302@trash.net>
References: <200609041617.39950.dim@openvz.org>
	<200609060124.k861OBle010614@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200609060124.k861OBle010614@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hello,
> 
> From: Dmitry Mishin <dim@openvz.org>
> Date: Mon, 4 Sep 2006 16:17:39 +0400
> 
>>If it is a bug, patch over net-2.6.19 is below.
> 
> 
> This is not bug but cleanup. try_get_module() is called anyway, so calling
> put_module() on error is logically good, I think.

Agreed. Dmitry, you can send a patch which changes this for ip6_tables
and arp_tables as well?
