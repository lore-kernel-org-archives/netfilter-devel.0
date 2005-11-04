From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 2/7] check if CTA_PROTOINFO_TCP is present
Date: Fri, 04 Nov 2005 19:00:21 +0100
Message-ID: <436BA1B5.9090905@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020509050608060407030000"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020509050608060407030000
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This fixes an oops triggered from userspace. If we don't pass
information about the private protocol info, the reference to attr will
be NULL. This is likely to happen in update messages.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020509050608060407030000
Content-Type: text/plain;
 name="05-check-protoinfo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-check-protoinfo.patch"

This fixes an oops triggered from userspace. If we don't pass information 
about the private protocol info, the reference to attr will be NULL. This is
likely to happen in update messages.

Signed-out-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-11-04 17:44:54.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-11-04 17:45:24.000000000 +0100
@@ -362,6 +362,11 @@ static int nfattr_to_tcp(struct nfattr *
 	struct nfattr *attr = cda[CTA_PROTOINFO_TCP-1];
 	struct nfattr *tb[CTA_PROTOINFO_TCP_MAX];
 
+	/* updates could not contain anything about the private 
+	 * protocol info, in that case skip the parsing. */
+	if (!attr)
+		return 0;
+
         if (nfattr_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, attr) < 0)
                 goto nfattr_failure;
 

--------------020509050608060407030000--
