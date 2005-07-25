From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT changes DST address of the packet
Date: Tue, 26 Jul 2005 01:59:33 +0200
Message-ID: <42E57CE5.4070202@trash.net>
References: <20050725045409.35744.qmail@web60823.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090804040601010804020201"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Venkata Narayana <mesg2nari@yahoo.com>
In-Reply-To: <20050725045409.35744.qmail@web60823.mail.yahoo.com>
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
--------------090804040601010804020201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Venkata Narayana wrote:
> Hi,
> 
> Thanks,
> I am able to get the original dst address when I am
> using tcp connection.
> How can I get with UDP???

Does this patch help? It should make SO_ORIGINAL_DST usable
with UDP as well.

--------------090804040601010804020201
Content-Type: text/x-patch;
 name="SO_ORIGINAL_DST-udp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="SO_ORIGINAL_DST-udp.diff"

[NETFILTER]: Make SO_ORIGINAL_DST usable for UDP

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f65e246c7c05b208494de20f38973393d6b30155
tree 6437e0491ba99ec326c59ca0ac65300c2f01a804
parent eb82d02518ac3a400663163995097749d91c7c4c
author Patrick McHardy <kaber@trash.net> Tue, 26 Jul 2005 01:58:27 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jul 2005 01:58:27 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1310,9 +1310,8 @@ getorigdst(struct sock *sk, int optval, 
 	tuple.dst.u.tcp.port = inet->dport;
 	tuple.dst.protonum = IPPROTO_TCP;
 
-	/* We only do TCP at the moment: is there a better way? */
-	if (strcmp(sk->sk_prot->name, "TCP")) {
-		DEBUGP("SO_ORIGINAL_DST: Not a TCP socket\n");
+	if (sk->sk_protocol != IPPROTO_TCP && sk->sk_protocol != IPPROTO_UDP) {
+		DEBUGP("SO_ORIGINAL_DST: Not a TCP/UDP socket\n");
 		return -ENOPROTOOPT;
 	}
 

--------------090804040601010804020201--
