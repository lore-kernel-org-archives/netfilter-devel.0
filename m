Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F727381BB
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718122640; cv=none; b=lQkVu9dIavzsdBEX1jdKiMYkS558KeQLYQfxYVVQyjF0bYuUc3GK7Rc0zkj0VI/s27TbozK2C+TdqpZ5V6W5I1XdltGjCJKnY++aP6N4w7ZVI24XScWwN5G2h05l3CKqeVOZtCdaxWLIIWFGMBOeG1KyWe7VxVnor719RB0ijjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718122640; c=relaxed/simple;
	bh=fzDp4s4M0YP2zHW3AvZywcPFMojzW37cJ48ka9pxK7U=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=M9lmqtfFJLrr9jHiYdDjJKjU+uEJy7pK9+0rDOX4deeBBqdL2fCirI3xDl6aAIUlnJIBNH5WHofPYiE1r8Wx4HhbRTxTE93KIGpcS8fAoujfXv4umTS7a/lqApgnOrH8sNSpMpc1KLR5Aqye+Fy+ljaKxhPY+EdxvV265U1DYaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cmd: skip variable set elements when collapsing commands
Date: Tue, 11 Jun 2024 18:17:11 +0200
Message-Id: <20240611161711.20247-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ASAN reports an issue when collapsing commands that represent an element
through a variable:

include/list.h:60:13: runtime error: member access within null pointer of type 'struct list_head'
AddressSanitizer:DEADLYSIGNAL
=================================================================
==11398==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000000 (pc 0x7ffb77cf09c2 bp 0x7ffc818267c0 sp 0x7ffc818267a0 T0)
==11398==The signal is caused by a WRITE memory access.
==11398==Hint: address points to the zero page.
    #0 0x7ffb77cf09c2 in __list_add include/list.h:60
    #1 0x7ffb77cf0ad9 in list_add_tail include/list.h:87
    #2 0x7ffb77cf0e72 in list_move_tail include/list.h:169
    #3 0x7ffb77cf86ad in nft_cmd_collapse src/cmd.c:478
    #4 0x7ffb77da9f16 in nft_evaluate src/libnftables.c:531
    #5 0x7ffb77dac471 in __nft_run_cmd_from_filename src/libnftables.c:720
    #6 0x7ffb77dad703 in nft_run_cmd_from_filename src/libnftables.c:807

Skip such commands to address this issue.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1754
Fixes: 498a5f0c219d ("rule: collapse set element commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/cmd.c b/src/cmd.c
index d6b1d844ed8d..37d93abc2cd4 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -455,6 +455,9 @@ bool nft_cmd_collapse(struct list_head *cmds)
 			continue;
 		}
 
+		if (cmd->expr->etype == EXPR_VARIABLE)
+			continue;
+
 		if (!elems) {
 			elems = cmd;
 			continue;
-- 
2.30.2

