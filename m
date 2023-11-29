Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pXEg4erX"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC798D7F
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=93FZ81YMjx38BgShSrEX+i3cU71Z+4T6pfE8YPZcuN8=; b=pXEg4erXS92dPXZ9YD006JhaEF
	D3Eu3xkn3L7BcTix27IPA/TA/fRc6csa3JuqXpvnX7DP30m3a65Yhkz5IQkaLcx4Ii5XEYT2+Iab3
	dzmsDqKzi8AbBZqRn5UZjpPyACwcQdhAT0sxyTmA78wi+eYdggmzmU6rndiM6ZxsSQ49UYX3ig0zl
	U3ofs0ONtb++C56QKVsjCpb16xlqFcSb3YgVhxeybS9dblO8RK9plJ+/sjhfLmdpNoggwH7P+4CeY
	tnJIXo7ZzwmogTJkPpjUuZTEN47PcYNxA/EU4fIlssP4ybChNoJZyjNA8LL2LCgR3Zfqb16lkguNx
	g44hSGkw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPl-0001jS-3r
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/13] xshared: Introduce option_test_and_reject()
Date: Wed, 29 Nov 2023 14:28:26 +0100
Message-ID: <20231129132827.18166-13-phil@nwl.cc>
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

Just a small helper eliminating the repetitive code there.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 50f23757d4aff..ebe172223486e 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1439,6 +1439,15 @@ static void parse_change_counters_rule(int argc, char **argv,
 			      "Packet counter '%s' invalid", argv[optind - 1]);
 }
 
+static void option_test_and_reject(struct xt_cmd_parse *p,
+				   struct iptables_command_state *cs,
+				   unsigned int option)
+{
+	if (cs->options & option)
+		xtables_error(PARAMETER_PROBLEM, "Can't use %s with %s",
+			      p->ops->option_name(option), p->chain);
+}
+
 void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
@@ -1924,21 +1933,13 @@ void do_parse(int argc, char *argv[],
 		if (strcmp(p->chain, "PREROUTING") == 0
 		    || strcmp(p->chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
-			if (cs->options & OPT_VIANAMEOUT)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Can't use %s with %s\n",
-					      p->ops->option_name(OPT_VIANAMEOUT),
-					      p->chain);
+			option_test_and_reject(p, cs, OPT_VIANAMEOUT);
 		}
 
 		if (strcmp(p->chain, "POSTROUTING") == 0
 		    || strcmp(p->chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
-			if (cs->options & OPT_VIANAMEIN)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Can't use %s with %s\n",
-					      p->ops->option_name(OPT_VIANAMEIN),
-					      p->chain);
+			option_test_and_reject(p, cs, OPT_VIANAMEIN);
 		}
 	}
 }
-- 
2.41.0

