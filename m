From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] fix NAT ICMP reply translation of inner packet
Date: Mon, 03 Mar 2003 01:06:44 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303.010644.48462574.davem@redhat.com>
References: <20030226184937.GB15997@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030226184937.GB15997@sunbeam.de.gnumonks.org>
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
   Date: Wed, 26 Feb 2003 19:49:37 +0100

   Attached patch solves a couple of problems with the translation of the
   inner (encapsulated) IP packet in ICMP reply packets.

Applied, thanks.
