Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D974EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 10:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjFSKqI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 06:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjFSKpn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 06:45:43 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1DE1BDB
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 03:45:14 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f875b267d9so351214e87.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 03:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687171512; x=1689763512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qsYOClyjnzcy7BeSvkDgFE5pZLQeWbywWb5pEjWp+7o=;
        b=r+C3sAO2UsWnDy1knjTBpy4Pug2bZQkQ4/tz8qDgOYn/ANkyFMX68jCCWytPHh2lrF
         hgB3iac/WhuOExg15+57UV5uLPubri6jXQlH25liOh9DBSktltgR5LCodfcKpxGJKKDF
         +jtmrT3THUcE/m7XJnvp5FyZWt3JiCR/7lHSOdjd6cG9XFKzUfAN1skrlI5Unb1xpY98
         mjNYpHKPAvEId8AYaQ7hnDOqQfW15VBRlcYFqcBtNi+iQgivLCJEQE5e+8JRbhBCnO+J
         P6PvfTWkQN7Zgxts8885m5iyfKoZt3qrmIrb3ynjmKWXGJheRI29T+Pg6zyk6UyhnjLb
         uoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687171512; x=1689763512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qsYOClyjnzcy7BeSvkDgFE5pZLQeWbywWb5pEjWp+7o=;
        b=dqp8HyyWYAdsbq4PlnAQivFLfiDMa0iAznf+t8z4e99RgvbhdGgt5mLZaP3oX4elGO
         XwoLQ6VUybbENRe0HKvTPbrLxzadZARyyNyoYqlsWREDUO+PVREeD3lwK4h/VsQnuZnX
         6OsTR3r42klqdL6a98722xKLNfRsuAZAZcgLm7dm7uCy3Tuo9KJtH24OHQGWEQuJXaO3
         5BPRhbRlBY+/7mfL2WPDpDT8jq5ix3h2B9ILOzMBqunW3FGUtqa9OHc4/LdMODJrfngZ
         ZDbRXLg/e4Joip6Xu/L3lrprW+klhgo7t+KxxpYt1SnCLIt4eOMoARid/vUs4Uadtoz7
         DolQ==
X-Gm-Message-State: AC+VfDxGa9PFxf6QU5S0uaQDdHc+tp8w3McJiy9nkFNMfsON2cSkcbIF
        1+yOkeaw9o//Mbp0tNuCpd/LAD7mA7flYw==
X-Google-Smtp-Source: ACHHUZ6Bye+A6pyufqYJfUrK2fD7oyjmmiYvhsHOdw4kXhNa9mW7eDum1Plj2ZBFOTmp/1V2iYrGjA==
X-Received: by 2002:a05:6512:3288:b0:4f0:1e7d:f897 with SMTP id p8-20020a056512328800b004f01e7df897mr5021332lfe.17.1687171511359;
        Mon, 19 Jun 2023 03:45:11 -0700 (PDT)
Received: from linux-ti96.home.skz-net.net ([80.68.235.246])
        by smtp.gmail.com with ESMTPSA id x5-20020a19f605000000b004edc6067affsm4187263lfe.8.2023.06.19.03.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 03:45:10 -0700 (PDT)
From:   Jacek Tomasiak <jacek.tomasiak@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        Jacek Tomasiak <jtomasiak@arista.com>
Subject: [iptables PATCH] iptables: Fix setting of ipv6 counters
Date:   Mon, 19 Jun 2023 12:44:54 +0200
Message-Id: <20230619104454.1216-1-jacek.tomasiak@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When setting counters using ip6tables-nft -c X Y the X and Y values were
not stored.

This is a fix based on 9baf3bf0e77dab6ca4b167554ec0e57b65d0af01 but
applied to the nft variant of ipv6 not the legacy.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1647
Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>
---
 iptables/xshared.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 17aed04e..71ee94d6 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1992,6 +1992,9 @@ void ipv6_post_parse(int command, struct iptables_command_state *cs,
 	if (args->goto_set)
 		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
 
+	/* nft-variants use cs->counters, legacy uses cs->fw6.counters */
+	cs->counters.pcnt = args->pcnt_cnt;
+	cs->counters.bcnt = args->bcnt_cnt;
 	cs->fw6.counters.pcnt = args->pcnt_cnt;
 	cs->fw6.counters.bcnt = args->bcnt_cnt;
 
-- 
2.35.3

