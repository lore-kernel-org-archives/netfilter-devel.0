From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Unknown Attribute 5/conntrack -L
Date: Tue, 01 Nov 2005 04:02:07 +0900 (JST)
Message-ID: <200510311902.j9VJ28fq026612@toshiba.co.jp>
References: <Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>
	<43662D1E.4000308@eurodev.net>
	<Pine.LNX.4.62.0510311544350.31123@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Nov__1_04_02_07_2005_460)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: olenf@ans.pl
In-Reply-To: <Pine.LNX.4.62.0510311544350.31123@bizon.gios.gov.pl>
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

----Next_Part(Tue_Nov__1_04_02_07_2005_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

From: Krzysztof Oledzki <olenf@ans.pl>
Date: Mon, 31 Oct 2005 15:46:10 +0100 (CET)

> On Mon, 31 Oct 2005, Pablo Neira wrote:
> 
> > Krzysztof Oledzki wrote:
> >> On Mon, 31 Oct 2005, Pablo Neira wrote:
> >> <CUT>
> >> 
> >>>> PS: Would you find some time to look at 
> >>>> http://bugzilla.kernel.org/show_bug.cgi?id=5438
> >>> 
> >>> 
> >>> Can you still trigger that oops with the current working copy from SVN?
> >> 
> >> IMHO this is a kernel bug. And to be clear: there is no problem with new 
> >> version of userspace application/libraries.
> >> 
> >> The problem apperas only with _old_ library. There were a lot of API 
> >> changes and probably kernel does not properly validate user data 
> >> (boudaries?).

I'm not sure it's the reason of oops, but at least attached patch fixes
double free after netlink_unicast(). Krzysztof, could you try this ?


> > Since the old libnfnetlink_conntrack release, some changes have been 
> > introduced in kernel space. The corresponding changes to the userspace 
> > libraries were applied to keep both in sync. To be frank, I'd worry about 
> > fixing the current bugs, focus on the new libraries and do the first 1.0 
> > official release asap.
> 
> OK, this can wait. I'll remind about this problem after the first 
> 1.0 official release.

I don't think so. Deti reports similer oops on 2.6.14 which has been already
out, so this should be fixed asap.

Regards,

-- Yasuyuki Kozakai

----Next_Part(Tue_Nov__1_04_02_07_2005_460)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ct-netlink-double-free.patch"

[NETFILTER] fix double free after netlink_unicast() in ctnetlink

It's not necessary to free skb if netlink_unicast() failed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 1d9b24503bcaf3c5c809a05822bbbbaacc657781
tree af11ba2c560f1f642cc7ac3c8c8c8b883ef24b1e
parent 991ce06b3db463c6cdf8d5a0b0d70bf22c499fef
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 01 Nov 2005 03:37:24 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 01 Nov 2005 03:37:24 +0900

 net/ipv4/netfilter/ip_conntrack_netlink.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -815,7 +815,7 @@ ctnetlink_get_conntrack(struct sock *ctn
 				  IPCTNL_MSG_CT_NEW, 1, ct);
 	ip_conntrack_put(ct);
 	if (err <= 0)
-		goto out;
+		goto free;
 
 	err = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
 	if (err < 0)
@@ -824,9 +824,9 @@ ctnetlink_get_conntrack(struct sock *ctn
 	DEBUGP("leaving\n");
 	return 0;
 
+free:
+	kfree_skb(skb2);
 out:
-	if (skb2)
-		kfree_skb(skb2);
 	return -1;
 }
 
@@ -1322,21 +1322,16 @@ ctnetlink_get_expect(struct sock *ctnl, 
 				      nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      1, exp);
 	if (err <= 0)
-		goto out;
+		goto free;
 
 	ip_conntrack_expect_put(exp);
 
-	err = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
-	if (err < 0)
-		goto free;
-
-	return err;
+	return netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
 
+free:
+	kfree_skb(skb2);
 out:
 	ip_conntrack_expect_put(exp);
-free:
-	if (skb2)
-		kfree_skb(skb2);
 	return err;
 }
 

----Next_Part(Tue_Nov__1_04_02_07_2005_460)----
