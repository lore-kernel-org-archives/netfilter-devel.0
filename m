Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743C3C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiK3TOe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK3TOd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:33 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EBF62E8C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jovq2wbxWZdDYrO7vYRD6TKEvmCNLYKADvqe6rpF6GI=; b=o+RP3Le0xhWgndPbiQVE5heYBI
        /oJncbkiw4Zh5NxuPgUovb8FOnQFxDg02fUY25wXtaCUGn1XEBB8gJlPz5FCusCGis6YgqORuDxba
        YJW16+xjYShQjSekyv9RnNQmWfVgKIgE76pu72DAGYDBEAsVtPkDEwuVkzV7Y95Ie6DcvD2k+Owkx
        hLqqrwmiBzhbHNIzxfwBXH5MZygnlqNkNdv+lAzMwbo1A8hKnVVb3ihSLNnjHhqZKj2BY6UD88aSc
        vDPIs27r3VwEFNjK1YSlPbKIm/G4jqfvBuO5BHTlR8xLQ13zUWPyBISDurp4zZgqyFczOrVF1K9eT
        Ad3Z8YUA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SXO-0001Bn-Du
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:31 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/9] tests: shell: Fix valgrind mode for 0008-unprivileged_0
Date:   Wed, 30 Nov 2022 20:13:37 +0100
Message-Id: <20221130191345.14543-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Valgrind is run as user nobody, let everyone write into the temporary
directory.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/run-tests.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables/tests/shell/run-tests.sh b/iptables/tests/shell/run-tests.sh
index 7878760fdcc4d..7a80af3432285 100755
--- a/iptables/tests/shell/run-tests.sh
+++ b/iptables/tests/shell/run-tests.sh
@@ -122,7 +122,8 @@ EOF
 if [ "$VALGRIND" == "y" ]; then
 	tmpd=$(mktemp -d)
 	msg_info "writing valgrind logs to $tmpd"
-	chmod a+rx $tmpd
+	# let nobody write logs, too (././testcases/iptables/0008-unprivileged_0)
+	chmod 777 $tmpd
 	printscript "$XTABLES_NFT_MULTI" "$tmpd" >${tmpd}/xtables-nft-multi
 	printscript "$XTABLES_LEGACY_MULTI" "$tmpd" >${tmpd}/xtables-legacy-multi
 	trap "rm ${tmpd}/xtables-*-multi" EXIT
-- 
2.38.0

