Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF637C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 13:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B87420836
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 13:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=policy reason="signing key too small" (768-bit key) header.d=online.net header.i=@online.net header.b="vHl9ooXd";
	dkim=pass (1024-bit key) header.d=online.net header.i=@online.net header.b="UvQ+FOLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfCCNw2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 08:52:28 -0500
Received: from bounce-2.online.net ([62.210.16.44]:59858 "EHLO
        bounce-2.online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfCCNw1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 08:52:27 -0500
X-Greylist: delayed 1257 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2019 08:52:26 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Cc:To:Subject:From; bh=/vQEAYiFlYyVkjw+oUYKJczeOeD8/BAZD4co+VGzU+g=;
        b=vHl9ooXda770s9t36vloqJqwS9Gh0pFMnobWMkHIrfCafYrE2rkMcdJjAU0dNjgTwvZDNhtjLpdOaTAFJKcbyB+RduEKxD68TxiHSQN4j315hzrwz9s0IronOxFEUUwP;
Received: from [62.210.16.40] (helo=smtpauth-dc2-1.online.net)
        by bounce-dc2-2.online.net with esmtpa (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1h0RDF-0008R3-J3
        for netfilter-devel@vger.kernel.org; Sun, 03 Mar 2019 14:31:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=online.net; s=folays2;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Cc:To:Subject:From; bh=/vQEAYiFlYyVkjw+oUYKJczeOeD8/BAZD4co+VGzU+g=;
        b=UvQ+FOLW8tP3DZgQJPzTrN95gAIgja97ZHWThpPlRyQeIkOdcGrkAHXPUm9NkPgW5z8oVh+l3LZ8yqEV8sqAL6AVlvbMhazpxEc9TnPpJjlokKR14GfdsfKvl4sv9JCrPooO+0C4vEV1lD5TzGUgvgjjSaqDlAtDdh3ezy0xgO4=;
Received: from [90.22.161.100] (helo=[192.168.0.157])
        by smtpauth-dc2-1.online.net with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <alban.vidal@zordhak.fr>)
        id 1h0RD8-0007j8-Vq; Sun, 03 Mar 2019 14:31:23 +0100
From:   Alban Vidal <alban.vidal@zordhak.fr>
Subject: [PATCH v4 0/2] iptables-save,xtables-save: add option to show zeroed
 counters when saving rulesets
To:     netfilter-devel@vger.kernel.org
Cc:     ao2@ao2.it, Alban VIDAL <alban.vidal@zordhak.fr>
Openpgp: id=AE48C0F59B1998A06292A69996BD4FF64E709FDE
Autocrypt: addr=alban.vidal@zordhak.fr; prefer-encrypt=mutual; keydata=
 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 3XJT
Message-ID: <3561ac85-acaa-6618-0f7a-8c6daad45d07@zordhak.fr>
Date:   Sun, 3 Mar 2019 14:31:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: fr-FR
X-auth-smtp-user: alban.vidal@zordhak.fr
X-online-auth-user: FLEX_RTZFV01vSW9TNnVFc3NHSw==XvU6wbCSxYR/g7df1ckn7jpH+jP+dQ==
X-online-auth-smtp: FLEX_a1cyTTZHOEFVVzRJd2ttcQ==3gEC8xGud6nhbmUkys95fMT6heg0L5pDz3UvuHRvvA==
X-online-bounce-smtp: FLEX_T29XVzZPbXFtc000bUFVUw==k06YmLMEQqW5F015U+lEiXGWtPkeet9g5ypZ2XbNHw==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alban VIDAL <alban.vidal@zordhak.fr>

Dear Netfilter developers,

Please find two patch in next emails to add option in iptables-save and
xtables-save to show zeroed counters for chains when saving rulesets.

Best regards,
Alban

---

Alban VIDAL (1):
iptables-save: add option to show zeroed counters when saving rulesets

Antonio Ospite (1):
xtables-save: implement showing zeroed chain counters when saving
rulesets

include/xtables.h | 1 +
iptables/iptables-save.8.in | 7 +++++--
iptables/iptables-save.c | 12 ++++++++++--
iptables/nft-arp.c | 3 ++-
iptables/nft-bridge.c | 3 ++-
iptables/nft-shared.c | 8 +++++++-
iptables/nft-shared.h | 6 ++++--
iptables/nft.c | 4 ++--
iptables/nft.h | 2 +-
iptables/xtables-save.c | 14 +++++++++-----
10 files changed, 43 insertions(+), 17 deletions(-)

-- 
2.20.1

