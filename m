From: Patrick McHardy <kaber@trash.net>
Subject: Re: Major problem with conntrack utility and kernel 2.6.14.3
Date: Sun, 04 Dec 2005 21:04:19 +0100
Message-ID: <43934BC3.3090107@trash.net>
References: <4361EAAB.1090206@fliegl.de> <436281BB.2010100@fliegl.de>
	<4392510A.3030400@eurodev.net>
	<200512041004.37192.romary@nikoon.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020402060004010601090109"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Romary Sonrier <romary@nikoon.com>
In-Reply-To: <200512041004.37192.romary@nikoon.com>
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
--------------020402060004010601090109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Romary Sonrier wrote:
> Hi evrybody,
> 
> Next week, my main goal at work will to help you to solve this issue.
> I can reproduce easly the kernel oops with my boxs... I still need few hours 
> to be able to print the kernel oops on my serial port (because it's an 
> embedded system). 
> As soon as possible i will send you the whole messages of the kernel oops.
> Is there a mean to help you more quicly ? using some tools like strace or gdb?
> I'm far from being on geek okernel deguging.... ;-)

Please try this patch, I hope it will fix the problems you're seeing.

--------------020402060004010601090109
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix unbalanced read_unlock_bh in ctnetlink

NFA_NEST calls NFA_PUT which jumps to nfattr_failure if the skb has no
room left. We call read_unlock_bh at nfattr_failure for the NFA_PUT inside
the locked section, so move NFA_NEST inside the locked section too.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cd85228eea7c7ab9d701090e3dc9643397cf271d
tree e3fa7a6a24c5b199d311a9f74c312fee3b18eae7
parent 96c75906027f008ed3a4058a606938901e9c6d99
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 20:56:05 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 20:56:05 +0100

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index aeb7353..e7fa29e 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -341,9 +341,10 @@ static int tcp_print_conntrack(struct se
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
+	struct nfattr *nest_parms;
 	
 	read_lock_bh(&tcp_lock);
+	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
 	read_unlock_bh(&tcp_lock);

--------------020402060004010601090109--
