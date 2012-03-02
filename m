From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: patch in bugzilla
Date: Fri, 2 Mar 2012 21:28:10 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1203022123440.6223@frira.zrqbmnf.qr>
References: <CAO88JF9FcBkjEs345hK4bOhQa1q-RuckkrLN9SKUUt3cWaLJKw@mail.gmail.com> <alpine.LNX.2.01.1202281409020.10284@frira.zrqbmnf.qr> <20120229125052.GA1115@1984> <20120229232739.GB3817@1984> <CAO88JF-=PTq2ZXaNWhE6mLKZY96y_fqCqxetNy-6h-Dwv3Ph3Q@mail.gmail.com>
 <20120302164209.GA13687@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jonh Wendell <jonh.wendell@vexcorp.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42817 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab2CBU2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:28:12 -0500
In-Reply-To: <20120302164209.GA13687@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-03-02 17:42, Pablo Neira Ayuso wrote:

>On Thu, Mar 01, 2012 at 05:07:57PM -0300, Jonh Wendell wrote:
>> diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
>> index 24cdbdb..b9a42c9 100644
>> --- a/include/libiptc/libiptc.h
>> +++ b/include/libiptc/libiptc.h
>> @@ -74,7 +74,8 @@ int iptc_replace_entry(const xt_chainlabel chain,
>>  		       struct xtc_handle *handle);
>>  
>>  /* Append entry `e' to chain `chain'.  Equivalent to insert with
>> -   rulenum = length of chain. */
>> +   rulenum = length of chain. Returns the position the entry was
>> +   inserted or 0 if an error occurs */
>>  int iptc_append_entry(const xt_chainlabel chain,
>>  		      const struct ipt_entry *e,
>>  		      struct xtc_handle *handle);
>> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
>> index b191d5d..8df06d6 100644
>> --- a/iptables/ip6tables.c
>> +++ b/iptables/ip6tables.c
>> @@ -698,7 +698,8 @@ append_entry(const xt_chainlabel chain,
>>  			fw->ipv6.dmsk = dmasks[j];
>>  			if (verbose)
>>  				print_firewall_line(fw, handle);
>> -			ret &= ip6tc_append_entry(chain, fw, handle);
>> +			if (!ip6tc_append_entry(chain, fw, handle))
>> +				ret = 0;
>>  		}
>>  	}
>>
>
>This requires also modifying the libversion numbers for libiptc since the
>interface has changed.
>
>IMO, libiptc has always remained an internal library, but it seems
>some of you are using it to link your program to it.
>
>Your patch will break other programs made by people like you that use
>libiptc.
>
>Jan?

iptc is the last thing I want on my todo list :)
Talk to Jasper, who has more or less an actual overview about
what is and could be using libiptc externally.
Meanwhile see this untested proposal of mine..

[link  git://dev.medozas.de/iptables iptc]

parent 7c1b69b97571ddeb8c624b0a1da366a456895a6d (v1.4.12.2-32-g7c1b69b)
commit 5fb980ce700a88b03d10a6fe49ac6670ccbcb217
Author: Jonh Wendell <jonh.wendell@vexcorp.com>
Date:   Thu Mar 1 17:04:22 2012 -0300

libiptc: return new rule's position during append
---
 include/libiptc/libip6tc.h |    5 +++++
 include/libiptc/libiptc.h  |    6 ++++++
 iptables/ip6tables.c       |    3 ++-
 iptables/iptables.c        |    3 ++-
 libiptc/Makefile.am        |    4 ++--
 libiptc/libip4tc.c         |    1 +
 libiptc/libip6tc.c         |    1 +
 libiptc/libiptc.c          |   17 ++++++++++++-----
 8 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index c656bc4..dfc6e0d 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -75,6 +75,11 @@ int ip6tc_append_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *e,
 		       struct xtc_handle *handle);
 
+/* Append entry `fw' to chain `chain'. Equivalent to insert with
+   rulenum = length of chain. */
+int ip6tc_append_entry2(const xt_chainlabel chain, const struct ip6t_entry *e,
+			struct xtc_handle *handle);
+
 /* Check whether a matching rule exists */
 int ip6tc_check_entry(const xt_chainlabel chain,
 		       const struct ip6t_entry *origfw,
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 24cdbdb..85992f1 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -79,6 +79,12 @@ int iptc_append_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *e,
 		      struct xtc_handle *handle);
 
+/* Append entry `e' to chain `chain'.  Equivalent to insert with
+   rulenum = length of chain. Returns the position the entry was
+   inserted or 0 if an error occurs */
+int iptc_append_entry2(const xt_chainlabel chain, const struct ipt_entry *e,
+		       struct xtc_handle *handle);
+
 /* Check whether a mathching rule exists */
 int iptc_check_entry(const xt_chainlabel chain,
 		      const struct ipt_entry *origfw,
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b191d5d..6e9e671 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -698,7 +698,8 @@ append_entry(const xt_chainlabel chain,
 			fw->ipv6.dmsk = dmasks[j];
 			if (verbose)
 				print_firewall_line(fw, handle);
-			ret &= ip6tc_append_entry(chain, fw, handle);
+			if (ip6tc_append_entry2(chain, fw, handle) <= 0)
+				ret = 0;
 		}
 	}
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 03ac63b..5a5ac6b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -700,7 +700,8 @@ append_entry(const xt_chainlabel chain,
 			fw->ip.dmsk.s_addr = dmasks[j].s_addr;
 			if (verbose)
 				print_firewall_line(fw, handle);
-			ret &= iptc_append_entry(chain, fw, handle);
+			if (iptc_append_entry2(chain, fw, handle) <= 0)
+				ret = 0;
 		}
 	}
 
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index f789d34..a275d86 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -10,6 +10,6 @@ libiptc_la_SOURCES  =
 libiptc_la_LIBADD   = libip4tc.la libip6tc.la
 libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
 libip4tc_la_SOURCES = libip4tc.c
-libip4tc_la_LDFLAGS = -version-info 1:0:1
+libip4tc_la_LDFLAGS = -version-info 2:0:2
 libip6tc_la_SOURCES = libip6tc.c
-libip6tc_la_LDFLAGS = -version-info 1:0:1 ${libiptc_LDFLAGS2}
+libip6tc_la_LDFLAGS = -version-info 2:0:2 ${libiptc_LDFLAGS2}
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index dd59951..b9965d3 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -70,6 +70,7 @@ typedef unsigned int socklen_t;
 #define TC_INSERT_ENTRY		iptc_insert_entry
 #define TC_REPLACE_ENTRY	iptc_replace_entry
 #define TC_APPEND_ENTRY		iptc_append_entry
+#define TC_APPEND_ENTRY2	iptc_append_entry2
 #define TC_CHECK_ENTRY		iptc_check_entry
 #define TC_DELETE_ENTRY		iptc_delete_entry
 #define TC_DELETE_NUM_ENTRY	iptc_delete_num_entry
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 7128e1c..d9a9aff 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -68,6 +68,7 @@ typedef unsigned int socklen_t;
 #define TC_INSERT_ENTRY		ip6tc_insert_entry
 #define TC_REPLACE_ENTRY	ip6tc_replace_entry
 #define TC_APPEND_ENTRY		ip6tc_append_entry
+#define TC_APPEND_ENTRY2	ip6tc_append_entry2
 #define TC_CHECK_ENTRY		ip6tc_check_entry
 #define TC_DELETE_ENTRY		ip6tc_delete_entry
 #define TC_DELETE_NUM_ENTRY	ip6tc_delete_num_entry
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 63fcfc2..c0dd4f5 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1836,11 +1836,12 @@ TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 }
 
 /* Append entry `fw' to chain `chain'.  Equivalent to insert with
-   rulenum = length of chain. */
+   rulenum = length of chain. Returns the position the entry was
+   inserted or 0 if an error occurs */
 int
-TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
-		const STRUCT_ENTRY *e,
-		struct xtc_handle *handle)
+TC_APPEND_ENTRY2(const IPT_CHAINLABEL chain,
+		 const STRUCT_ENTRY *e,
+		 struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1872,7 +1873,13 @@ TC_APPEND_ENTRY(const IPT_CHAINLABEL chain,
 
 	set_changed(handle);
 
-	return 1;
+	return c->num_rules;
+}
+
+int TC_APPEND_ENTRY(const IPT_CHAINLABEL chain, const STRUCT_ENTRY *e,
+		    struct xtc_handle *handle)
+{
+	return (TC_APPEND_ENTRY2(chain, e, handle) <= 0) ? 0 : 1;
 }
 
 static inline int
-- 
# Created with git-export-patch
