From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] libip6t_HL.c bugfix similar to libipt_TTL.c
Date: Wed, 28 Jul 2004 12:38:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1727732474.20040728123855@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,

this is a similar bugfix to the one about libipt_TTL.c

Please apply,
Regards,
Maciej Soltysiak

Index: libip6t_HL.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libip6t_HL.c,v
retrieving revision 1.1
diff -u -r1.1 libip6t_HL.c
--- libip6t_HL.c        8 Jan 2003 09:14:20 -0000       1.1
+++ libip6t_HL.c        28 Jul 2004 10:37:47 -0000
@@ -24,9 +24,9 @@
 {
        printf(
 "HL target v%s options\n"
-"  --hl-set value              Set HL to <value>\n"
-"  --hl-dec value              Decrement HL by <value>\n"
-"  --hl-inc value              Increment HL by <value>\n"
+"  --hl-set value              Set HL to <value 0-255>\n"
+"  --hl-dec value              Decrement HL by <value 1-255>\n"
+"  --hl-inc value              Increment HL by <value 1-255>\n"
 , IPTABLES_VERSION);
 }

@@ -35,7 +35,7 @@
                struct ip6t_entry_target **target)
 {
        struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
-       u_int8_t value;
+       unsigned int value;

        if (*flags & IP6T_HL_USED) {
                exit_error(PARAMETER_PROBLEM,
@@ -50,8 +50,9 @@
                exit_error(PARAMETER_PROBLEM,
                                "HL: unexpected `!'");

-       value = atoi(optarg);
-
+        if (string_to_number(optarg, 0, 255, &value) == -1)
+                        exit_error(PARAMETER_PROBLEM,
+                                   "HL: Expected value between 0 and 255");
        switch (c) {

                case '1':
 
