From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] proto_to_name duplication
Date: Mon, 24 Jul 2006 14:38:32 +0900 (JST)
Message-ID: <200607240538.k6O5cYwP024759@toshiba.co.jp>
References: <20060721225612.GA3951@linuxace.com> <44C22C7C.2080909@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kernel@linuxace.com, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <44C22C7C.2080909@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sat, 22 Jul 2006 15:47:40 +0200

> Phil Oester wrote:
> > Update multiport match to use the iptables version of proto_to_name
> > instead of reinventing the wheel.
> 
> Also applied, thanks Phil.

This allows iptables to send the invalid entry to kernel when
people do 'iptables -p icmp -m multiport --sports 10000 ...',
for example. Of cause kernel can reject this, but iptables cannot
output useful error message after that.

check_proto() should not allow protocols other than tcp, udp, sctp and
dccp. That's why libip{,6}t_multiport have the other version of
proto_to_name().

Please revert this or add check for protocol number.

Regards,

-- Yasuyuki Kozakai
