From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] C99 initializers for libip6t_HL.c
Date: Sun, 23 Jan 2005 23:23:26 +0100
Message-ID: <1606598165.20050123232326@dns.toxicfilms.tv>
References: <1213386207.20050123232039@dns.toxicfilms.tv>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1213386207.20050123232039@dns.toxicfilms.tv>
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

Hello,

this is C99 for libip6t_HL.c

Regards,
Maciej

Index: iptables/extensions/libip6t_HL.c
===================================================================
--- iptables/extensions/libip6t_HL.c    (revision 3612)
+++ iptables/extensions/libip6t_HL.c    (working copy)
@@ -147,17 +147,17 @@

 static
 struct ip6tables_target HL = { NULL,
-       "HL",
-       IPTABLES_VERSION,
-       IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
-       IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
-       &help,
-       &init,
-       &parse,
-       &final_check,
-       &print,
-       &save,
-       opts
+       .name           = "HL",
+       .version        = IPTABLES_VERSION,
+       .size           = IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
+       .userspacesize  = IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
+       .help           = &help,
+       .init           = &init,
+       .parse          = &parse,
+       .final_check    = &final_check,
+       .print          = &print,
+       .save           = &save,
+       .extra_opts     = opts
 };

 void _init(void)
