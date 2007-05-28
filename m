From: "=?gb2312?B?uN+y/cD7?=" <xiaosuo@mail.nankai.edu.cn>
Subject: [PATCH] ip_conntrack_ftp: improve performance of update_nl_seq
Date: Mon, 28 May 2007 22:48:45 +0800
Message-ID: <380363725.06966@mail.nankai.edu.cn>
Reply-To: =?gb2312?B?uN+y/cD7?= <xiaosuo@mail.nankai.edu.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_1180363725_6960.attach"
Cc: xiaosuo@gmail.com
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

------=_1180363725_6960.attach
Content-Type: text/plain

[NETFILTER]: nf_conntrack_ftp: Improve the performance of update_nl_seq by using
temporary variables and changing the sequence of program.

----
Signed-off-by: xiaosuo <xiaosuo@gmail.com>
----
 ip_conntrack_ftp.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)
----
--- linux/net/ipv4/netfilter/ip_conntrack_ftp.c 2007-05-28 21:59:22.000000000
+0800
+++ linux-new/net/ipv4/netfilter/ip_conntrack_ftp.c     2007-05-28
22:36:07.000000000 +0800
@@ -264,25 +264,28 @@
 static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir,
                          struct sk_buff *skb)
 {
-       unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
+       unsigned int i, oldest;
+       u_int32_t *seq_aft_nl = info->seq_aft_nl[dir];
+       int seq_aft_nl_num = info->seq_aft_nl_num[dir];

-       /* Look for oldest: if we find exact match, we're done. */
-       for (i = 0; i < info->seq_aft_nl_num[dir]; i++) {
-               if (info->seq_aft_nl[dir][i] == nl_seq)
-                       return;
+       if (seq_aft_nl_num < NUM_SEQ_TO_REMEMBER) {
+               seq_aft_nl[info->seq_aft_nl_num[dir]++] = nl_seq;
+               ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+               return;
+       }

-               if (oldest == info->seq_aft_nl_num[dir]
-                   || before(info->seq_aft_nl[dir][i], oldest))
+       for (oldest = 0, i = 1; i < seq_aft_nl_num; i ++) {
+               if (seq_aft_nl[oldest] == nl_seq)
+                       return;
+               if (before(seq_aft_nl[i], seq_aft_nl[oldest]))
                        oldest = i;
        }

-       if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
-               info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
-               ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
-       } else if (oldest != NUM_SEQ_TO_REMEMBER) {
-               info->seq_aft_nl[dir][oldest] = nl_seq;
-               ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
-       }
+       if (nl_seq == seq_aft_nl[oldest] || before(nl_seq, seq_aft_nl[oldest]))
+               return;
+
+       seq_aft_nl[oldest] = nl_seq;
+       ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
 }

 static int help(struct sk_buff **pskb,



------=_1180363725_6960.attach
Content-Type: application/octet-stream;
	name="ip_conntrack_ftp-tuning.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="ip_conntrack_ftp-tuning.patch"

LS0tIGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfZnRwLmMJMjAwNy0w
NS0yOCAyMTo1OToyMi4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4LW5ldy9uZXQvaXB2NC9u
ZXRmaWx0ZXIvaXBfY29ubnRyYWNrX2Z0cC5jCTIwMDctMDUtMjggMjI6MzY6MDcuMDAwMDAw
MDAwICswODAwCkBAIC0yNjQsMjUgKzI2NCwyOCBAQAogc3RhdGljIHZvaWQgdXBkYXRlX25s
X3NlcSh1MzIgbmxfc2VxLCBzdHJ1Y3QgaXBfY3RfZnRwX21hc3RlciAqaW5mbywgaW50IGRp
ciwKIAkJCSAgc3RydWN0IHNrX2J1ZmYgKnNrYikKIHsKLQl1bnNpZ25lZCBpbnQgaSwgb2xk
ZXN0ID0gTlVNX1NFUV9UT19SRU1FTUJFUjsKKwl1bnNpZ25lZCBpbnQgaSwgb2xkZXN0Owor
CXVfaW50MzJfdCAqc2VxX2FmdF9ubCA9IGluZm8tPnNlcV9hZnRfbmxbZGlyXTsKKwlpbnQg
c2VxX2FmdF9ubF9udW0gPSBpbmZvLT5zZXFfYWZ0X25sX251bVtkaXJdOwogCi0JLyogTG9v
ayBmb3Igb2xkZXN0OiBpZiB3ZSBmaW5kIGV4YWN0IG1hdGNoLCB3ZSdyZSBkb25lLiAqLwot
CWZvciAoaSA9IDA7IGkgPCBpbmZvLT5zZXFfYWZ0X25sX251bVtkaXJdOyBpKyspIHsKLQkJ
aWYgKGluZm8tPnNlcV9hZnRfbmxbZGlyXVtpXSA9PSBubF9zZXEpCi0JCQlyZXR1cm47CisJ
aWYgKHNlcV9hZnRfbmxfbnVtIDwgTlVNX1NFUV9UT19SRU1FTUJFUikgeworCQlzZXFfYWZ0
X25sW2luZm8tPnNlcV9hZnRfbmxfbnVtW2Rpcl0rK10gPSBubF9zZXE7CisJCWlwX2Nvbm50
cmFja19ldmVudF9jYWNoZShJUENUX0hFTFBJTkZPX1ZPTEFUSUxFLCBza2IpOworCQlyZXR1
cm47CisJfQogCi0JCWlmIChvbGRlc3QgPT0gaW5mby0+c2VxX2FmdF9ubF9udW1bZGlyXQot
CQkgICAgfHwgYmVmb3JlKGluZm8tPnNlcV9hZnRfbmxbZGlyXVtpXSwgb2xkZXN0KSkKKwlm
b3IgKG9sZGVzdCA9IDAsIGkgPSAxOyBpIDwgc2VxX2FmdF9ubF9udW07IGkgKyspIHsKKwkJ
aWYgKHNlcV9hZnRfbmxbb2xkZXN0XSA9PSBubF9zZXEpCisJCQlyZXR1cm47CisJCWlmIChi
ZWZvcmUoc2VxX2FmdF9ubFtpXSwgc2VxX2FmdF9ubFtvbGRlc3RdKSkKIAkJCW9sZGVzdCA9
IGk7CiAJfQogCi0JaWYgKGluZm8tPnNlcV9hZnRfbmxfbnVtW2Rpcl0gPCBOVU1fU0VRX1RP
X1JFTUVNQkVSKSB7Ci0JCWluZm8tPnNlcV9hZnRfbmxbZGlyXVtpbmZvLT5zZXFfYWZ0X25s
X251bVtkaXJdKytdID0gbmxfc2VxOwotCQlpcF9jb25udHJhY2tfZXZlbnRfY2FjaGUoSVBD
VF9IRUxQSU5GT19WT0xBVElMRSwgc2tiKTsKLQl9IGVsc2UgaWYgKG9sZGVzdCAhPSBOVU1f
U0VRX1RPX1JFTUVNQkVSKSB7Ci0JCWluZm8tPnNlcV9hZnRfbmxbZGlyXVtvbGRlc3RdID0g
bmxfc2VxOwotCQlpcF9jb25udHJhY2tfZXZlbnRfY2FjaGUoSVBDVF9IRUxQSU5GT19WT0xB
VElMRSwgc2tiKTsKLQl9CisJaWYgKG5sX3NlcSA9PSBzZXFfYWZ0X25sW29sZGVzdF0gfHwg
YmVmb3JlKG5sX3NlcSwgc2VxX2FmdF9ubFtvbGRlc3RdKSkKKwkJcmV0dXJuOworCisJc2Vx
X2FmdF9ubFtvbGRlc3RdID0gbmxfc2VxOworCWlwX2Nvbm50cmFja19ldmVudF9jYWNoZShJ
UENUX0hFTFBJTkZPX1ZPTEFUSUxFLCBza2IpOwogfQogCiBzdGF0aWMgaW50IGhlbHAoc3Ry
dWN0IHNrX2J1ZmYgKipwc2tiLAo=

------=_1180363725_6960.attach--
