From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] new ip6tables matches
Date: Mon, 03 Mar 2003 01:24:39 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303.012439.11634313.davem@redhat.com>
References: <20030227120554.GC22249@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030227120554.GC22249@sunbeam.de.gnumonks.org>
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
   Date: Thu, 27 Feb 2003 13:05:54 +0100
   
   Please apply (2.4.x and 2.5.x):

Bunch of problems, which I believe I resolved successfully:

1) Patch is buggy, Makefile changes references ipt_hl.c instead
   of ip6t_hl.c

2) Can't apply to 2.5.x, Config.in needs to be mangled into
   Kconfig format, also therefore we are missing Configure.help
   entries in 2.4.x version.

   I cobbled up some help into the Kconfig I created from your
   Config.in 2.4.x diff

Any kind of "Config.in" etc. changes should ring a bell in your
head that the patch does not translate directly into 2.5.x :-)
