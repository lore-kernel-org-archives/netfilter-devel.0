From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/10] netfilter: nf_nat_snmp_basic: add missing helper alias name
Date: Sat, 20 Oct 2018 11:43:13 +0200
Message-ID: <20181020094317.16011-7-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

In order to upload helper module automatically, helper alias name
is needed. so that MODULE_ALIAS_NFCT_HELPER() should be added.
And unlike other nat helper modules, the nf_nat_snmp_basic can be
used independently.
helper name is "snmp_trap" so that alias name will be
"nfct-helper-snmp_trap" by MODULE_ALIAS_NFCT_HELPER(snmp_trap)

test command:
   %iptables -t raw -I PREROUTING -p udp -j CT --helper snmp_trap
   %lsmod | grep nf_nat_snmp_basic

We can see nf_nat_snmp_basic module is uploaded automatically.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index ac110c1d55b5..a0aa13bcabda 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -60,6 +60,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
 MODULE_DESCRIPTION("Basic SNMP Application Layer Gateway");
 MODULE_ALIAS("ip_nat_snmp_basic");
+MODULE_ALIAS_NFCT_HELPER("snmp_trap");
 
 #define SNMP_PORT 161
 #define SNMP_TRAP_PORT 162
-- 
2.11.0
