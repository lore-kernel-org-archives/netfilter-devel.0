From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Sun, 3 Jun 2007 14:35:46 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706031434530.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
	<200706031146.l53BkuaZ011945@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	linux-kernel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706031146.l53BkuaZ011945@toshiba.co.jp>
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

>From: Jan Engelhardt <jengelh@linux01.gwdg.de>
>Date: Sun, 3 Jun 2007 13:12:55 +0200 (MEST)
>
>> +static int __init xt_connlimit_init(void)
>> +{
>> +	need_conntrack_ipv4();
>> +	return xt_register_match(&xt_connlimit_reg);
>> +}
>
>You can use nf_ct_l3proto_try_module_get() instead of introducing
>need_conntrack_ipv4(). Please refer xt_state.c and xt_conntrack.c as
>example.

Thank you for this hint. I will add it and post updates versions
of the patch(es) when I am done with all.


Thanks,
	Jan
-- 
