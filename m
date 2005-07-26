From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT changes DST address of the packet
Date: Tue, 26 Jul 2005 02:20:36 +0200
Message-ID: <42E581D4.10402@trash.net>
References: <20050725045409.35744.qmail@web60823.mail.yahoo.com>
	<42E57CE5.4070202@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010305020907040306000307"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Venkata Narayana <mesg2nari@yahoo.com>
In-Reply-To: <42E57CE5.4070202@trash.net>
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
--------------010305020907040306000307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Venkata Narayana wrote:
> 
>> I am able to get the original dst address when I am
>> using tcp connection.
>> How can I get with UDP???
> 
> Does this patch help? It should make SO_ORIGINAL_DST usable
> with UDP as well.
> 
> diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c
> @@ -1310,9 +1310,8 @@ getorigdst(struct sock *sk, int optval, 
>  	tuple.dst.u.tcp.port = inet->dport;
>  	tuple.dst.protonum = IPPROTO_TCP;

Please try this patch instead, I missed the above line.

--------------010305020907040306000307
Content-Type: text/x-patch;
 name="SO_ORIGINAL_DST-udp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="SO_ORIGINAL_DST-udp.diff"

[NETFILTER]: Make SO_ORIGINAL_DST usable for UDP

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 59740eead041f1e9c22555a5107bf9ca98a780da
tree a4d80f970e9fa526bff6c173cfe6d5a0610279a4
parent eb82d02518ac3a400663163995097749d91c7c4c
author Patrick McHardy <kaber@trash.net> Tue, 26 Jul 2005 02:19:09 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jul 2005 02:19:09 +0200

 net/ipv4/netfilter/ip_conntrack_core.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1308,11 +1308,10 @@ getorigdst(struct sock *sk, int optval, 
 	tuple.src.u.tcp.port = inet->sport;
 	tuple.dst.ip = inet->daddr;
 	tuple.dst.u.tcp.port = inet->dport;
-	tuple.dst.protonum = IPPROTO_TCP;
+	tuple.dst.protonum = sk->sk_protocol;
 
-	/* We only do TCP at the moment: is there a better way? */
-	if (strcmp(sk->sk_prot->name, "TCP")) {
-		DEBUGP("SO_ORIGINAL_DST: Not a TCP socket\n");
+	if (sk->sk_protocol != IPPROTO_TCP && sk->sk_protocol != IPPROTO_UDP) {
+		DEBUGP("SO_ORIGINAL_DST: Not a TCP/UDP socket\n");
 		return -ENOPROTOOPT;
 	}
 

--------------010305020907040306000307--
