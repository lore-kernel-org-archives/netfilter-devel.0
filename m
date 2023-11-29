Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iDz7kGdS"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB2BD68
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z7Xe+vB7HcXssf9unKSAeNbJnWNwd0tPHNJqRh2JpVc=; b=iDz7kGdSmgBsrjd4HOOPs2OJ1i
	c6ZVWeRnfZiThLeYK476daWt5mbxDGclQe/OgSN/2mfkT+r5xKu0ESVGNVC2utQY9E7cCZI3hS6XU
	7FaE1S78lQShwsjb8fDoclIU7lTzCRYJCpxCr3v4wf8RboECbqbK+og/mv73dynyvyPcL/KoFuSbF
	ee88b0ttfdIU7BsbgZ7t+He/MlEw7+Qz7RKC0MpAQpj+O2iqoCK3yWMiO0TarbqqvTxvJ07KiVm+P
	J/3aK+YpC0kcWL7miP+w0gRHNRQHA0jrKK/TC1wzdEXPmU3B6+KL/udgT0u4yvTESTE53FXoDUcrL
	wGk006Qw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPk-0001jK-BA
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/13] ebtables: Pass struct iptables_command_state to print_help()
Date: Wed, 29 Nov 2023 14:28:23 +0100
Message-ID: <20231129132827.18166-10-phil@nwl.cc>
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

Parameters passed by the sole caller came from there already, apart from
'table' which is not used (ebtables-nft does not have per-table help
texts).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 9afaa614bac5b..017e1ad364840 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -303,9 +303,11 @@ static struct option *merge_options(struct option *oldopts,
 	return merge;
 }
 
-static void print_help(const struct xtables_target *t,
-		       const struct xtables_rule_match *m, const char *table)
+static void print_help(struct iptables_command_state *cs)
 {
+	const struct xtables_rule_match *m = cs->matches;
+	struct xtables_target *t = cs->target;
+
 	printf("%s %s\n", prog_name, prog_vers);
 	printf(
 "Usage:\n"
@@ -354,9 +356,6 @@ static void print_help(const struct xtables_target *t,
 		printf("\n");
 		t->help();
 	}
-
-//	if (table->help)
-//		table->help(ebt_hooknames);
 }
 
 /* Execute command L */
@@ -1144,7 +1143,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		ebt_print_error2("Bad table name");*/
 
 	if (command == 'h' && !(flags & OPT_ZERO)) {
-		print_help(cs.target, cs.matches, *table);
+		print_help(&cs);
 		ret = 1;
 	}
 
-- 
2.41.0

