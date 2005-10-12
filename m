From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Wed, 12 Oct 2005 00:34:30 -0700 (PDT)
Message-ID: <20051012.003430.08271591.davem@davemloft.net>
References: <20051012062218.GA2712@frankengul.org>
	<20051011.233149.40160652.davem@davemloft.net>
	<434CB56D.7050508@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: seb@frankengul.org
In-Reply-To: <434CB56D.7050508@frankengul.org>
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

From: S=E9bastien Bernard <seb@frankengul.org>
Date: Wed, 12 Oct 2005 09:04:13 +0200

> unable to handle paging_request (some zeros...)140098000

This 0x140098000 is in the VMALLOC area, presumable this
is an unmapped out-of-range VMALLOC address.

> iptables_restor(2488): Oops [#1]
> TPC: <get_couters +0x68/0xe0>

I guess there is still some indexing problem in Harald's
patch, which is what causes the out-of-range vmalloc
access.
