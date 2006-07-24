From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] proto_to_name duplication
Date: Mon, 24 Jul 2006 07:49:50 -0700
Message-ID: <20060724144950.GA8973@linuxace.com>
References: <20060721225612.GA3951@linuxace.com> <44C22C7C.2080909@trash.net>
	<200607240538.k6O5cYwP024759@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200607240538.k6O5cYwP024759@toshiba.co.jp>
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

On Mon, Jul 24, 2006 at 02:38:32PM +0900, Yasuyuki KOZAKAI wrote:
> This allows iptables to send the invalid entry to kernel when
> people do 'iptables -p icmp -m multiport --sports 10000 ...',
> for example. Of cause kernel can reject this, but iptables cannot
> output useful error message after that.
> 
> check_proto() should not allow protocols other than tcp, udp, sctp and
> dccp. That's why libip{,6}t_multiport have the other version of
> proto_to_name().
> 
> Please revert this or add check for protocol number.

Good catch.  Probably should just revert this one for simplicity.

Phil
