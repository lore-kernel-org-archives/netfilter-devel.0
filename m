Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816F6C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 14:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiF0OmQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 10:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiF0OmO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 10:42:14 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB45CE04
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 07:42:13 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id m24-20020a0568301e7800b00616b5c114d4so5716570otr.11
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 07:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SWLJQZgi5qCI7XFvxr1kJDv61P2/jTJf+xOeLIYMauU=;
        b=Gi3aDrvV4MsnmfEcJKlKzKTL0/yXIE+KbQtsajEmD8PEjWoBjLEmWDoJbaapQLbZR0
         owPtoSvGpewKnhze1KRlyq89NzAXeHT7lA2xn4v14gfCTrsA9PsfRnPK9l0QztlQWu6u
         RgThvLgL24erQfTv7s+IcY+xRFEY4tDpiCT+D7x4OYTQrbZbOF6FlqWVKjEdjNi5NeXY
         xPM/RWYNZKv9+RgsaHo7h/My6tTm03o6g21w6ShbpUzAPrD1NuowgDSFeVsuOyCyTxfk
         wAXSFnqIpgi7S0+FVEYs9N08dLl4xQHwb0ioYenKUByKLinnI4JmUY4+lIdDzYPhbZ3Z
         QQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SWLJQZgi5qCI7XFvxr1kJDv61P2/jTJf+xOeLIYMauU=;
        b=L8VpYSDr5JycVhpx43atdnnPKh4Un31l3/LM8xlRD4egaeLszUonf76+aw9GIN3WKM
         hFaIsrfAwkbwiHx3Z9S2YViJffvJGIP7SK+fCuG+vdn7Fh4qLSTKZ21E/7OC2m36bDhs
         iJKuXol5ldDoexL08vR8e8liqIQLIAOHMMM0QfH6WjMgn+cjwWy7jAlIFsRzmTKaHPyo
         nTOZZXldk2wLzsa+f+0SQuWwSOszl/cmVXkhx8tK+H/9ziJ4BfzK3Jdi2WHpCl8D6c6x
         hTFjcGov8RkGMsKM43ax8qJ155sk1NT+TdK4Vp4kL5llMVbOw4kZjeaGUzpOg1sijkuJ
         jGrw==
X-Gm-Message-State: AJIora/2y9XniMNpt6XGBJ21SqHxNeqNCvWeenz4rx1qWPkTZTHqNLm1
        kzFhf9wJhuIhgtXwPYRAelc=
X-Google-Smtp-Source: AGRyM1sbe471DTAlcxsaKb18CsxTTB2Fp0tnTLkhA+mZj4FTAOJyJFXrhtlwD1KXIEDo7FXG0Nu6gA==
X-Received: by 2002:a9d:2c5:0:b0:60c:2bf9:1dbd with SMTP id 63-20020a9d02c5000000b0060c2bf91dbdmr5669763otl.254.1656340933154;
        Mon, 27 Jun 2022 07:42:13 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f016:166b:c3a:b4d:ea8b:92aa])
        by smtp.gmail.com with ESMTPSA id n27-20020a056870559b00b000f32fb9d2bfsm7109925oao.5.2022.06.27.07.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 07:42:12 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 04237322C41; Mon, 27 Jun 2022 11:42:11 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH nf-next] flow_table: do not try to add already offloaded entries
Date:   Mon, 27 Jun 2022 11:38:24 -0300
Message-Id: <95c2aa63adea29e6008ee45af17d199492f4d14b.1656340577.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, whenever act_ct tries to match a packet against the flow
table, it will also try to refresh the offload. That is, at the end
of tcf_ct_flow_table_lookup() it will call flow_offload_refresh().

The problem is that flow_offload_refresh() will try to offload entries
that are actually already offloaded, leading to expensive and useless
work. Before this patch, with a simple iperf3 test on OVS + TC
(hw_offload=true) + CT test entirely in sw, it looks like:

- 39,81% tcf_classify
   - fl_classify
      - 37,09% tcf_action_exec
         + 33,18% tcf_mirred_act
         - 2,69% tcf_ct_act
            - 2,39% tcf_ct_flow_table_lookup
               - 1,67% queue_work_on
                  - 1,52% __queue_work
                       1,20% try_to_wake_up
         + 0,80% tcf_pedit_act
      + 2,28% fl_mask_lookup

The patch here aborts the add operation if the entry is already present
in hw. With this patch, then:

- 43,94% tcf_classify
   - fl_classify
      - 39,64% tcf_action_exec
         + 38,00% tcf_mirred_act
         - 1,04% tcf_ct_act
              0,63% tcf_ct_flow_table_lookup
      + 3,19% fl_mask_lookup

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 11b6e19420920bc8efda9877af0dab5311c8a096..9a8fc61581400b4e13aa356972d366892bb71b9b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1026,6 +1026,9 @@ void nf_flow_offload_add(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
+	if (test_bit(NF_FLOW_HW, &flow->flags))
+		return;
+
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
 	if (!offload)
 		return;
-- 
2.35.3

