From: "yihyung" <yihyung@so-net.net.tw>
Subject: /proc/net/ip_conntrack does not list all connections
Date: Sun, 24 Nov 2002 02:15:53 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1038075353.86497.yihyung@so-net.net.tw>
Reply-To: yihyung@so-net.net.tw
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="---zI6zTDuQWDgeYDqbCROzWyF:xv?"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


-----zI6zTDuQWDgeYDqbCROzWyF:xv?
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: quoted-printable

I=20made=20a=20patch=20to=20fix=20it=20for=20my=202.4.19=20kernel.

Yih=20Yung


-----zI6zTDuQWDgeYDqbCROzWyF:xv?
Content-Type: text/plain;
	name="2.4.19.patch"
Content-Disposition: attachment;
	filename="2.4.19.patch"
Content-Transfer-Encoding: 7Bit

diff -ur linux-2.4.19-old/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.19-new/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.19-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2002-08-03 08:39:46.000000000 +0800
+++ linux-2.4.19-new/net/ipv4/netfilter/ip_conntrack_standalone.c	2002-11-24 01:15:52.000000000 +0800
@@ -122,8 +122,10 @@
 		return 0;
 
 	newlen = print_conntrack(buffer + *len, hash->ctrack);
-	if (*len + newlen > maxlen)
+	if (*len + newlen > maxlen) {
+		-- * upto;
 		return 1;
+	}
 	else *len += newlen;
 
 	return 0;
@@ -157,6 +159,7 @@
 		len += print_expect(buffer + len, expect);
 		if (len > length) {
 			len = last_len;
+			-- upto;
 			goto finished;
 		}
 	}


-----zI6zTDuQWDgeYDqbCROzWyF:xv?--
