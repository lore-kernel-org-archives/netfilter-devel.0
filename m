From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 1/2] datatype: Replace getnameinfo() by internal
 lookup table
Date: Mon, 28 Nov 2016 18:20:10 -0200
Message-ID: <20161128202009.GA8734@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35858 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbcK1UUR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 15:20:17 -0500
Received: by mail-vk0-f65.google.com with SMTP id w194so5750020vkw.3
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:20:17 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To avoid exceeding the inputs number limit of the flex scanner used,
when calling getnameinfo() in inet_service_type_print().

The new symbol_table was associated with inet_service_type, to enable
listing all pre-defined services using nft command line tool.

The listed services are all well-known and registered ports of my
local /etc/services file, from Ubuntu 16.04. Service numbers are
converted to respect network byte order.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: Used symbol_table to list the services and put them in another
 file. Also used network byte order on service values to replace
 nft_service_lookup with symbolic_constant_print.

 v3: No change

 include/datatype.h |   2 +
 src/Makefile.am    |   1 +
 src/datatype.c     |  15 +--
 src/services.c     | 343 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 348 insertions(+), 13 deletions(-)
 create mode 100644 src/services.c

diff --git a/include/datatype.h b/include/datatype.h
index 9f3f711..e53797d 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -185,6 +185,8 @@ struct symbol_table {
 	struct symbolic_constant	symbols[];
 };
 
+extern const struct symbol_table serv_tbl;
+
 extern struct error_record *symbolic_constant_parse(const struct expr *sym,
 						    const struct symbol_table *tbl,
 						    struct expr **res);
diff --git a/src/Makefile.am b/src/Makefile.am
index d021cb7..2a69e19 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -52,6 +52,7 @@ nft_SOURCES =	main.c				\
 		erec.c				\
 		mnl.c				\
 		iface.c				\
+		services.c			\
 		scanner.l			\
 		parser_bison.y
 
diff --git a/src/datatype.c b/src/datatype.c
index 1e40287..1ae7db4 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -559,19 +559,7 @@ const struct datatype inet_protocol_type = {
 
 static void inet_service_type_print(const struct expr *expr)
 {
-	struct sockaddr_in sin = { .sin_family = AF_INET };
-	char buf[NI_MAXSERV];
-	int err;
-
-	sin.sin_port = mpz_get_be16(expr->value);
-	err = getnameinfo((struct sockaddr *)&sin, sizeof(sin), NULL, 0,
-			  buf, sizeof(buf),
-			  numeric_output < NUMERIC_PORT ? 0 : NI_NUMERICSERV);
-	if (err != 0) {
-		getnameinfo((struct sockaddr *)&sin, sizeof(sin), NULL,
-			    0, buf, sizeof(buf), NI_NUMERICSERV);
-	}
-	printf("%s", buf);
+	symbolic_constant_print(&serv_tbl, expr, false);
 }
 
 static struct error_record *inet_service_type_parse(const struct expr *sym,
@@ -615,6 +603,7 @@ const struct datatype inet_service_type = {
 	.basetype	= &integer_type,
 	.print		= inet_service_type_print,
 	.parse		= inet_service_type_parse,
+	.sym_tbl	= &serv_tbl,
 };
 
 #define RT_SYM_TAB_INITIAL_SIZE		16
diff --git a/src/services.c b/src/services.c
new file mode 100644
index 0000000..8cb1cdf
--- /dev/null
+++ b/src/services.c
@@ -0,0 +1,343 @@
+#include <nftables.h>
+#include <datatype.h>
+
+const struct symbol_table serv_tbl = {
+	.symbols =	{
+		SYMBOL("exec",	2),
+		SYMBOL("tcpmux",	256),
+		SYMBOL("login",	258),
+		SYMBOL("nfs",	264),
+		SYMBOL("f5-iquery",	273),
+		SYMBOL("wnn6",	343),
+		SYMBOL("shell",	514),
+		SYMBOL("printer",	770),
+		SYMBOL("talk",	1282),
+		SYMBOL("knetd",	1288),
+		SYMBOL("ntalk",	1538),
+		SYMBOL("echo",	1792),
+		SYMBOL("moira-db",	1795),
+		SYMBOL("route",	2050),
+		SYMBOL("discard",	2304),
+		SYMBOL("moira-update",	2307),
+		SYMBOL("systat",	2816),
+		SYMBOL("moira-ureg",	2819),
+		SYMBOL("ircd",	2842),
+		SYMBOL("daytime",	3328),
+		SYMBOL("timed",	3330),
+		SYMBOL("tempo",	3586),
+		SYMBOL("netstat",	3840),
+		SYMBOL("spamd",	3843),
+		SYMBOL("webmin",	4135),
+		SYMBOL("qotd",	4352),
+		SYMBOL("epmd",	4369),
+		SYMBOL("msp",	4608),
+		SYMBOL("courier",	4610),
+		SYMBOL("chargen",	4864),
+		SYMBOL("conference",	4866),
+		SYMBOL("ftp-data",	5120),
+		SYMBOL("netnews",	5122),
+		SYMBOL("wipld",	5125),
+		SYMBOL("radius",	5127),
+		SYMBOL("ftp",	5376),
+		SYMBOL("netwall",	5378),
+		SYMBOL("radius-acct",	5383),
+		SYMBOL("remctl",	5393),
+		SYMBOL("ssh",	5632),
+		SYMBOL("telnet",	5888),
+		SYMBOL("mon",	5898),
+		SYMBOL("smtp",	6400),
+		SYMBOL("gdomap",	6658),
+		SYMBOL("uucp",	7170),
+		SYMBOL("clc-build-daemon",	7715),
+		SYMBOL("klogin",	7938),
+		SYMBOL("pcrd",	7956),
+		SYMBOL("kshell",	8194),
+		SYMBOL("xtel",	8453),
+		SYMBOL("dhcpv6-client",	8706),
+		SYMBOL("xtelw",	8709),
+		SYMBOL("nrpe",	8726),
+		SYMBOL("dhcpv6-server",	8962),
+		SYMBOL("radmin-port",	8979),
+		SYMBOL("nsca",	8982),
+		SYMBOL("afpovertcp",	9218),
+		SYMBOL("time",	9472),
+		SYMBOL("idfp",	9474),
+		SYMBOL("gnunet",	9736),
+		SYMBOL("rlp",	9984),
+		SYMBOL("amqps",	10006),
+		SYMBOL("omirr",	10243),
+		SYMBOL("zebrasrv",	10250),
+		SYMBOL("amqp",	10262),
+		SYMBOL("zebra",	10506),
+		SYMBOL("nameserver",	10752),
+		SYMBOL("rtsp",	10754),
+		SYMBOL("ripd",	10762),
+		SYMBOL("mrtd",	10774),
+		SYMBOL("whois",	11008),
+		SYMBOL("ripngd",	11018),
+		SYMBOL("bgpsim",	11030),
+		SYMBOL("isdnlog",	11086),
+		SYMBOL("remotefs",	11266),
+		SYMBOL("ospfd",	11274),
+		SYMBOL("sge-qmaster",	11289),
+		SYMBOL("vboxd",	11342),
+		SYMBOL("bgpd",	11530),
+		SYMBOL("sge-execd",	11545),
+		SYMBOL("ospf6d",	11786),
+		SYMBOL("mysql-proxy",	11801),
+		SYMBOL("ospfapi",	12042),
+		SYMBOL("isisd",	12298),
+		SYMBOL("distcc",	12302),
+		SYMBOL("canna",	12310),
+		SYMBOL("tacacs",	12544),
+		SYMBOL("re-mail-ck",	12800),
+		SYMBOL("nntps",	13058),
+		SYMBOL("domain",	13568),
+		SYMBOL("rtcm-sc104",	13576),
+		SYMBOL("zephyr-srv",	13832),
+		SYMBOL("zephyr-clt",	14088),
+		SYMBOL("socks",	14340),
+		SYMBOL("zephyr-hm",	14344),
+		SYMBOL("postgresql",	14357),
+		SYMBOL("ggz",	14358),
+		SYMBOL("mtp",	14592),
+		SYMBOL("eklogin",	14600),
+		SYMBOL("nbd",	14634),
+		SYMBOL("icpv2",	14860),
+		SYMBOL("kx",	16136),
+		SYMBOL("tacacs-ds",	16640),
+		SYMBOL("zabbix-agent",	16935),
+		SYMBOL("bootps",	17152),
+		SYMBOL("zabbix-trapper",	17191),
+		SYMBOL("bootpc",	17408),
+		SYMBOL("dict",	17418),
+		SYMBOL("tftp",	17664),
+		SYMBOL("proofd",	17668),
+		SYMBOL("gopher",	17920),
+		SYMBOL("rootd",	17924),
+		SYMBOL("aol",	17940),
+		SYMBOL("msnp",	18183),
+		SYMBOL("gsigatekeeper",	18184),
+		SYMBOL("lotusnote",	18437),
+		SYMBOL("iprop",	18696),
+		SYMBOL("submission",	19202),
+		SYMBOL("rmiregistry",	19204),
+		SYMBOL("rje",	19712),
+		SYMBOL("finger",	20224),
+		SYMBOL("http",	20480),
+		SYMBOL("mtn",	21266),
+		SYMBOL("kpop",	21764),
+		SYMBOL("munin",	21779),
+		SYMBOL("zope-ftp",	21791),
+		SYMBOL("link",	22272),
+		SYMBOL("gris",	22280),
+		SYMBOL("kerberos",	22528),
+		SYMBOL("afs3-fileserver",	22555),
+		SYMBOL("pawserv",	22785),
+		SYMBOL("afs3-callback",	22811),
+		SYMBOL("zserv",	23041),
+		SYMBOL("afs3-prserver",	23067),
+		SYMBOL("fatserv",	23297),
+		SYMBOL("afs3-vlserver",	23323),
+		SYMBOL("afs3-kaserver",	23579),
+		SYMBOL("db-lsp",	23620),
+		SYMBOL("afs3-volser",	23835),
+		SYMBOL("sieve",	24080),
+		SYMBOL("afs3-errors",	24091),
+		SYMBOL("supdup",	24320),
+		SYMBOL("nqs",	24322),
+		SYMBOL("afs3-bos",	24347),
+		SYMBOL("afs3-update",	24603),
+		SYMBOL("amanda",	24615),
+		SYMBOL("cvspserver",	24841),
+		SYMBOL("afs3-rmtsys",	24859),
+		SYMBOL("kamanda",	24871),
+		SYMBOL("linuxconf",	25088),
+		SYMBOL("npmp-local",	25090),
+		SYMBOL("amandaidx",	25127),
+		SYMBOL("npmp-gui",	25346),
+		SYMBOL("amidxtape",	25383),
+		SYMBOL("hmmp-ind",	25602),
+		SYMBOL("hostnames",	25856),
+		SYMBOL("iso-tsap",	26112),
+		SYMBOL("ninstall",	26120),
+		SYMBOL("xmpp-client",	26132),
+		SYMBOL("supfilesrv",	26371),
+		SYMBOL("supfiledbg",	26372),
+		SYMBOL("acr-nema",	26624),
+		SYMBOL("dicom",	26667),
+		SYMBOL("csnet-ns",	26880),
+		SYMBOL("rsync",	26883),
+		SYMBOL("daap",	26894),
+		SYMBOL("sgi-cmsd",	26946),
+		SYMBOL("poppassd",	27136),
+		SYMBOL("svn",	27150),
+		SYMBOL("sgi-crsd",	27202),
+		SYMBOL("rtelnet",	27392),
+		SYMBOL("hkp",	27436),
+		SYMBOL("sgi-gcd",	27458),
+		SYMBOL("sgi-cad",	27714),
+		SYMBOL("pop2",	27904),
+		SYMBOL("datametrics",	27910),
+		SYMBOL("dcap",	27990),
+		SYMBOL("pop3",	28160),
+		SYMBOL("sa-msg-port",	28166),
+		SYMBOL("sunrpc",	28416),
+		SYMBOL("asf-rmcp",	28418),
+		SYMBOL("x11",	28695),
+		SYMBOL("gsidcap",	28758),
+		SYMBOL("auth",	28928),
+		SYMBOL("rpc2portmap",	28929),
+		SYMBOL("kermit",	28934),
+		SYMBOL("x11-1",	28951),
+		SYMBOL("codaauth2",	29185),
+		SYMBOL("x11-2",	29207),
+		SYMBOL("syslog-tls",	29209),
+		SYMBOL("sftp",	29440),
+		SYMBOL("clearcase",	29441),
+		SYMBOL("x11-3",	29463),
+		SYMBOL("ulistserv",	29697),
+		SYMBOL("qmqp",	29698),
+		SYMBOL("x11-4",	29719),
+		SYMBOL("uucp-path",	29952),
+		SYMBOL("x11-5",	29975),
+		SYMBOL("x11-6",	30231),
+		SYMBOL("nntp",	30464),
+		SYMBOL("ipp",	30466),
+		SYMBOL("x11-7",	30487),
+		SYMBOL("ntp",	31488),
+		SYMBOL("ldaps",	31746),
+		SYMBOL("venus",	32265),
+		SYMBOL("venus-se",	32521),
+		SYMBOL("codasrv",	32777),
+		SYMBOL("xtell",	32784),
+		SYMBOL("pwdgen",	33024),
+		SYMBOL("codasrv-se",	33033),
+		SYMBOL("gpsd",	33547),
+		SYMBOL("ldap",	34049),
+		SYMBOL("swat",	34051),
+		SYMBOL("loc-srv",	34560),
+		SYMBOL("netbios-ns",	35072),
+		SYMBOL("netbios-dgm",	35328),
+		SYMBOL("rfe",	35347),
+		SYMBOL("xinetd",	35363),
+		SYMBOL("netbios-ssn",	35584),
+		SYMBOL("groupwise",	36102),
+		SYMBOL("bacula-dir",	36131),
+		SYMBOL("bacula-fd",	36387),
+		SYMBOL("imap2",	36608),
+		SYMBOL("tinc",	36610),
+		SYMBOL("bacula-sd",	36643),
+		SYMBOL("mandelspawn",	36644),
+		SYMBOL("http-alt",	36895),
+		SYMBOL("tproxy",	37151),
+		SYMBOL("csync2",	37240),
+		SYMBOL("ipsec-nat-t",	37905),
+		SYMBOL("xmpp-server",	38164),
+		SYMBOL("imsp",	38401),
+		SYMBOL("omniorb",	38943),
+		SYMBOL("bprd",	38965),
+		SYMBOL("ms-sql-s",	39173),
+		SYMBOL("bpdbm",	39221),
+		SYMBOL("skkserv",	39428),
+		SYMBOL("ms-sql-m",	39429),
+		SYMBOL("bpjava-msvc",	39477),
+		SYMBOL("vnetd",	39989),
+		SYMBOL("snmp",	41216),
+		SYMBOL("snmp-trap",	41472),
+		SYMBOL("cmip-man",	41728),
+		SYMBOL("cmip-agent",	41984),
+		SYMBOL("l2f",	42246),
+		SYMBOL("unix-status",	42247),
+		SYMBOL("nut",	42253),
+		SYMBOL("log-server",	42503),
+		SYMBOL("sane-port",	42521),
+		SYMBOL("remoteping",	42759),
+		SYMBOL("openvpn",	43524),
+		SYMBOL("svrloc",	43777),
+		SYMBOL("afbackup",	44043),
+		SYMBOL("afmbackup",	44299),
+		SYMBOL("mailq",	44544),
+		SYMBOL("xdmcp",	45312),
+		SYMBOL("nextstep",	45568),
+		SYMBOL("bgp",	45824),
+		SYMBOL("rplay",	45845),
+		SYMBOL("freeciv",	46101),
+		SYMBOL("predict",	47620),
+		SYMBOL("mmcc",	47635),
+		SYMBOL("https",	47873),
+		SYMBOL("enbd-cstatd",	47891),
+		SYMBOL("snpp",	48129),
+		SYMBOL("iscsi-target",	48140),
+		SYMBOL("enbd-sstatd",	48147),
+		SYMBOL("cfengine",	48148),
+		SYMBOL("font-service",	48155),
+		SYMBOL("microsoft-ds",	48385),
+		SYMBOL("kazaa",	48644),
+		SYMBOL("prospero",	48896),
+		SYMBOL("suucp",	48911),
+		SYMBOL("smsqp",	49451),
+		SYMBOL("irc",	49664),
+		SYMBOL("silc",	49666),
+		SYMBOL("xmms2",	49957),
+		SYMBOL("sip",	50195),
+		SYMBOL("sip-tls",	50451),
+		SYMBOL("smux",	50944),
+		SYMBOL("at-rtmp",	51456),
+		SYMBOL("zope",	51493),
+		SYMBOL("at-nbp",	51712),
+		SYMBOL("gnutella-svc",	51736),
+		SYMBOL("git",	51748),
+		SYMBOL("gnutella-rtr",	51992),
+		SYMBOL("at-echo",	52224),
+		SYMBOL("fax",	52497),
+		SYMBOL("at-zis",	52736),
+		SYMBOL("hylafax",	53009),
+		SYMBOL("kpasswd",	53249),
+		SYMBOL("cisco-sccp",	53255),
+		SYMBOL("qmtp",	53504),
+		SYMBOL("urd",	53505),
+		SYMBOL("z3950",	53760),
+		SYMBOL("cfinger",	54023),
+		SYMBOL("rmtcfg",	54276),
+		SYMBOL("ipx",	54528),
+		SYMBOL("bpcd",	54837),
+		SYMBOL("vopied",	55093),
+		SYMBOL("nessus",	55556),
+		SYMBOL("iax",	55569),
+		SYMBOL("search",	55815),
+		SYMBOL("imap3",	56320),
+		SYMBOL("ftps-data",	56579),
+		SYMBOL("ftps",	56835),
+		SYMBOL("telnets",	57347),
+		SYMBOL("imaps",	57603),
+		SYMBOL("ircs",	57859),
+		SYMBOL("pop3s",	58115),
+		SYMBOL("saft",	59137),
+		SYMBOL("f5-globalsite",	59402),
+		SYMBOL("customs",	59651),
+		SYMBOL("mdns",	59668),
+		SYMBOL("gds-db",	59915),
+		SYMBOL("mysql",	59916),
+		SYMBOL("noclog",	59924),
+		SYMBOL("binkp",	59999),
+		SYMBOL("hostmon",	60180),
+		SYMBOL("kerberos-adm",	60674),
+		SYMBOL("kerberos4",	60930),
+		SYMBOL("asp",	61034),
+		SYMBOL("kerberos-master",	61186),
+		SYMBOL("passwd-server",	61442),
+		SYMBOL("xpilot",	61755),
+		SYMBOL("krb-prop",	61954),
+		SYMBOL("isakmp",	62465),
+		SYMBOL("ingreslock",	62469),
+		SYMBOL("prospero-np",	62725),
+		SYMBOL("krbupdate",	63490),
+		SYMBOL("distmp3",	63505),
+		SYMBOL("support",	63749),
+		SYMBOL("gsiftp",	64266),
+		SYMBOL("webster",	64770),
+		SYMBOL("sysrqd",	65039),
+		SYMBOL_LIST_END
+	},
+};
-- 
2.7.4

