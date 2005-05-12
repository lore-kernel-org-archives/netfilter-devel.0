From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng 2/3] h323-conntrack-nat updates: q931_find_u2u()
	returns relative length
Date: Thu, 12 May 2005 22:53:05 +0200
Message-ID: <20050512205305.GE2175@roonstrasse.net>
References: <20050512204956.GA2086@roonstrasse.net>
	<20050512205206.GC2175@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="H8ygTp4AXg6deix2"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050512205206.GC2175@roonstrasse.net>
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


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2005/05/12 22:52, Max Kellermann <max@duempel.org> wrote:
> h323-02-u2u_length_is_relative.patch
> - minor bugfix, never occurred in reality
> - length returned by q931_find_u2u() is relative
> 

sorry, I'll never learn... ;)


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="h323-02-u2u_length_is_relative.patch"

Thu May 12 22:21:24 CEST 2005  max@duempel.org
  * length returned by q931_find_u2u() is relative
diff -rN -u old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c
--- old-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-12 22:48:51.000000000 +0200
+++ new-h323-0/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323_h225.c	2005-05-12 22:48:51.000000000 +0200
@@ -214,9 +214,7 @@
 {
 	struct asn1_per_buffer bb;
 
-	/* protocol(1) + header(3) + protocolIdentifier(6) +
-	   h245ipAddress(1) + h245ipv4(4) + h245ipv4port(2) */
-	if (length < 17)
+	if (i + 8 > length)
 		return NF_ACCEPT;
 
 	if (data[i++] != 0x05) /* X.208 / X.209 */
@@ -297,6 +295,10 @@
 		if (i == 0)
 			return NF_ACCEPT;
 
+		/* the length returned by q931_find_u2u() is relative
+		   to i */
+		length += i;
+
 		return h225_parse_q931_connect(pskb, ct, ctinfo,
 					       data, i, length);
 	} else {


--H8ygTp4AXg6deix2--
