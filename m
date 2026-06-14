Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E18171BB;
	Sun, 14 Jun 2026 05:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781414732; cv=none; b=q7v3FLQPBLnC43uE4MNUsS8EF/t4rTdsq3G8z7XAVbNBk2xqU0w1vThPvgQMa8u7z/2OA+pOhIBv19cRch/IERQmTvwbr8YNP5vlzR4xovgotuLVAi2tbuj4n3VT7tCS/AMCC0cU2oS85cRYeQSe3VS8oPUag11ABX3z0ilY2qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781414732; c=relaxed/simple;
	bh=Wsq6G7fZ7O8DVr+ZbnYMsBrFbnCcXsEYcTaM0JO/9vc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UjZQdczv3B+FX/zySRBwqqwc1JuoUr8tRdtWJf5Mjwk9Duwe3iVofCe/3lHCOKttRXrcPQPKdl/ICPn5hZQO6KXtFObLgB+cJSDFYZzDcWtndG3aeMg454ya/bpfVE8VnFPM07cBhZKPK7DH2HfEIlX1+QJ00W7/+yQU/Vr5jJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3W8h2lHU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3W8h2lHU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4D/iiY0jnzk08BanLlMnRV0PRyLRiwG/H5ijrGY/r/g=; b=3W8h2lHU/a6ayN8kUYZn8n1EaI
	wug78Tg3UE41ZDH7eDo8pIKrzhnlB4TpB3GbSo6U0v8XCHjKTyOIqSiDHZI3SZeDUTZd/T5QUZqnI
	fSH+mofROwGAbXFdqPJjQ9pm6eVwl00+QPCxpXTRPiMx4XjXJ6SPxYlLNg+gQIidT8NPu5ggIjbcu
	giIkddT+ZBb+Nm4O42SiqCRG2qKbMqLq/tF+XjU5IKm3ECfZA7JGqi8IgnHoAtgfCoJ1RZBigQmTv
	2IR7jFDNFAA+bgaSj1zw8lrtVGIFJ0aC/s1oCbD/bZxPOSeW4be6Ho0o6zMabPmecN1TtD8psbhOc
	PipUyvUw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wYdLb-0000000ClDr-0Qun;
	Sun, 14 Jun 2026 05:25:27 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next] netfilter: x_tables.h: fix all kernel-doc warnings
Date: Sat, 13 Jun 2026 22:25:24 -0700
Message-ID: <20260614052524.1559494-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- use correct names in kernel-doc comments
- add missing struct members to kernel-doc comments

Warning: include/linux/netfilter/x_tables.h:41 struct member 'targinfo' not described in 'xt_action_param'
Warning: include/linux/netfilter/x_tables.h:41 Excess struct member 'targetinfo' description in 'xt_action_param'
Warning: include/linux/netfilter/x_tables.h:90 struct member 'family' not described in 'xt_mtchk_param'
Warning: include/linux/netfilter/x_tables.h:90 struct member 'nft_compat' not described in 'xt_mtchk_param'
Warning: include/linux/netfilter/x_tables.h:101 expecting prototype for struct xt_mdtor_param. Prototype was for struct xt_mtdtor_param instead

Warning: include/linux/netfilter/x_tables.h:121 struct member 'net' not described in 'xt_tgchk_param'
Warning: include/linux/netfilter/x_tables.h:121 struct member 'table' not described in 'xt_tgchk_param'
Warning: include/linux/netfilter/x_tables.h:121 struct member 'target' not described in 'xt_tgchk_param'
Warning: include/linux/netfilter/x_tables.h:121 struct member 'targinfo' not described in 'xt_tgchk_param'
Warning: include/linux/netfilter/x_tables.h:121 struct member 'hook_mask' not described in 'xt_tgchk_param'
Warning: include/linux/netfilter/x_tables.h:121 struct member 'family' not described in 'xt_tgchk_param'
Warning: include/linux/netfilter/x_tables.h:121 struct member 'nft_compat' not described in 'xt_tgchk_param'

Warning: include/linux/netfilter/x_tables.h:345 expecting prototype for xt_recseq(). Prototype was for DECLARE_PER_CPU() instead

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org

 include/linux/netfilter/x_tables.h |   29 +++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- linext-2026-0610.orig/include/linux/netfilter/x_tables.h
+++ linext-2026-0610/include/linux/netfilter/x_tables.h
@@ -18,7 +18,7 @@
  * @match:	the match extension
  * @target:	the target extension
  * @matchinfo:	per-match data
- * @targetinfo:	per-target data
+ * @targinfo:	per-target data
  * @state:	pointer to hook state this packet came from
  * @fragoff:	packet is a fragment, this is the data offset
  * @thoff:	position of transport header relative to skb->data
@@ -77,7 +77,9 @@ static inline u_int8_t xt_family(const s
  * @match:	struct xt_match through which this function was invoked
  * @matchinfo:	per-match data
  * @hook_mask:	via which hooks the new rule is reachable
- * Other fields as above.
+ * @family:	actual NFPROTO_* through which the function is invoked
+ *		(helpful when match->family == NFPROTO_UNSPEC)
+ * @nft_compat:	running from the nft compat layer if true
  */
 struct xt_mtchk_param {
 	struct net *net;
@@ -91,8 +93,13 @@ struct xt_mtchk_param {
 };
 
 /**
- * struct xt_mdtor_param - match destructor parameters
- * Fields as above.
+ * struct xt_mtdtor_param - match destructor parameters
+ *
+ * @net:	network namespace through which the check was invoked
+ * @match:	struct xt_match through which this function was invoked
+ * @matchinfo:	per-match data
+ * @family:	actual NFPROTO_* through which the function is invoked
+ *		(helpful when match->family == NFPROTO_UNSPEC)
  */
 struct xt_mtdtor_param {
 	struct net *net;
@@ -105,10 +112,16 @@ struct xt_mtdtor_param {
  * struct xt_tgchk_param - parameters for target extensions'
  * checkentry functions
  *
+ * @net:	network namespace through which the check was invoked
+ * @table:	table the rule is tried to be inserted into
  * @entryinfo:	the family-specific rule data
  * 		(struct ipt_entry, ip6t_entry, arpt_entry, ebt_entry)
- *
- * Other fields see above.
+ * @target:	the target extension
+ * @targinfo:	per-target data
+ * @hook_mask:	via which hooks the new rule is reachable
+ * @family:	actual NFPROTO_* through which the function is invoked
+ *		(helpful when match->family == NFPROTO_UNSPEC)
+ * @nft_compat:	running from the nft compat layer if true
  */
 struct xt_tgchk_param {
 	struct net *net;
@@ -336,9 +349,9 @@ struct xt_table_info *xt_alloc_table_inf
 void xt_free_table_info(struct xt_table_info *info);
 
 /**
- * xt_recseq - recursive seqcount for netfilter use
+ * var xt_recseq - recursive seqcount for netfilter use
  *
- * Packet processing changes the seqcount only if no recursion happened
+ * Packet processing changes the seqcount only if no recursion happened.
  * get_counters() can use read_seqcount_begin()/read_seqcount_retry(),
  * because we use the normal seqcount convention :
  * Low order bit set to 1 if a writer is active.
