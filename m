From: Raivis Bucis <raivis@mt.lv>
Subject: Transparent web proxiing stops working in linux-2.4.22
Date: Tue, 2 Sep 2003 09:38:56 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200309020938.56412.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, cieciwa@alpha.zarz.agh.edu.pl
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Transparent web proxiing stops working in linux-2.4.22 because of the 
following patch:

@@ -1446,8 +1446,8 @@
 getorigdst(struct sock *sk, int optval, void *user, int *len)
 {
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple = { { sk->rcv_saddr, { sk->sport } },
-					    { sk->daddr, { sk->dport },
+	struct ip_conntrack_tuple tuple = { { sk->rcv_saddr, { .tcp = { sk->sport } 
} },
+					    { sk->daddr, { .tcp = { sk->dport } },
 					      IPPROTO_TCP } };
 
It comes from 
http://lists.netfilter.org/pipermail/netfilter-devel/2003-May/011460.html

It doesn't zero all of the tuple contents before assigning, and this way 3rd 
and 4th bytes of tuple.src.all contain garbage, and ip_conntrack_find_get is 
not able to find correct conntrack because of that.

So instead of fixing getorigdst for big endian architectures, it brakes even 
the little endian ones.

Raivis Bucis
