From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Sun, 03 Jun 2007 20:46:56 +0900 (JST)
Message-ID: <200706031146.l53BkuqU000974@toshiba.co.jp>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: jengelh@linux01.gwdg.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
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


Hi,

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Sun, 3 Jun 2007 13:12:55 +0200 (MEST)

> +static int __init xt_connlimit_init(void)
> +{
> +	need_conntrack_ipv4();
> +	return xt_register_match(&xt_connlimit_reg);
> +}

You can use nf_ct_l3proto_try_module_get() instead of introducing
need_conntrack_ipv4(). Please refer xt_state.c and xt_conntrack.c as
example.

-- Yasuyuki Kozakai
