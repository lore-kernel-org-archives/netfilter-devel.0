From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 04/05]: nf_conntrack: add missing unlock in
 get_next_corpse()
Date: Mon, 30 Oct 2006 15:14:05 -0800 (PST)
Message-ID: <20061030.151405.85390415.davem@davemloft.net>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
	<20061030181859.32038.61354.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061030181859.32038.61354.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 30 Oct 2006 19:19:01 +0100 (MET)

> [NETFILTER]: nf_conntrack: add missing unlock in get_next_corpse()
> 
> Add missing unlock in get_next_corpse() in nf_conntrack. It was missed
> during the removal of listhelp.h . Also remove an unneeded use of
> nf_ct_tuplehash_to_ctrack() in the same function.
> 
> Should be applied before 2.6.19 is released.
> 
> Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
