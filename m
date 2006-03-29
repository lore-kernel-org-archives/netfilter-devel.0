From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ip6tables icmpv6 match
Date: Wed, 29 Mar 2006 16:25:27 +0900 (JST)
Message-ID: <200603290725.k2T7PRIa020651@toshiba.co.jp>
References: <427c54c0603262019l5aa43b66j7c9cac8d41a6704f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Mar_29_16_25_27_2006_249)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: danieldegraaf@gmail.com
In-Reply-To: <427c54c0603262019l5aa43b66j7c9cac8d41a6704f@mail.gmail.com>
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

----Next_Part(Wed_Mar_29_16_25_27_2006_249)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Daniel and all,

From: "Daniel De Graaf" <danieldegraaf@gmail.com>
Date: Sun, 26 Mar 2006 22:19:27 -0600

> libip6t_icmpv6.c registers a match called "icmp6", which means that
> ip6tables -vL and ip6tables-save cannot output the match correctly.

There are 2 solutions.

	1. just rename libip6t_icmpv6.c to libip6t_icmp6.c. This can
	   conform names of internal structure, library and kernel module.
	2. apply attached patch to fix find_match() so that ip6tables can
	   load libip6t_icmpv6.so.

I like 1 but I'm not sure we can do it. Anyone knows any historical
problem about it ?

-- Yasuyuki Kozakai

----Next_Part(Wed_Mar_29_16_25_27_2006_249)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="fix-icmpv6.patch"

[PATCH] fix loading libip6t_icmpv6.so

The current ip6tables fails to load libip6t_icmp6.so wehn user tries
'-p icmpv6', '-m icmpv6', or '-m icmp6'.

To fix this and keep compatibility,
	- 'name' in 'struct ip6tables_match icmpv6' must be 'icmp6'.
	  This name is used in kernel.
	- Then ip6tables should use the name 'icmp6' to search match in list.
	- ip6tables should try to load libip6t_icmpv6.so, not libip6t_icmp6.so.

---
commit 985c7966e4dcacbd7511afd5df86878652b946d6
tree 41192f2b1b4d46d0947b81bc888e0bfba3ab8e27
parent c94b52d4b6fff1bfc2da3e192b39e0f45cd12750
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 29 Mar 2006 12:06:44 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 29 Mar 2006 12:06:44 +0900

 ip6tables.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index dcf7d36..34506f5 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -713,16 +713,20 @@ find_match(const char *match_name, enum 
 {
 	struct ip6tables_match *ptr;
  	const char *icmp6 = "icmp6";
- 	const char *name;
+ 	const char *icmpv6 = "icmpv6";
+ 	const char *name, *libname;
   
 	/* This is ugly as hell. Nonetheless, there is no way of changing
 	 * this without hurting backwards compatibility */
  	if ( (strcmp(match_name,"icmpv6") == 0) ||
  	     (strcmp(match_name,"ipv6-icmp") == 0) ||
- 	     (strcmp(match_name,"icmp6") == 0) )
+ 	     (strcmp(match_name,"icmp6") == 0) ) {
  	     	name = icmp6;
- 	else
+		libname = icmpv6;
+ 	} else {
  		name = match_name;
+		libname = match_name;
+	}
  
 	for (ptr = ip6tables_matches; ptr; ptr = ptr->next) {
  		if (strcmp(name, ptr->name) == 0) {
@@ -747,8 +751,8 @@ find_match(const char *match_name, enum 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/libip6t_.so")
-			 + strlen(name)];
-		sprintf(path, "%s/libip6t_%s.so", lib_dir, name);
+			 + strlen(libname)];
+		sprintf(path, "%s/libip6t_%s.so", lib_dir, libname);
 		if (dlopen(path, RTLD_NOW)) {
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */

----Next_Part(Wed_Mar_29_16_25_27_2006_249)----
