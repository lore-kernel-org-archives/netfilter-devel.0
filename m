From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] 2.4.x new amanda conntrack + NAT support
Date: Mon, 31 Mar 2003 07:09:10 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331.070910.52982765.davem@redhat.com>
References: <20030330200750.GZ7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030330200750.GZ7718@sunbeam.de.gnumonks.org>
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
   Date: Sun, 30 Mar 2003 22:07:50 +0200

   Author: Brian J. Murrell <netfilter@interlinx.bc.ca>
   The attached patch for 2.4.x adds new support for connection tracking and
   NAT of the amanda backup protocol.  The patch is incremental to all
   other 2.4.20 updates (including the tftp patch) I've sent you so far.

Applied to 2.4.x, thank you.

Harald, what is the state of ipt_recent?  Will I see it soon?
