From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] 2.4.x iptables iptable_mangle LOCAL_IN bugfix
Date: Mon, 31 Mar 2003 06:55:15 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331.065515.118800884.davem@redhat.com>
References: <20030330193641.GS7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030330193641.GS7718@sunbeam.de.gnumonks.org>
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
   Date: Sun, 30 Mar 2003 21:36:41 +0200
   
   The patch below fixes a bug when the MARK target is used in the INPUT
   chain of the mangle table.
   
   This one is for 2.4.x, expect the 2.5.x fix in my next email.

Both 2.4.x and 2.5.x patches applied, thank you.
