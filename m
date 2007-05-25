From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Fri, 25 May 2007 09:44:03 +0900 (JST)
Message-ID: <200705250044.l4P0i3f8007580@toshiba.co.jp>
References: <465528CB.4020108@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: philipc@snapgear.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465528CB.4020108@snapgear.com>
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


Hi, Philip,

From: Philip Craig <philipc@snapgear.com>
Date: Thu, 24 May 2007 15:55:23 +1000

> Optimise iptables for rules that specify 0 or 1 interface matches,
> which is the more common case (at least for my rulesets).


>  	/* Look for ifname matches; this should unroll nicely. */
> -	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
> -		ret |= (((const unsigned long *)indev)[i]
> -			^ ((const unsigned long *)ipinfo->iniface)[i])
> -			& ((const unsigned long *)ipinfo->iniface_mask)[i];
> -	}
> +	if (ipinfo->flags & IPT_F_VIA_IN) {
> +		for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
> +			ret |= (((const unsigned long *)indev)[i]
> +				^ ((const unsigned long *)ipinfo->iniface)[i])
> +				& ((const unsigned long *)ipinfo->iniface_mask)[i];
> +		}

This breaks binary compatibility. The current userspace programs do not set
this bit. And ip_checkentry() in all kernel before you change will reject
unknown flags from new userspace programs.

Actually, we cannot add a new flag to 'struct ipt_ip'. It does not have
revision field. Unfortunately it has no field such as name[] in
'struct xt_entry_match' to steal one octet for revision.

I expect that this optimization will be done when we introduce netlink
interface.

-- Yasuyuki Kozakai
