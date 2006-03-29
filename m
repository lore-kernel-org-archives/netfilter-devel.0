From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH IP6TABLES]: don't allow to specify protocol of IPv6
 extension header
Date: Wed, 29 Mar 2006 17:34:07 +0900 (JST)
Message-ID: <200603290834.k2T8Y86Y018114@toshiba.co.jp>
References: <200603290659.k2T6xDJh017360@toshiba.co.jp>
	<442A4127.70908@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Mar_29_17_34_07_2006_328)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <442A4127.70908@trash.net>
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

----Next_Part(Wed_Mar_29_17_34_07_2006_328)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 29 Mar 2006 10:11:19 +0200

> Yasuyuki KOZAKAI wrote:
> > Hi,
> > 
> > Sometimes I hear that people do 'ip6tables -p ah ...' which never matches
> > any packet. IPv6 extension headers except of ESP are skipped and invalid
> > as argument of '-p'. Then I propose that ip6tables exits with error in such
> > case.
> 
> How about a warning for some time first? If people use iptables-restore
> this could break their entire ruleset ..

OK, then please ignore previous 'fixed patch' and apply this. Sorry for mess.

-- Yasuyuki Kozakai


----Next_Part(Wed_Mar_29_17_34_07_2006_328)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="check-exthdr-fixed-2.patch"

[PATCH] don't allow to specify protocol of IPv6 extension header

---
commit 9bbbc3c90face808eb05da8aae69c9e6f7b508b3
tree 5506d3520a60553607f074ed21969ca0c2fbb8aa
parent 5a2223d5d7d2d81ab036effd7460a9dea45d247e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 29 Mar 2006 12:50:32 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 29 Mar 2006 12:50:32 +0900

 ip6tables.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index dcf7d36..a6471ee 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -849,6 +849,17 @@ parse_protocol(const char *s)
 	return (u_int16_t)proto;
 }
 
+/* proto means IPv6 extension header ? */
+static int is_exthdr(u_int16_t proto)
+{
+	return (proto == IPPROTO_HOPOPTS ||
+		proto == IPPROTO_ROUTING ||
+		proto == IPPROTO_FRAGMENT ||
+		proto == IPPROTO_ESP ||
+		proto == IPPROTO_AH ||
+		proto == IPPROTO_DSTOPTS);
+}
+
 void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 {
 	int vialen = strlen(arg);
@@ -1926,6 +1937,11 @@ int do_command6(int argc, char *argv[], 
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO))
 				exit_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
+			
+			if (fw.ipv6.proto != IPPROTO_ESP &&
+			    is_exthdr(fw.ipv6.proto))
+				printf("Warning: never matched protocol: %s. "
+				       "use exension match instead.", protocol);
 			break;
 
 		case 's':

----Next_Part(Wed_Mar_29_17_34_07_2006_328)----
