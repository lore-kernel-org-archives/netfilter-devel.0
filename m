From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nfnetlink/ctnetlink from pom-ng r3884
Date: Wed, 20 Apr 2005 02:55:49 +0200
Message-ID: <4265A895.1070406@eurodev.net>
References: <20050419212858.039E.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010507090004060806000709"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050419212858.039E.LARK@linux.net.cn>
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

This is a multi-part message in MIME format.
--------------010507090004060806000709
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Wang Jian wrote:
> type: [NEW] src=192.168.0.27 dst=192.168.0.254 sport=22 dport=2846 src=192.168.0.254 dst=192.168.0.27 sport=2846 dport=22 status:8 timeout:432000 tcp 6 orig_packets=1 orig_bytes=0, reply_packets=268 reply_bytes=0 
> type: [UPDATE] src=192.168.0.27 dst=192.168.0.254 sport=22 dport=2846 src=192.168.0.254 dst=192.168.0.27 sport=2846 dport=22 status:10 timeout:432000 orig_packets=1 orig_bytes=0, reply_packets=268 reply_bytes=0 
> orig_packets=1 orig_bytes=0, reply_packets=268 reply_bytes=0 
> 
> See the second event message. account information is printed twice, that
> means the netlink message has duplicated account information.

no, status flags has changed. The seen_reply bit has been set.

> And
> 
> # ./conntrack -E conntrack
> ...
> type: [UPDATE] src=192.168.0.254 dst=192.168.0.27 sport=4347 dport=22 src=192.168.0.27 dst=192.168.0.254 sport=22 dport=4347 timeout:120 tcp 6 orig_packets=5 orig_bytes=0, reply_packets=270 reply_bytes=0 
> type: [DESTROY] src=192.168.0.254 dst=192.168.0.27 sport=4347 dport=22 src=192.168.0.27 dst=192.168.0.254 sport=22 dport=4347 orig_packets=5 orig_bytes=0, reply_packets=270 reply_bytes=0 
> Segmentation fault (core dumped)
> 
> core dumps again. This time the backtrace is

The patch attached fixes it.

--
Pablo

--------------010507090004060806000709
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: src/libct.c
===================================================================
--- src/libct.c	(revision 3881)
+++ src/libct.c	(working copy)
@@ -239,7 +239,7 @@
 			attr = NFA_NEXT(attr, attrlen);
 		}
 		min_len += nlh->nlmsg_len;
-		nlh = (struct nlmsghdr *) attr;
+		nlh = (struct nlmsghdr *) (nlh + nlh->nlmsg_len);
 		printf("\n");
 	}
 	DEBUGP("exit from handler\n");

--------------010507090004060806000709--
