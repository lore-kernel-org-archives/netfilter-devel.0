From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] 2.4.x ipt_REJECT bugfix for TCP RST packets + asymm.
 routing
Date: Mon, 31 Mar 2003 06:58:42 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331.065842.82313601.davem@redhat.com>
References: <20030330194402.GU7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030330194402.GU7718@sunbeam.de.gnumonks.org>
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
   Date: Sun, 30 Mar 2003 21:44:02 +0200

   This fixes a bug (oops) in the generation of TCP RST packets in the
   ipt_REJECT target in the case of asymmetric routing, where the hardware
   header length of the outgoing interface is bigger than the hardware
   header length of the incoming interface.

Both 2.4.x and 2.5.x patches applied, thank you.
