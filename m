From: "Richard" <richard@o-matrix.org>
Subject: RE: [NEW TARGET] target for modifying conntrack timeout value
Date: Tue, 14 Dec 2004 15:16:23 -1000
Message-ID: <EINSTEIN2Mb1s7nlT2N00000521@einstein.systemmetrics.com>
References: <41BF8461.3030405@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Netfilter Development Mailinglist' <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Pablo Neira'" <pablo@eurodev.net>
In-Reply-To: <41BF8461.3030405@eurodev.net>
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

> Some comments:
> 
> a) I think that you should implement this thing as a match instead of a
> target. Have a look at ipt_limit. It isn't actually matching anything
> but, for example, you could use it together with nat targets. A match
> gives you more flexibility.
Not sure that I follow you. This target changes the conntrack expire timer.
For example, the default timeout for udp stream is 180 seconds. If I want to
make it 3600 for sip (udp 5060) traffic, I would do,
iptables -t mangle -A INPUT -p UDP --dport 5060 -j CTEXPIRE --ctexpire-set
3600
iptables -t mangle -A OUTPUT -p UDP --sport 5060 -j CTEXPIRE --ctexpire-set
3600


> b) About source code:
> 
> +       if (!is_confirmed(ct)) {
>            ^^^
> remove this `if' condition. ip_ct_refresh worries about about this for
> you and makes the thing more simple.
In order to increase or decrease the expire value, we need to get the
current expire value. If it is !is_confirmed, the ct->timeout value is the
real expire value. Otherwise, it is jiffies + expire value. Is there a
function to get this value without checking is_confirmed?


> c) In checkentry:
> 
> +       if (info->mode > IPT_CTEXPIRE_MAXMODE) {
> +               printk(KERN_WARNING "CTEXPIRE: invalid or unknown Mode
> %u\n",
> +                       info->mode);
> +               return 0;
> +       }
> + [...]
> +
> +       if (info->expires * HZ < info->expires) {
> +               /* if user specified value is too big, *HZ can overflow
> the counter
> +               */
> +               printk(KERN_WARNING "CTEXPIRE: expire value too big,
> will overflow counter: %ld\n", info->expires);
> +               return 0;
> +       }
> 
> You should do those checkings in user space. Those error must be handle
> in iptables, not in kernel.
It is already done in user space. It is probably redundant doing the same
thing here. I will drop it.

> A minor aesthetic comment, a line must fit 80 columns, split longer
> lines in two.
It will be changed.

Thanks for your comments. Looking forward to your next email.

Richard
