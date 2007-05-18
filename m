From: "Morten Isaksen" <misak@misak.dk>
Subject: [PATCH] libnetfilter_conntrack bug in snprintf_xml.c
Date: Fri, 18 May 2007 21:40:22 +0200
Message-ID: <20070518194016.872D7A50020@pfepb.post.tele.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
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

The port numbers are wrong in the XML output.

Index: src/conntrack/snprintf_xml.c
===================================================================
--- src/conntrack/snprintf_xml.c        (revision 6832)
+++ src/conntrack/snprintf_xml.c        (working copy)
@@ -182,13 +182,13 @@
        case IPPROTO_SCTP:
                if (type == __ADDR_SRC) {
                        ret = snprintf(buf, len, "<sport>%u</sport>",
-                                      tuple->l4src.tcp.port);
+                                      htons(tuple->l4src.tcp.port));
                        if (ret == -1)
                                return -1;
                        buffer_size(ret, &size, &len);
                } else {
                        ret = snprintf(buf, len, "<dport>%u</dport>",
-                                      tuple->l4dst.tcp.port);
+                                      htons(tuple->l4dst.tcp.port));
                        if (ret == -1)
                                return -1;
                        buffer_size(ret, &size, &len);



Regards
Morten Isaksen
http://misak.dk/blog/
