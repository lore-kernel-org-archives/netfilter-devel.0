Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ea7pV/Ok"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E1F85
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BgjE3LazCOEi/oVaZwc7f/T2/TeTz0xpQM6b/3Mkj1U=; b=ea7pV/OkDDh7T79JIo/Q5puYuN
	I9EJyhHGzaCl3xeJCeffOnBj2+JG8P9K/ciszQJE9beAYCwe7LdNVlBDp1DNsDE6e2oVQlstKTBDe
	yORGV5hlz3FHTaApsU8DS7b052GDdgm/amIcjuT0CwINiyGqa2Y6WnKxEhcFWwQ+hmuM5GUwadSni
	ysLMA7kaTiQ2vk1gFYSx82mwzMZDxoZMA9CMfR9rZfN1T+0hQLaxorYfJL9vWf0EJJIjlWQeSvLvl
	yYS3c3Cl0xNjGfpufRVjMJksNBcYfIRfbH0/Zj2Qv974XnrlpKz0G/zuPqCcI6OaBsHrx2O8zeynW
	67O3W14g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPh-0001iq-EY
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/13] xshared: Perform protocol value parsing in callback
Date: Wed, 29 Nov 2023 14:28:16 +0100
Message-ID: <20231129132827.18166-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code is same in iptables and ip6tables, but different in ebtables.
Therefore move it into the callback to keep that part of do_parse()
generic.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 22 ++++++++++++++--------
 iptables/xshared.h |  1 -
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 53e6720169950..ff809f2be3438 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1547,12 +1547,6 @@ void do_parse(int argc, char *argv[],
 				*cs->protocol = tolower(*cs->protocol);
 
 			cs->protocol = optarg;
-			args->proto = xtables_parse_protocol(cs->protocol);
-
-			if (args->proto == 0 &&
-			    (args->invflags & XT_INV_PROTO))
-				xtables_error(PARAMETER_PROBLEM,
-					   "rule would never match protocol");
 
 			/* This needs to happen here to parse extensions */
 			if (p->ops->proto_parse)
@@ -1865,7 +1859,13 @@ void do_parse(int argc, char *argv[],
 void ipv4_proto_parse(struct iptables_command_state *cs,
 		      struct xtables_args *args)
 {
-	cs->fw.ip.proto = args->proto;
+	cs->fw.ip.proto = xtables_parse_protocol(cs->protocol);
+
+	if (cs->fw.ip.proto == 0 &&
+	    (args->invflags & XT_INV_PROTO))
+		xtables_error(PARAMETER_PROBLEM,
+			      "rule would never match protocol");
+
 	cs->fw.ip.invflags = args->invflags;
 }
 
@@ -1881,7 +1881,13 @@ static int is_exthdr(uint16_t proto)
 void ipv6_proto_parse(struct iptables_command_state *cs,
 		      struct xtables_args *args)
 {
-	cs->fw6.ipv6.proto = args->proto;
+	cs->fw6.ipv6.proto = xtables_parse_protocol(cs->protocol);
+
+	if (cs->fw6.ipv6.proto == 0 &&
+	    (args->invflags & XT_INV_PROTO))
+		xtables_error(PARAMETER_PROBLEM,
+			      "rule would never match protocol");
+
 	cs->fw6.ipv6.invflags = args->invflags;
 
 	/* this is needed for ip6tables-legacy only */
diff --git a/iptables/xshared.h b/iptables/xshared.h
index d2ce72e90824a..3df2153fd6a10 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -249,7 +249,6 @@ struct addr_mask {
 
 struct xtables_args {
 	int		family;
-	uint16_t	proto;
 	uint8_t		flags;
 	uint16_t	invflags;
 	char		iniface[IFNAMSIZ], outiface[IFNAMSIZ];
-- 
2.41.0

