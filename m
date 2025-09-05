Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F79737C106
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087133; cv=none; b=WjmpAk3V9aXpHIEHcIkWj7dosVtxjNECW6Pr3ttkKZc5lOi/3dIq4BvuWeiPuoKymOYBGB0AYQkA5GJaFa8nfS3pZ4rwfdRIgvzhB39iHMORnskPUfK29tfavFdxRFA1HIe2DlZUpDY1bNiPezrhEvaF3mipcrVpgIbrtg9xGXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087133; c=relaxed/simple;
	bh=9f8E8ACdn3esZTgigKJXPV/gCrLhBAp1OuSRAtsAzf0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=iYOrdi6O1fyQTL3Ds1BMV6RdEXJ78G+13HHNXdpKafwP0cQSkFztyWdCu/7bfCNDMQkJPbJaLQ+8a4FgIrREhLoXo48PrWNDPF2/TIsB1JbRzMX+yhXDn1Bembj0XOaViScW4mXpwNUBWm8mFzGvIeemkwwsGNeYJcdpcwzYSzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=umx6nNTr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=umx6nNTr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="umx6nNTr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="umx6nNTr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C29F8608CB; Fri,  5 Sep 2025 17:36:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086595;
	bh=tTsAVpoW3MXteipLjCeKq1aAb0ozrQ1TvNyO/JwPxUc=;
	h=From:To:Subject:Date:From;
	b=umx6nNTr4a45RL8Sf0LeZuXhnfF1Y6mDLhlSFmNque+4+2sxJd/8withgy+56jE9D
	 cx/1MqlsPYCBdwIxn5Nzyxc/xt84qeRWY+PiAPEOMaQNvHycjKmoCZMSORostGYzDi
	 fksNhB3yTmhIvSSUltfsegCIhFPpzbVZMh8eeeRm7YXIIjZ5LbF++RS37WiVJzhOHj
	 SY76mCfilDU954gtnM8+fYqhTLyIi+U3ghbHKHodJN5HuHu3wPax7MGFCq5NkFAnFf
	 dI7pJ+NFdvuJQzr60G9uultJiQH+EVM+XlTKMAFnu8lNSA0M7JMQRAhSv3Y4sAT9at
	 Ap+nWDeRU7zjw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E809608B8
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 17:36:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086595;
	bh=tTsAVpoW3MXteipLjCeKq1aAb0ozrQ1TvNyO/JwPxUc=;
	h=From:To:Subject:Date:From;
	b=umx6nNTr4a45RL8Sf0LeZuXhnfF1Y6mDLhlSFmNque+4+2sxJd/8withgy+56jE9D
	 cx/1MqlsPYCBdwIxn5Nzyxc/xt84qeRWY+PiAPEOMaQNvHycjKmoCZMSORostGYzDi
	 fksNhB3yTmhIvSSUltfsegCIhFPpzbVZMh8eeeRm7YXIIjZ5LbF++RS37WiVJzhOHj
	 SY76mCfilDU954gtnM8+fYqhTLyIi+U3ghbHKHodJN5HuHu3wPax7MGFCq5NkFAnFf
	 dI7pJ+NFdvuJQzr60G9uultJiQH+EVM+XlTKMAFnu8lNSA0M7JMQRAhSv3Y4sAT9at
	 Ap+nWDeRU7zjw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/7] prepare for EXPR_SET_ELEM removal
Date: Fri,  5 Sep 2025 17:36:20 +0200
Message-Id: <20250905153627.1315405-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently EXPR_MAPPING contains EXPR_SET_ELEM in the lhs:

                      EXPR_SET_ELEM -> EXPR_VALUE
                     /
        EXPR_MAPPING |
                     \
                      EXPR_VALUE

this series normalizes the expression for mappings:

                                       EXPR_SET_ELEM -> EXPR_VALUE
                                      /
        EXPR_SET_ELEM -> EXPR_MAPPING |
                                      \
                                       EXPR_VALUE

After this update, expr_set(expr)->expressions always contains
EXPR_SET_ELEM.

Another patch in this series moves expr->flags for EXPR_SET_ELEM to
expr->key->flags.

Midterm goal is to reduce memory footprint by introducing a struct
set_elem for expr_set() whose size is smaller that struct expr,
structure location is already provided by expr->key, this will also
remove the largest EXPR_* type in the struct expr union, this is not yet
accomplished by this series.

Pablo Neira Ayuso (7):
  src: normalize set element with EXPR_MAPPING
  src: allocate EXPR_SET_ELEM for EXPR_SET in embedded set declaration in sets
  src: assert on EXPR_SET only contains EXPR_SET_ELEM in the expressions list
  evaluate: simplify sets as set elems evaluation
  evaluate: clean up expr_evaluate_set()
  segtree: rename set_elem_add() to set_elem_expr_add()
  src: move flags from EXPR_SET_ELEM to key

 include/expression.h      |   4 +-
 src/datatype.c            |   1 +
 src/evaluate.c            | 126 +++++++++++------------
 src/expression.c          |  45 ++++++--
 src/intervals.c           | 209 ++++++++++++++++++++++----------------
 src/json.c                |  42 ++++++--
 src/monitor.c             |   2 +-
 src/netlink.c             | 105 ++++++++++---------
 src/netlink_delinearize.c |  18 +++-
 src/optimize.c            |  52 ++++++----
 src/parser_bison.y        |  12 ++-
 src/parser_json.c         |  14 ++-
 src/segtree.c             |  75 +++++++-------
 13 files changed, 415 insertions(+), 290 deletions(-)

-- 
2.30.2

