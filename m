From: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [Bug 1764] New: conntrack oops while reading /proc/net/ip_conntrack
Date: Mon, 29 Mar 2004 16:39:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <00cc01c415a4$1462dde0$d100000a@sbs2003.local>
References: <11020000.1072813876@[10.10.2.4]>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>,
	<christophe@saout.de>,
	<laforge@netfilter.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <Administrator>
Content-Class: urn:content-classes:message
In-Reply-To: <11020000.1072813876@[10.10.2.4]>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 30 Dec 2003 11:51:16 -0800
"Martin J. Bligh" <mbligh@aracnet.com> wrote:

> http://bugme.osdl.org/show_bug.cgi?id=1764
> 
>            Summary: conntrack oops while reading /proc/net/ip_conntrack
>     Kernel Version: 2.6.0
>             Status: NEW
>           Severity: high
>              Owner: laforge@gnumonks.org
>          Submitter: christophe@saout.de
...
> Apparently expect->expectant->helper is NULL in print_expect
> (net/ipv4/netfilter/ip_conntrack_standalone.c).

Um, Harald, other developers,

	Shouldn't list_conntracks do READ_LOCK(&ip_conntrack_expect_tuple_lock) before walking the expect list?

Here's a patch.  Does it do anything?
Rusty.
-- 
   there are those who do and those who hang on and you don't see too
   many doers quoting their contemporaries.  -- Larry McVoy

Name: Grab ip_conntrack_expect_tuple_lock in list_conntracks
Author: Rusty Russell
Status: Experimental

D: http://bugme.osdl.org/show_bug.cgi?id=1764
D: We're walking the expect list without the ip_conntrack_expect_tuple_lock.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20891-linux-2.6.1-rc1/include/linux/netfilter_ipv4/ip_conntrack_core.h .20891-linux-2.6.1-rc1.updated/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- .20891-linux-2.6.1-rc1/include/linux/netfilter_ipv4/ip_conntrack_core.h	2003-09-22 10:26:46.000000000 +1000
+++ .20891-linux-2.6.1-rc1.updated/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-01-03 15:27:14.000000000 +1100
@@ -50,5 +50,6 @@ static inline int ip_conntrack_confirm(s
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
+DECLARE_RWLOCK_EXTERN(ip_conntrack_expect_tuple_lock);
 #endif /* _IP_CONNTRACK_CORE_H */
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .20891-linux-2.6.1-rc1/net/ipv4/netfilter/ip_conntrack_standalone.c .20891-linux-2.6.1-rc1.updated/net/ipv4/netfilter/ip_conntrack_standalone.c
--- .20891-linux-2.6.1-rc1/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-12-18 15:53:34.000000000 +1100
+++ .20891-linux-2.6.1-rc1.updated/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-01-03 15:23:40.000000000 +1100
@@ -154,6 +154,7 @@ list_conntracks(char *buffer, char **sta
 	}
 
 	/* Now iterate through expecteds. */
+	READ_LOCK(&ip_conntrack_expect_tuple_lock);
 	list_for_each(e, &ip_conntrack_expect_list) {
 		unsigned int last_len;
 		struct ip_conntrack_expect *expect
@@ -164,10 +165,12 @@ list_conntracks(char *buffer, char **sta
 		len += print_expect(buffer + len, expect);
 		if (len > length) {
 			len = last_len;
-			goto finished;
+			goto finished_expects;
 		}
 	}
 
+ finished_expects:
+	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
  finished:
 	READ_UNLOCK(&ip_conntrack_lock);
 
