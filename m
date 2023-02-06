Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BD0C636D3
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Feb 2023 17:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjBFRDd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 12:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBFRDd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 12:03:33 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D617F1B557
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2023 09:03:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 83909606E1;
        Mon,  6 Feb 2023 17:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1675703010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vqflvKKU5z+Hnugd3McuTk5/fCdSazq3jJ3fvDDzkTY=;
        b=DhpG6LpdIbceI1bTAVsqofOmMWB3bE2TMV0g/gnIRFJNFMgVfbEcggVP2eUZ4qWAOykl3f
        +9GTgV/weqeKgjW0913YHV4qIgaOwYOFh03kPproeqTyFZyc+HbrUpLFxLetsLaScS6Fxc
        QPXbZQkPeI1UUN8dF+Sdb/b12pSIMD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1675703010;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vqflvKKU5z+Hnugd3McuTk5/fCdSazq3jJ3fvDDzkTY=;
        b=XMKIPAV59iBP+SEGlBpfMWpoCn33nvtF4OnZ08RB8vGrA5J08ROhWcFqRb/EFMdGzsl6tj
        VjKiw4DOii45hcBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 36B23138E8;
        Mon,  6 Feb 2023 17:03:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G9qRCuIy4WP2IgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 06 Feb 2023 17:03:30 +0000
From:   Petr Vorel <pvorel@suse.cz>
To:     ltp@lists.linux.it
Cc:     Petr Vorel <pvorel@suse.cz>, netfilter-devel@vger.kernel.org
Subject: [PATCH 1/1] iptables_lib.sh: Fix for iptables-translate >= v1.8.9
Date:   Mon,  6 Feb 2023 18:03:25 +0100
Message-Id: <20230206170325.19813-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables-translate <= v1.8.8 didn't use quotes:
$ iptables-translate -A INPUT -s 127.0.0.1 -p icmp -j DROP
nft add rule ip filter INPUT ip protocol icmp ip saddr 127.0.0.1 counter drop

iptables-translate since v1.8.9 started to add quotes:
$ iptables-translate -A INPUT -s 127.0.0.1 -p icmp -j DROP
nft 'add rule ip filter INPUT ip protocol icmp ip saddr 127.0.0.1 counter drop'

That broke nft01.sh test:

Error: syntax error, unexpected junk
'add rule ip filter INPUT ip protocol icmp ip saddr 127.0.0.1 counter drop'
^
nft01 1 TFAIL: nft command failed to append new rule

Therefore filter out also quotes (to existing backslash).

Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
 testcases/network/iptables/iptables_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/testcases/network/iptables/iptables_lib.sh b/testcases/network/iptables/iptables_lib.sh
index ab76cbd416..7e138ea33b 100755
--- a/testcases/network/iptables/iptables_lib.sh
+++ b/testcases/network/iptables/iptables_lib.sh
@@ -22,7 +22,7 @@ NFRUN()
 	if [ "$use_iptables" = 1 ]; then
 		ip${TST_IPV6}tables $@
 	else
-		$(ip${TST_IPV6}tables-translate $@ | sed 's,\\,,g')
+		$(ip${TST_IPV6}tables-translate $@ | sed "s/[\']//g")
 	fi
 }
 
-- 
2.39.1

