From: Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH v4 2/2] ipset (userspace): add "inner" flag version support
Date: Fri, 05 Jul 2013 23:24:08 +0100
Message-ID: <51D74788.1000006@googlemail.com>
References: <cover.1373061728.git.mr.dash.four@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:35645 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3GEWYS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:24:18 -0400
Received: by mail-we0-f178.google.com with SMTP id u53so2315248wes.37
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 15:24:17 -0700 (PDT)
In-Reply-To: <cover.1373061728.git.mr.dash.four@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds "inner" flag version support to all registered ipset types.

Revision history:

v1 * initial revision

Signed-off-by: Dash Four <mr.dash.four@googlemail.com>
---
  lib/ipset_bitmap_ip.c      | 45 +++++++++++++++++++++++++
  lib/ipset_bitmap_ipmac.c   | 51 ++++++++++++++++++++++++++++
  lib/ipset_bitmap_port.c    | 44 ++++++++++++++++++++++++
  lib/ipset_hash_ip.c        | 44 ++++++++++++++++++++++++
  lib/ipset_hash_ipport.c    | 63 ++++++++++++++++++++++++++++++++++
  lib/ipset_hash_ipportip.c  | 74 ++++++++++++++++++++++++++++++++++++++++
  lib/ipset_hash_ipportnet.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++
  lib/ipset_hash_net.c       | 49 +++++++++++++++++++++++++++
  lib/ipset_hash_netiface.c  | 64 +++++++++++++++++++++++++++++++++++
  lib/ipset_hash_netport.c   | 69 +++++++++++++++++++++++++++++++++++++
  10 files changed, 587 insertions(+)

diff --git a/lib/ipset_bitmap_ip.c b/lib/ipset_bitmap_ip.c
index a4726db..1a967cd 100644
--- a/lib/ipset_bitmap_ip.c
+++ b/lib/ipset_bitmap_ip.c
@@ -201,9 +201,54 @@ static struct ipset_type ipset_bitmap_ip1 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_bitmap_ip2 = {
+	.name = "bitmap:ip",
+	.alias = { "ipmap", NULL },
+	.revision = 2,
+	.family = NFPROTO_IPV4,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = bitmap_ip_create_args1,
+		[IPSET_ADD] = bitmap_ip_add_args1,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_NETMASK)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = bitmap_ip_usage1,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
  	ipset_type_add(&ipset_bitmap_ip0);
  	ipset_type_add(&ipset_bitmap_ip1);
+	ipset_type_add(&ipset_bitmap_ip2);
  }
diff --git a/lib/ipset_bitmap_ipmac.c b/lib/ipset_bitmap_ipmac.c
index 67217a9..7d64a8e 100644
--- a/lib/ipset_bitmap_ipmac.c
+++ b/lib/ipset_bitmap_ipmac.c
@@ -207,9 +207,60 @@ static struct ipset_type ipset_bitmap_ipmac1 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_bitmap_ipmac2 = {
+	.name = "bitmap:ip,mac",
+	.alias = { "macipmap", NULL },
+	.revision = 2,
+	.family = NFPROTO_IPV4,
+	.dimension = IPSET_DIM_TWO,
+	.last_elem_optional = true,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_single_ip,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ether,
+			.print = ipset_print_ether,
+			.opt = IPSET_OPT_ETHER
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = bitmap_ipmac_create_args1,
+		[IPSET_ADD] = bitmap_ipmac_add_args1,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_ETHER),
+	},
+
+	.usage = bitmap_ipmac_usage1,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
  	ipset_type_add(&ipset_bitmap_ipmac0);
  	ipset_type_add(&ipset_bitmap_ipmac1);
+	ipset_type_add(&ipset_bitmap_ipmac2);
  }
diff --git a/lib/ipset_bitmap_port.c b/lib/ipset_bitmap_port.c
index 6959c3a..5fe11c2 100644
--- a/lib/ipset_bitmap_port.c
+++ b/lib/ipset_bitmap_port.c
@@ -181,9 +181,53 @@ static struct ipset_type ipset_bitmap_port1 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_bitmap_port2 = {
+	.name = "bitmap:port",
+	.alias = { "portmap", NULL },
+	.revision = 2,
+	.family = NFPROTO_UNSPEC,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_tcp_port,
+			.print = ipset_print_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = bitmap_port_create_args1,
+		[IPSET_ADD] = bitmap_port_add_args1,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_PORT),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_PORT),
+	},
+
+	.usage = bitmap_port_usage1,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
  	ipset_type_add(&ipset_bitmap_port0);
  	ipset_type_add(&ipset_bitmap_port1);
+	ipset_type_add(&ipset_bitmap_port2);
  }
diff --git a/lib/ipset_hash_ip.c b/lib/ipset_hash_ip.c
index 19688db..9fa42d6 100644
--- a/lib/ipset_hash_ip.c
+++ b/lib/ipset_hash_ip.c
@@ -246,9 +246,53 @@ static struct ipset_type ipset_hash_ip1 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_ip2 = {
+	.name = "hash:ip",
+	.alias = { "iphash", NULL },
+	.revision = 2,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ip_create_args1,
+		[IPSET_ADD] = hash_ip_add_args1,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_NETMASK)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+
+	.usage = hash_ip_usage1,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
  	ipset_type_add(&ipset_hash_ip0);
  	ipset_type_add(&ipset_hash_ip1);
+	ipset_type_add(&ipset_hash_ip2);
  }
diff --git a/lib/ipset_hash_ipport.c b/lib/ipset_hash_ipport.c
index b1c9f72..e6b62f5 100644
--- a/lib/ipset_hash_ipport.c
+++ b/lib/ipset_hash_ipport.c
@@ -294,9 +294,72 @@ static struct ipset_type ipset_hash_ipport2 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_ipport3 = {
+	.name = "hash:ip,port",
+	.alias = { "ipporthash", NULL },
+	.revision = 3,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipport_create_args2,
+		[IPSET_ADD] = hash_ipport_add_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO),
+	},
+
+	.usage = hash_ipport_usage2,
+	.usagefn = ipset_port_usage,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
  	ipset_type_add(&ipset_hash_ipport1);
  	ipset_type_add(&ipset_hash_ipport2);
+	ipset_type_add(&ipset_hash_ipport3);
  }
diff --git a/lib/ipset_hash_ipportip.c b/lib/ipset_hash_ipportip.c
index d5cf1d2..c1d17c8 100644
--- a/lib/ipset_hash_ipportip.c
+++ b/lib/ipset_hash_ipportip.c
@@ -316,9 +316,83 @@ static struct ipset_type ipset_hash_ipportip2 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_ipportip3 = {
+	.name = "hash:ip,port,ip",
+	.alias = { "ipportiphash", NULL },
+	.revision = 3,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_THREE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+		[IPSET_DIM_THREE - 1] = {
+			.parse = ipset_parse_single_ip,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipportip_create_args2,
+		[IPSET_ADD] = hash_ipportip_add_args2,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+
+	.usage = hash_ipportip_usage2,
+	.usagefn = ipset_port_usage,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
  	ipset_type_add(&ipset_hash_ipportip1);
  	ipset_type_add(&ipset_hash_ipportip2);
+	ipset_type_add(&ipset_hash_ipportip3);
  }
diff --git a/lib/ipset_hash_ipportnet.c b/lib/ipset_hash_ipportnet.c
index 2c2e014..359a532 100644
--- a/lib/ipset_hash_ipportnet.c
+++ b/lib/ipset_hash_ipportnet.c
@@ -544,6 +544,89 @@ static struct ipset_type ipset_hash_ipportnet4 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_ipportnet5 = {
+	.name = "hash:ip,port,net",
+	.alias = { "ipportnethash", NULL },
+	.revision = 5,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_THREE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_single6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+		[IPSET_DIM_THREE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_ipportnet_create_args4,
+		[IPSET_ADD] = hash_ipportnet_add_args4,
+		[IPSET_TEST] = hash_ipportnet_test_args4,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_ipportnet_usage4,
+	.usagefn = ipset_port_usage,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
@@ -551,4 +634,5 @@ void _init(void)
  	ipset_type_add(&ipset_hash_ipportnet2);
  	ipset_type_add(&ipset_hash_ipportnet3);
  	ipset_type_add(&ipset_hash_ipportnet4);
+	ipset_type_add(&ipset_hash_ipportnet5);
  }
diff --git a/lib/ipset_hash_net.c b/lib/ipset_hash_net.c
index a80d732..33dcd69 100644
--- a/lib/ipset_hash_net.c
+++ b/lib/ipset_hash_net.c
@@ -366,6 +366,54 @@ static struct ipset_type ipset_hash_net3 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_net4 = {
+	.name = "hash:net",
+	.alias = { "nethash", NULL },
+	.revision = 4,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_net_create_args3,
+		[IPSET_ADD] = hash_net_add_args3,
+		[IPSET_TEST] = hash_net_test_args3,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_net_usage3,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
@@ -373,4 +421,5 @@ void _init(void)
  	ipset_type_add(&ipset_hash_net1);
  	ipset_type_add(&ipset_hash_net2);
  	ipset_type_add(&ipset_hash_net3);
+	ipset_type_add(&ipset_hash_net4);
  }
diff --git a/lib/ipset_hash_netiface.c b/lib/ipset_hash_netiface.c
index d54b05a..7edcea6 100644
--- a/lib/ipset_hash_netiface.c
+++ b/lib/ipset_hash_netiface.c
@@ -400,6 +400,69 @@ static struct ipset_type ipset_hash_netiface3 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_netiface4 = {
+	.name = "hash:net,iface",
+	.alias = { "netifacehash", NULL },
+	.revision = 4,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_iface,
+			.print = ipset_print_iface,
+			.opt = IPSET_OPT_IFACE
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netiface_create_args3,
+		[IPSET_ADD] = hash_netiface_add_args3,
+		[IPSET_TEST] = hash_netiface_test_args3,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IFACE),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IFACE),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IFACE),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IFACE)
+			| IPSET_FLAG(IPSET_OPT_PHYSDEV)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IFACE)
+			| IPSET_FLAG(IPSET_OPT_PHYSDEV),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IFACE)
+			| IPSET_FLAG(IPSET_OPT_PHYSDEV)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netiface_usage3,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
@@ -407,4 +470,5 @@ void _init(void)
  	ipset_type_add(&ipset_hash_netiface1);
  	ipset_type_add(&ipset_hash_netiface2);
  	ipset_type_add(&ipset_hash_netiface3);
+	ipset_type_add(&ipset_hash_netiface4);
  }
diff --git a/lib/ipset_hash_netport.c b/lib/ipset_hash_netport.c
index 2b26cf2..3a84f79 100644
--- a/lib/ipset_hash_netport.c
+++ b/lib/ipset_hash_netport.c
@@ -437,6 +437,74 @@ static struct ipset_type ipset_hash_netport4 = {
  	.description = "counters support",
  };

+static struct ipset_type ipset_hash_netport5 = {
+	.name = "hash:net,port",
+	.alias = { "netporthash", NULL },
+	.revision = 5,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netport_create_args4,
+		[IPSET_ADD] = hash_netport_add_args4,
+		[IPSET_TEST] = hash_netport_test_args4,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_PORT),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netport_usage4,
+	.usagefn = ipset_port_usage,
+	.description = "inner flag support",
+};
+
  void _init(void);
  void _init(void)
  {
@@ -444,4 +512,5 @@ void _init(void)
  	ipset_type_add(&ipset_hash_netport2);
  	ipset_type_add(&ipset_hash_netport3);
  	ipset_type_add(&ipset_hash_netport4);
+	ipset_type_add(&ipset_hash_netport5);
  }
