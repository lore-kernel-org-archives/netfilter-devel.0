From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] trivial but important iptables ipt_conntrack fix
Date: Sat, 03 May 2003 04:06:00 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030503.040600.52165591.davem@redhat.com>
References: <20030503120350.GT26924@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: marcelo@conectiva.com.br, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030503120350.GT26924@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Harald Welte <laforge@netfilter.org>
   Date: Sat, 3 May 2003 14:03:50 +0200

   I'm sending you this fairly trivial fix for ipt_conntrack, that should
   definitely go in before 2.4.21 is released.
   
Marcelo, I also have a set of remote networking exploit fixes for you.

So I'll add this change from Harald to my tree and send you all the
fixes together in the next day or two.

Thanks.
