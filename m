From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] IPv4 NAT ported to nf_conntrack
Date: Tue, 31 Oct 2006 17:43:59 +0900 (JST)
Message-ID: <200610310844.k9V8i1WL028919@toshiba.co.jp>
References: <Pine.LNX.4.64.0610301323560.6150@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.64.0610301323560.6150@blackhole.kfki.hu>
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


From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Mon, 30 Oct 2006 13:25:37 +0100 (CET)

> Hi,
> 
> Attached is a patch which implements IPv4 NAT over nf_conntrack by
> straightforward porting of the original NAT code.

Wow great. I'll review that this weekend.

> As you will notice, in order to avoid circular dependency a boolean choice 
> between NF_CONNTRACK and IP_CONNTRACK is added to net/netfilter/Kconfig. 
> Ugly it is, but unfortunately the kconfig language is not rich enough and 
> an additional option is required to choose between modular/non-modular.

I've not read the patch yet, but I don't feel so ugly. A config to choose
NF_CONNTRACK or IP_CONNTRACK represents current our intension
straightforward.

BTW, Harald has works/ideas on this area IIRC. But I cannot find such codes
in his git tree.

-- Yasuyuki Kozakai
