From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH] 2.4/2.5 ip_conntrack bugfix for LOCAL_NAT and PPTP
Date: Mon, 31 Mar 2003 07:02:02 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331.070202.40092275.davem@redhat.com>
References: <20030330195113.GW7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030330195113.GW7718@sunbeam.de.gnumonks.org>
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
   Date: Sun, 30 Mar 2003 21:51:13 +0200

   Author: Paul Mielke <paulm@routefree.com>
   This patch fixes a bug introduced with the LOCAL_NAT support of linux
   kernels  >= 2.4.19, which caused a problem with locally-terminated
   connections and certain NAT application helpers (esp. PPTP).

Applied to both 2.4.x and 2.5.x, thank you.
