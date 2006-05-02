From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/06]: H.323 helper: fix use of uninitialized data
Date: Tue,  2 May 2006 22:48:05 +0200 (MEST)
Message-ID: <20060502204805.7610.53939.sendpatchset@localhost.localdomain>
References: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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

[NETFILTER]: H.323 helper: fix use of uninitialized data

When a Choice element contains an unsupported choice no error is returned
and parsing continues normally, but the choice value is not set and
contains data from the last parsed message. This may in turn lead to
parsing of more stale data and following crashes.

Fixes a crash triggered by testcase 0003243 from the PROTOS c07-h2250v4
testsuite following random other testcases:

CPU:    0
EIP:    0060:[<c01a9554>]    Not tainted VLI
EFLAGS: 00210646   (2.6.17-rc2 #3)
EIP is at memmove+0x19/0x22
eax: d7be0307   ebx: d7be0307   ecx: e841fcf9   edx: d7be0307
esi: bfffffff   edi: bfffffff   ebp: da5eb980   esp: c0347e2c
ds: 007b   es: 007b   ss: 0068
Process events/0 (pid: 4, threadinfo=c0347000 task=dff86a90)
Stack: <0>00000006 c0347ea6 d7be0301 e09a6b2c 00000006 da5eb980 d7be003e d7be0052
       c0347f6c e09a6d9c 00000006 c0347ea6 00000006 00000000 d7b9a548 00000000
       c0347f6c d7b9a548 00000004 e0a1a119 0000028f 00000006 c0347ea6 00000006
Call Trace:
 [<e09a6b2c>] mangle_contents+0x40/0xd8 [ip_nat]
 [<e09a6d9c>] ip_nat_mangle_tcp_packet+0xa1/0x191 [ip_nat]
 [<e0a1a119>] set_addr+0x60/0x14d [ip_nat_h323]
 [<e0ab6e66>] q931_help+0x2da/0x71a [ip_conntrack_h323]
 [<e0ab6e98>] q931_help+0x30c/0x71a [ip_conntrack_h323]
 [<e09af242>] ip_conntrack_help+0x22/0x2f [ip_conntrack]
 [<c022934a>] nf_iterate+0x2e/0x5f
 [<c025d357>] xfrm4_output_finish+0x0/0x39f
 [<c02294ce>] nf_hook_slow+0x42/0xb0
 [<c025d357>] xfrm4_output_finish+0x0/0x39f
 [<c025d732>] xfrm4_output+0x3c/0x4e
 [<c025d357>] xfrm4_output_finish+0x0/0x39f
 [<c0230370>] ip_forward+0x1c2/0x1fa
 [<c022f417>] ip_rcv+0x388/0x3b5
 [<c02188f9>] netif_receive_skb+0x2bc/0x2ec
 [<c0218994>] process_backlog+0x6b/0xd0
 [<c021675a>] net_rx_action+0x4b/0xb7
 [<c0115606>] __do_softirq+0x35/0x7d
 [<c0104294>] do_softirq+0x38/0x3f

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6d7b293e330618cbfa6b4e4dd85dc0072ccd8c7c
tree 1f5b291ac727cc5c4508e588f836ca55dbd73f80
parent ce641a7a27c17eaffbc769ef81d29c3925214655
author Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 21:58:03 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 21:58:03 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
index 4807800..f52d2c4 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
@@ -703,6 +703,10 @@ int decode_choice(bitstr_t * bs, field_t
 		type = get_bits(bs, f->sz);
 	}
 
+	/* Write Type */
+	if (base)
+		*(unsigned *) base = type;
+
 	/* Check Range */
 	if (type >= f->ub) {	/* Newer version? */
 		BYTE_ALIGN(bs);
@@ -712,10 +716,6 @@ int decode_choice(bitstr_t * bs, field_t
 		return H323_ERROR_NONE;
 	}
 
-	/* Write Type */
-	if (base)
-		*(unsigned *) base = type;
-
 	/* Transfer to son level */
 	son = &f->fields[type];
 	if (son->attr & STOP) {
