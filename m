From: "Jesse Peng" <Jesse@deansoft.com.tw>
Subject: Re: [PATCH 2.4] Introducing Bidirectional conntrack mark
Date: Fri, 9 Sep 2005 14:49:59 +0800
Message-ID: <001301c5b50a$b2c718a0$fefefe0a@jesseh7ht76e8n>
References: <002601c5b390$1d641d10$fefefe0a@jesseh7ht76e8n>
	<Pine.LNX.4.61.0509081801100.21201@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
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


----- Original Message -----
From: "Henrik Nordstrom" <hno@marasystems.com>
To: "Jesse Peng" <Jesse@deansoft.com.tw>
Cc: "Wang Jian" <lark@linux.net.cn>; "netfilter-devel"
<netfilter-devel@lists.netfilter.org>
Sent: Friday, September 09, 2005 12:10 AM
Subject: Re: [PATCH 2.4] Introducing Bidirectional conntrack mark


> Patch seems incomplete. Can not find definition of conntrack->dir_mark
Thanks,post them below.

> Also as before I still wonder if this relatively big amount of info in
> each conntrack is really needed. CONNMARK already declares 32 bits per
> conntrack entry free for any use. Perhaps better to extend CONNMARK with
> shifting of the value allowing simple save/restore operations based on
> direction (where directions is selected by the already existing conntrack
> match).
As only getting them twice as a space,why not treat them easily? :)
Otherwise,I will do things as keeping a private structure and cast the
existing 32 bits to address pointer pointing to it while needed.

>
> But I do fully agree with the principle of being able to intelligenly keep
> conntrack state information/mark direction dependent and that having just
> a simple masking of the value is perhaps not sufficient in all situations.
Yes,you are a wise person! :)

diff -Nur a/include/linux/netfilter_ipv4/ip_conntrack.h
b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h    Mon Apr  4 09:42:20
2005
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h       Fri Sep  9 14:20:02
2005
@@ -207,6 +207,9 @@
        } nat;
 #endif /* CONFIG_IP_NF_NAT_NEEDED */

+#if defined(CONFIG_IP_NF_CTDIRMARK)
+                unsigned long mark_dir[IP_CT_DIR_MAX];
+#endif
 };
diff -Nur a/net/ipv4/netfilter/ip_conntrack_standalone.c
b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c   Mon Apr  4 09:42:20
2005
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c      Wed Sep  7 15:43:01
2005
@@ -107,7 +107,13 @@
                len += sprintf(buffer + len, "[ASSURED] ");
        len += sprintf(buffer + len, "use=%u ",
                       atomic_read(&conntrack->ct_general.use));
-       len += sprintf(buffer + len, "\n");
+
+#if defined(CONFIG_IP_NF_CTDIRMARK)
+        len += sprintf(buffer + len,
+                    "ctdirmark_original=%x,ctdirmark_reply=%x",
mark_dir[IP_CT_DIR_ORIGINAL],mark_dir[IP_CT_DIR_REPLY]);
+#endif
+
+        len += sprintf(buffer + len, "\n");

        return len;
 }
diff -Nur a/net/ipv4/netfilter/ip_conntrack_core.c
b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c Mon Apr  4 09:42:20 2005
+++ b/net/ipv4/netfilter/ip_conntrack_core.c    Wed Sep  7 15:46:09 2005
@@ -742,7 +742,14 @@
                __set_bit(IPS_EXPECTED_BIT, &conntrack->status);
                conntrack->master = expected;
                expected->sibling = conntrack;
-               LIST_DELETE(&ip_conntrack_expect_list, expected);
+
+#if CONFIG_IP_NF_CTDIRMARK
+                conntrack->mark_dir[IP_CT_DIR_ORIGINAL] =
expected->expectant->mark_dir[IP_CT_DIR_ORIGINAL];
+                conntrack->mark_dir[IP_CT_DIR_REPLY] =
expected->expectant->mark_dir[IP_CT_DIR_REPLY];
+#endif
+
+
+                LIST_DELETE(&ip_conntrack_expect_list, expected);
                expected->expectant->expecting--;
                nf_conntrack_get(&master_ct(conntrack)->infos[0]);
        }
