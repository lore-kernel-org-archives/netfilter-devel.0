From: Dave <dave@alfar.co.uk>
Subject: PATCH: fix invert flag on match mac save
Date: Sun, 01 Jun 2003 18:34:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EDA3916.3090604@alfar.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi there,
	I've been having problems using iptables-restore with the match mac 
extension, which I narrowed down to the position of the invert flag on 
save. Looks like this one's been hanging around for a while now.

===================================================================
--- extensions/libipt_mac.c      2003-06-01 17:47:52.000000000 +0100
+++ extensions/libipt_mac.c      2003-06-01 17:55:43.000000000 +0100
@@ -118,9 +118,10 @@
  /* Saves the union ipt_matchinfo in parsable form to stdout. */
  static void save(const struct ipt_ip *ip, const struct ipt_entry_match 
*match)
  {
+	if (((struct ipt_mac_info *)match->data)->invert)
+		printf("! ");
  	printf("--mac-source ");
-	print_mac(((struct ipt_mac_info *)match->data)->srcaddr,
-		((struct ipt_mac_info *)match->data)->invert);
+	print_mac(((struct ipt_mac_info *)match->data)->srcaddr,0);
  }

  static
--- extensions/libip6t_mac.c     2003-06-01 17:56:15.000000000 +0100
+++ extensions/libip6t_mac.c     2003-06-01 17:57:04.000000000 +0100
@@ -118,9 +118,10 @@
  /* Saves the union ip6t_matchinfo in parsable form to stdout. */
  static void save(const struct ip6t_ip6 *ip, const struct 
ip6t_entry_match *match)
  {
+	if (((struct ip6t_mac_info *)match->data)->invert)
+		printf("! ");
  	printf("--mac-source ");
-	print_mac(((struct ip6t_mac_info *)match->data)->srcaddr,
-		((struct ip6t_mac_info *)match->data)->invert);
+	print_mac(((struct ip6t_mac_info *)match->data)->srcaddr,0);
  }

  static
===================================================================

David Zambonini
