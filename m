Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465D7F7EF
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706882000; cv=none; b=kNkrCQeP7aZ1aeurcBu0ta6Is3pmAzDKVoWCwQCW/hXQK+2FlrJg8hSU1Rw6COq1Bw2go2Hd5+/0IDPSERXu2S7o7AZ62W+ySXbsiCeS9xnYUkrsVu5ESGSGtc5Uhjk9zPQrEimhcYVDqOZk6FkvWgCsEzbcJM1tjnJmJNNwGFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706882000; c=relaxed/simple;
	bh=CW4A4aPJhi7XvLltcY634LycGGhVd1opR7LkXTkosCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqnQIKODnekZP1RXJINEWN7H2e6q2k1XsWr3sYI3J903iAIgLUqagIi8YzbZbs1ld8HsPLxEtPtDzi9r7JIfN94GSpgEFAqRnMrM599gHvbWM5GDgMY5tTGwGAU3rtarJO8CelC4YaMBReJXEoHleomB5blEBGXrXkB1AlxbnWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nRWggShv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nRWggShv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FqYvGh0cIM6CT3uQJ0A0Z9zUBa79p4eMErNyhntzAa8=; b=nRWggShvv07g/x1IGazymmsAAk
	Eex0KQ9HKbuTQCIl/LYZkvbF+uIxTxAQR7j4UGq5+djxB7KPnrXj6DTmgrQ98DCCbGhD9+KM+HAmP
	bkq7GIjbASMVkHGyBcXV7EIS4G9W0WhVng/bBZUEsIpIiE56IMxYNDKFBH3Zd7sQj0j3JeM744kI4
	bEAMF/xw5YpFHsUlxLeAzyhLZlGobwTQ2HJThukpuof7R0AUXZJlaUZD3sIZtwUrNCwghIPSKbW5D
	MrtmgCyUmRkPieuMpWMXf5y4ftx4TuU5suxijz1J3ZQetxMBC810aFwlEmuYIWe6YeQ6uAIxkClNt
	u8r+z+fA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyh-000000003Bl-3cPy;
	Fri, 02 Feb 2024 14:53:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 02/12] libxtables: xtoptions: Assert ranges are monotonic increasing
Date: Fri,  2 Feb 2024 14:52:57 +0100
Message-ID: <20240202135307.25331-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extensions commonly require the upper range value to be larger or equal
to the lower one. Performing this check in the parser is easier and
covers all extensions at once.

One notable exception is NFQUEUE which requires strict monotonicity.
Hence leave its checks in place.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_stp.c      | 21 +++++++++------------
 extensions/libip6t_ah.t      |  2 +-
 extensions/libip6t_frag.t    |  2 +-
 extensions/libip6t_rt.t      |  2 +-
 extensions/libipt_ah.t       |  2 +-
 extensions/libxt_connbytes.c |  4 ----
 extensions/libxt_conntrack.t |  2 +-
 extensions/libxt_esp.t       |  2 +-
 extensions/libxt_ipcomp.t    |  2 +-
 extensions/libxt_length.t    |  2 +-
 libxtables/xtoptions.c       |  9 +++++----
 11 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 371fa04c870fe..189e36a529f26 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -139,36 +139,33 @@ static void brstp_parse(struct xt_option_call *cb)
 		       cb->val.ethermacmask, ETH_ALEN);
 		break;
 
-#define RANGE_ASSIGN(name, fname, val) {				    \
+#define RANGE_ASSIGN(fname, val) {				    \
 		stpinfo->config.fname##l = val[0];			    \
 		stpinfo->config.fname##u = cb->nvals > 1 ? val[1] : val[0]; \
-		if (stpinfo->config.fname##u < stpinfo->config.fname##l)    \
-			xtables_error(PARAMETER_PROBLEM,		    \
-				      "Bad --stp-" name " range");	    \
 }
 	case O_RPRIO:
-		RANGE_ASSIGN("root-prio", root_prio, cb->val.u16_range);
+		RANGE_ASSIGN(root_prio, cb->val.u16_range);
 		break;
 	case O_RCOST:
-		RANGE_ASSIGN("root-cost", root_cost, cb->val.u32_range);
+		RANGE_ASSIGN(root_cost, cb->val.u32_range);
 		break;
 	case O_SPRIO:
-		RANGE_ASSIGN("sender-prio", sender_prio, cb->val.u16_range);
+		RANGE_ASSIGN(sender_prio, cb->val.u16_range);
 		break;
 	case O_PORT:
-		RANGE_ASSIGN("port", port, cb->val.u16_range);
+		RANGE_ASSIGN(port, cb->val.u16_range);
 		break;
 	case O_MSGAGE:
-		RANGE_ASSIGN("msg-age", msg_age, cb->val.u16_range);
+		RANGE_ASSIGN(msg_age, cb->val.u16_range);
 		break;
 	case O_MAXAGE:
-		RANGE_ASSIGN("max-age", max_age, cb->val.u16_range);
+		RANGE_ASSIGN(max_age, cb->val.u16_range);
 		break;
 	case O_HTIME:
-		RANGE_ASSIGN("hello-time", hello_time, cb->val.u16_range);
+		RANGE_ASSIGN(hello_time, cb->val.u16_range);
 		break;
 	case O_FWDD:
-		RANGE_ASSIGN("forward-delay", forward_delay, cb->val.u16_range);
+		RANGE_ASSIGN(forward_delay, cb->val.u16_range);
 		break;
 #undef RANGE_ASSIGN
 	}
diff --git a/extensions/libip6t_ah.t b/extensions/libip6t_ah.t
index 77c5383c91a6d..eeba7b451fc6d 100644
--- a/extensions/libip6t_ah.t
+++ b/extensions/libip6t_ah.t
@@ -18,4 +18,4 @@
 -m ah --ahspi :3;-m ah --ahspi 0:3;OK
 -m ah --ahspi 3:;-m ah --ahspi 3:4294967295;OK
 -m ah --ahspi 3:3;-m ah --ahspi 3;OK
--m ah --ahspi 4:3;=;OK
+-m ah --ahspi 4:3;;FAIL
diff --git a/extensions/libip6t_frag.t b/extensions/libip6t_frag.t
index a89076708ea03..57f7da27d5e1d 100644
--- a/extensions/libip6t_frag.t
+++ b/extensions/libip6t_frag.t
@@ -5,7 +5,7 @@
 -m frag --fragid 42:;-m frag --fragid 42:4294967295;OK
 -m frag --fragid 1:42;=;OK
 -m frag --fragid 3:3;-m frag --fragid 3;OK
--m frag --fragid 4:3;=;OK
+-m frag --fragid 4:3;;FAIL
 -m frag --fraglen 42;=;OK
 -m frag --fragres;=;OK
 -m frag --fragfirst;=;OK
diff --git a/extensions/libip6t_rt.t b/extensions/libip6t_rt.t
index 2699e800d528e..56c8b077267ce 100644
--- a/extensions/libip6t_rt.t
+++ b/extensions/libip6t_rt.t
@@ -8,4 +8,4 @@
 -m rt --rt-segsleft :3;-m rt --rt-segsleft 0:3;OK
 -m rt --rt-segsleft 3:;-m rt --rt-segsleft 3:4294967295;OK
 -m rt --rt-segsleft 3:3;-m rt --rt-segsleft 3;OK
--m rt --rt-segsleft 4:3;=;OK
+-m rt --rt-segsleft 4:3;;FAIL
diff --git a/extensions/libipt_ah.t b/extensions/libipt_ah.t
index a2aa338fef9c5..d86ede60970ac 100644
--- a/extensions/libipt_ah.t
+++ b/extensions/libipt_ah.t
@@ -16,4 +16,4 @@
 -p ah -m ah --ahspi :3;-p ah -m ah --ahspi 0:3;OK
 -p ah -m ah --ahspi 3:;-p ah -m ah --ahspi 3:4294967295;OK
 -p ah -m ah --ahspi 3:3;-p ah -m ah --ahspi 3;OK
--p ah -m ah --ahspi 4:3;=;OK
+-p ah -m ah --ahspi 4:3;;FAIL
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index b57f0fc0d28c2..2f1108572e8a9 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -41,10 +41,6 @@ static void connbytes_parse(struct xt_option_call *cb)
 		if (cb->nvals == 2)
 			sinfo->count.to = cb->val.u64_range[1];
 
-		if (sinfo->count.to < sinfo->count.from)
-			xtables_error(PARAMETER_PROBLEM, "%llu should be less than %llu",
-					(unsigned long long)sinfo->count.from,
-					(unsigned long long)sinfo->count.to);
 		if (cb->invert) {
 			i = sinfo->count.from;
 			sinfo->count.from = sinfo->count.to;
diff --git a/extensions/libxt_conntrack.t b/extensions/libxt_conntrack.t
index 399d70abbe707..620e7b5436e88 100644
--- a/extensions/libxt_conntrack.t
+++ b/extensions/libxt_conntrack.t
@@ -18,7 +18,7 @@
 -m conntrack --ctexpire 42949672956;;FAIL
 -m conntrack --ctexpire -1;;FAIL
 -m conntrack --ctexpire 3:3;-m conntrack --ctexpire 3;OK
--m conntrack --ctexpire 4:3;=;OK
+-m conntrack --ctexpire 4:3;;FAIL
 -m conntrack --ctdir ORIGINAL;=;OK
 -m conntrack --ctdir REPLY;=;OK
 -m conntrack --ctstatus NONE;=;OK
diff --git a/extensions/libxt_esp.t b/extensions/libxt_esp.t
index a8bc5287dd089..686611f22b457 100644
--- a/extensions/libxt_esp.t
+++ b/extensions/libxt_esp.t
@@ -10,6 +10,6 @@
 -p esp -m esp --espspi 4:;-p esp -m esp --espspi 4:4294967295;OK
 -p esp -m esp --espspi 3:4;=;OK
 -p esp -m esp --espspi 4:4;-p esp -m esp --espspi 4;OK
--p esp -m esp --espspi 4:3;=;OK
+-p esp -m esp --espspi 4:3;;FAIL
 -p esp -m esp;=;OK
 -m esp;;FAIL
diff --git a/extensions/libxt_ipcomp.t b/extensions/libxt_ipcomp.t
index f62144ae8fec8..375f885a708d9 100644
--- a/extensions/libxt_ipcomp.t
+++ b/extensions/libxt_ipcomp.t
@@ -7,4 +7,4 @@
 -p ipcomp -m ipcomp --ipcompspi 4:;-p ipcomp -m ipcomp --ipcompspi 4:4294967295;OK
 -p ipcomp -m ipcomp --ipcompspi 3:4;=;OK
 -p ipcomp -m ipcomp --ipcompspi 4:4;-p ipcomp -m ipcomp --ipcompspi 4;OK
--p ipcomp -m ipcomp --ipcompspi 4:3;=;OK
+-p ipcomp -m ipcomp --ipcompspi 4:3;;FAIL
diff --git a/extensions/libxt_length.t b/extensions/libxt_length.t
index 3905d2d05feec..bae313b4072c8 100644
--- a/extensions/libxt_length.t
+++ b/extensions/libxt_length.t
@@ -9,5 +9,5 @@
 -m length --length 0:65536;;FAIL
 -m length --length -1:65535;;FAIL
 -m length --length 4:4;-m length --length 4;OK
--m length --length 4:3;=;OK
+-m length --length 4:3;;FAIL
 -m length;;FAIL
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index f622f4c6ea328..cecf7d3526112 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -291,8 +291,8 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 	size_t esize = xtopt_esize_by_type(entry->type);
 	const uintmax_t lmax = xtopt_max_by_type(entry->type);
 	void *put = XTOPT_MKPTR(cb);
+	uintmax_t value, lmin = 0;
 	unsigned int maxiter;
-	uintmax_t value;
 	char *end = "";
 	char sep = ':';
 
@@ -314,16 +314,17 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 			end = (char *)arg;
 			value = (cb->nvals == 1) ? lmax : 0;
 		} else {
-			if (!xtables_strtoul(arg, &end, &value, 0, lmax))
+			if (!xtables_strtoul(arg, &end, &value, lmin, lmax))
 				xt_params->exit_err(PARAMETER_PROBLEM,
 					"%s: bad value for option \"--%s\" near "
-					"\"%s\", or out of range (0-%ju).\n",
-					cb->ext_name, entry->name, arg, lmax);
+					"\"%s\", or out of range (%ju-%ju).\n",
+					cb->ext_name, entry->name, arg, lmin, lmax);
 			if (*end != '\0' && *end != sep)
 				xt_params->exit_err(PARAMETER_PROBLEM,
 					"%s: Argument to \"--%s\" has "
 					"unexpected characters near \"%s\".\n",
 					cb->ext_name, entry->name, end);
+			lmin = value;
 		}
 		xtopt_mint_value_to_cb(cb, value);
 		++cb->nvals;
-- 
2.43.0

