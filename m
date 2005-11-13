From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/4] fix leak of fragment queue at unloading
 nf_conntrack_ipv6
Date: Mon, 14 Nov 2005 00:15:04 +0900 (JST)
Message-ID: <200511131515.jADFF48D018475@toshiba.co.jp>
References: <200511131238.jADCcbHR017662@toshiba.co.jp>
	<20051113125627.GM17476@sunbeam.de.gnumonks.org>
	<20051113130334.GN17476@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Nov_14_00_15_04_2005_559)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051113130334.GN17476@sunbeam.de.gnumonks.org>
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

----Next_Part(Mon_Nov_14_00_15_04_2005_559)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Harald Welte <laforge@netfilter.org>
Date: Sun, 13 Nov 2005 14:03:34 +0100

> On Sun, Nov 13, 2005 at 01:56:27PM +0100, Harald Welte wrote:
> > > Sorry for short explanation. This function may be called when memory usage
> > > exceeds threshold. And I just want to be noticed existence of bug
> > > in memory tracking and avoid NULL pointer access.
> > 
> > ok, in this case I think the error message should be more verbose.
> > 
> > > > Please comment.
> > > 
> > > Is it overly cautions to avoid NULL pointer access in this case ?
> > 
> > I'd have to study the code in more detail.  It depends on the question:
> > Under which circumstances can we have a NULL pointer?
> 
> After looking at the code, this function is only called from
> 1) module unload time
> 
> Here it is clear, that there are valid cases where we would have a NULL
> pointer (empty fraq queue).  Let's assume we've never even processed a
> single fragment [or even not a single ipv6 packet], e.g.

That's right.

> So in this case, it is a bug to print a KERN_ERR message.

OK.

> 2) when the amount of memory used by the defrag code is higher than the
>    threshold
> 
> In this case, there's actually a bug in the memory usage accounting
> code.  Do you suspect any such errors at the moment?

No, in the current ;) But nf_conntrack_reasm.c is newer than other part and
I can not deny possibility.

>                                                      I think this is a
> candidate for an ASSERT, or maybe even better a BUG_ON().  
> 
> We're talking about a condition that should never happen, and if it
> does, we want to make sure to have users report it and fix it fast.  If
> the kernel oopses, that condition is fulfilled ;)

Yes.

> So unless I'm missing some point (I'm not as familiar with the code as
> you), I'd suggest that you resubmit the patch with a BUG_ON(tmp == NULL)
> statement.

I totally agree. I attached new one.

Regards,

-- Yasuyuki Kozakai

----Next_Part(Mon_Nov_14_00_15_04_2005_559)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfct-reasm-leak-resubmit.patch"

[NETFILTER] fix leak of fragment queue at unloading nf_conntrack_ipv6

This makes nf_conntrack_ipv6 free all IPv6 fragment queues at unloading.
This also check NULL pointer access due to bug of memory accounting.
Thanks to Harald Welte for suggestion.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 753e55677dcce0ce44db7faab2dd175e185dd28d
tree f6ca90f3d756cd0ea827248be93de8b49f666ab2
parent 56fef247fc7259d0e554517c8c05d0e9c7b4619b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 22:47:32 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 13 Nov 2005 22:47:32 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 2d0c49e..3e31903 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -269,6 +269,7 @@ static void nf_ct_frag6_evictor(void)
 			return;
 		}
 		tmp = nf_ct_frag6_lru_list.next;
+		BUG_ON(tmp == NULL);
 		fq = list_entry(tmp, struct nf_ct_frag6_queue, lru_list);
 		atomic_inc(&fq->refcnt);
 		read_unlock(&nf_ct_frag6_lock);
@@ -878,5 +879,6 @@ int nf_ct_frag6_init(void)
 void nf_ct_frag6_cleanup(void)
 {
 	del_timer(&nf_ct_frag6_secret_timer);
+	nf_ct_frag6_low_thresh = 0;
 	nf_ct_frag6_evictor();
 }

----Next_Part(Mon_Nov_14_00_15_04_2005_559)----
