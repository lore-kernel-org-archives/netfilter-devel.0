Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D508824B22A
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2025 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736606285; cv=none; b=qmjgp6cz6oRkmzHWpGhm5o5MrH64E7/fF7LWX6UD3ScEbkblmIynn+ce2IQRHsQAPIyn+YLK2+X13xM5lWzkLwWdTVGjIm9zFS6a/r/oxZLFN4ca/wJdaK9L0N0yD9hmnH9mLa9lgKknZc7YdzkVov2u5OkdnaDarkXd61X5Pqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736606285; c=relaxed/simple;
	bh=HO9IZiROI0L3ckeFiI8YpyjderWejIOuYWosBlSevnY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PPYezIojGM+VO24XpxumxXmUMfEurG/cgBdaGg47J7ktXc058Jth9SpLaLsBhhrTKjOyzqvA5mcPYF1z8ASJlCSe1lXAuqDnrw40nyu2t3kccw8RNAbP8hmk7GabWV1Y/nVqXfeo/neQeOVJWl7StKZ/vVQ6ujGsf7AYQMPfgyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	linux@slavino.sk
Subject: [PATCH nft] parser_bison: simplify syntax to list all sets in table
Date: Sat, 11 Jan 2025 15:37:57 +0100
Message-Id: <20250111143757.65308-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Revisit f99ccda252fa ("parser: allow listing sets in one table") to add
an alias to list all sets in a given table, eg.

 # nft list sets ip x
 table ip x {
        set s1 {
                type ipv4_addr
        }
        set s2 {
                type ipv4_addr
        }
 }

This is similar to 275989737ec4 ("parser_bison: simplify reset syntax").

Update nft(8) manpage too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt        | 2 ++
 src/parser_bison.y | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 846ccfb28b92..12de0181ab91 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -588,6 +588,8 @@ section describes nft set syntax in more detail.
 *add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*comment* 'comment' *;*'] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
 {*delete* | *destroy* | *list* | *flush* | *reset* } *set* ['family'] 'table' 'set'
 *list sets* ['family']
+*list sets* ['family'] 'table'
+*list set* ['family'] 'table' 'set'
 *delete set* ['family'] 'table' *handle* 'handle'
 {*add* | *delete* | *destroy* } *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c8714812532d..ac8de398f8a7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1590,8 +1590,13 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
 			}
+			|	SETS		table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
+			}
 			|	SETS		TABLE	table_spec
 			{
+				/* alias of previous rule. */
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$3, &@$, NULL);
 			}
 			|	SET		set_spec
-- 
2.30.2

