Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CE52EF655
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768218; cv=none; b=rIo5HtAJIvdYsQX2p2J/VLUtRoN++z596+JRR3DBcU3vceXXPH0kFnV5IvFkui98qNoxXPLWnOFsEnpbVlppAkLnjQguLnEd73YHGILpfwqSlH3b7WXojE6M/KNcVDgXq/6s5RvDzO7MK06M3C7gh/oTRlLcWwLwerxW/1OGJIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768218; c=relaxed/simple;
	bh=F034JRCVpL/KOWocXmDIYLxXBQ6k5rBZ/9dz1+u+t74=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Q7keHBmSHBmuODoKT+J5fLnqPy6I6ddcsxtjrhQBZiEingWqy3yMrUQ7u1EluLwiIizQ0onj0S33PMe8UBI2xxAsA9P5GsWs9OmEjqncOXhhrLK4YjKDKXWQQoyoDOXbh0RnNg9JA95M+iwxXDdG/klHwMfaCr79uflkjGMTRBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iNKeLyU0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iNKeLyU0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iNKeLyU0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iNKeLyU0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9D601602AD; Thu, 21 Aug 2025 11:23:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768214;
	bh=0LXVHR5bak4GZjxt4hSBC2PqO/EmN+NbjqE+AYmuFWc=;
	h=From:To:Subject:Date:From;
	b=iNKeLyU0hzstBAzFatHMz9BEPGJYAjrhV90hpg7Iwexu25T3nW9GHiLVokauFZ5Q8
	 UpBExRwo+ZVtC82QlUiuP9SB2m18qfbMd1+E6Mi3plqknbArbDlyEgG8zRp2/PDG3f
	 8GxpIG4Hw3+AvTaj6sq/QEOoQLSryBOK4Jqd3V2xKqPZdjdm43K1QhXAkjLHCvfmqg
	 lh6kFAFY5zRmclXW1IsXEwClM+R5lpkgEVq6375jAaqJEY64yazKrlE2gtyJXtQL29
	 Xx2bwEElrNO00JWJFFI3PGgq9ghOqsxF7OWFcBZ+mqLdwUZNb3/M6JOetInXzlx16S
	 F3Iimodg4I2nA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 45E47602AB
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:23:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755768214;
	bh=0LXVHR5bak4GZjxt4hSBC2PqO/EmN+NbjqE+AYmuFWc=;
	h=From:To:Subject:Date:From;
	b=iNKeLyU0hzstBAzFatHMz9BEPGJYAjrhV90hpg7Iwexu25T3nW9GHiLVokauFZ5Q8
	 UpBExRwo+ZVtC82QlUiuP9SB2m18qfbMd1+E6Mi3plqknbArbDlyEgG8zRp2/PDG3f
	 8GxpIG4Hw3+AvTaj6sq/QEOoQLSryBOK4Jqd3V2xKqPZdjdm43K1QhXAkjLHCvfmqg
	 lh6kFAFY5zRmclXW1IsXEwClM+R5lpkgEVq6375jAaqJEY64yazKrlE2gtyJXtQL29
	 Xx2bwEElrNO00JWJFFI3PGgq9ghOqsxF7OWFcBZ+mqLdwUZNb3/M6JOetInXzlx16S
	 F3Iimodg4I2nA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 00/11] replace compound_expr_*() by type safe function
Date: Thu, 21 Aug 2025 11:23:19 +0200
Message-Id: <20250821092330.2739989-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v2 with minimal changes wrt. previous series.

The aim is to replace (and remove) the existing compound_expr_*()
helper functions which is common to set, list and concat expressions
by expression type safe variants that validate the expression type.

I will hold on with this until nftables 1.1.5 including the fix for
the JSON regression is released.

Pablo Neira Ayuso (11):
  src: add expr_type_catchall() helper and use it
  src: replace compound_expr_add() by type safe set_expr_add()
  src: replace compound_expr_add() by type safe concat_expr_add()
  src: replace compound_expr_add() by type safe list_expr_add()
  segtree: rename set_compound_expr_add() to set_expr_add_splice()
  expression: replace compound_expr_clone() by type safe function
  expression: remove compound_expr_add()
  expression: replace compound_expr_remove() by type safe function
  expression: replace compound_expr_destroy() by type safe funtion
  expression: replace compound_expr_print() by type safe function
  src: replace compound_expr_alloc() by type safe function

 include/expression.h      |  15 +++-
 src/evaluate.c            |   4 +-
 src/expression.c          | 177 ++++++++++++++++++++++++++------------
 src/intervals.c           |  20 ++---
 src/monitor.c             |   2 +-
 src/netlink.c             |   6 +-
 src/netlink_delinearize.c |   8 +-
 src/optimize.c            |  38 ++++----
 src/parser_bison.y        |  40 ++++-----
 src/parser_json.c         |  18 ++--
 src/payload.c             |   6 +-
 src/segtree.c             |  40 ++++-----
 src/trace.c               |  10 +--
 13 files changed, 229 insertions(+), 155 deletions(-)

-- 
2.30.2

