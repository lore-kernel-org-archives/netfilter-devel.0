Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAA1C6FD18
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Mar 2023 12:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjC2Mwy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Mar 2023 08:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjC2Mwy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2023 08:52:54 -0400
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA04C08
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2023 05:52:34 -0700 (PDT)
Date:   Wed, 29 Mar 2023 12:52:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.ch;
        s=flkpr2wsuffxhjcooektuxfa3a.protonmail; t=1680094351; x=1680353551;
        bh=c1QD15LzZaTAIRFRf6LjfIix72zH56bDtMulJ+lrjKI=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=IxA6L2ctuSpHq9gYNTTKesQIcsCVMBx9uHyczfQeykzykuFVUf+fDew31vKy/dFs9
         hKjacTMTq7jyx5tRTLPuMNAexC7AdqPa3189dgpRmh6VEr85XiTL2P3nQj2IgI+1fb
         g79hk/8uipCH6NC1VG3SLwoRENDHo47MOWVF6cT6Yf+RJ4tdTS3ptFePGXwKmkuXdY
         EzfdHV+RjUcF82uFnk6WaDoTAgUlPiMaiLF/YzFqn9F9QQ6pYL8kUKoQACXyGrUJ9F
         oterhmjbU/3ckrhF5nh7f/+6qNbrpE76Uw+2EQt1yKDjTPKK5G8aoR5bWwgx0PU+bl
         OEEdUyUcefxAA==
To:     netfilter-devel@vger.kernel.org
From:   Matthieu De Beule <matthieu.debeule@proton.ch>
Cc:     Matthieu De Beule <matthieu.debeule@proton.ch>
Subject: [PATCH nf-next] netfilter: Correct documentation errors in nf_tables.h
Message-ID: <20230329124918.380799-1-matthieu.debeule@proton.ch>
Feedback-ID: 66814732:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For NFTA_RANGE_OP incorrectly said it was a nft_cmp_ops instead of nft_rang=
e_ops
NFTA_LOG_GROUP and NFTA_LOG_QTHRESHOLD were documented as NLA_U32 instead o=
f NLA_U16
NFTA_EXTHDR_SREG wasn't documented as a register

Signed-off-by: Matthieu De Beule <matthieu.debeule@proton.ch>
---
 include/uapi/linux/netfilter/nf_tables.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/=
netfilter/nf_tables.h
index 466fd3f4447c..3b4cd85c6476 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -669,7 +669,7 @@ enum nft_range_ops {
  * enum nft_range_attributes - nf_tables range expression netlink attribut=
es
  *
  * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_regi=
sters)
- * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
+ * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_range_ops)
  * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes=
)
  * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
  */
@@ -835,7 +835,7 @@ enum nft_exthdr_op {
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
  * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
  * @NFTA_EXTHDR_OP: option match type (NLA_U32)
- * @NFTA_EXTHDR_SREG: option match type (NLA_U32)
+ * @NFTA_EXTHDR_SREG: source register (NLA_U32: nft_registers)
  */
 enum nft_exthdr_attributes {
 =09NFTA_EXTHDR_UNSPEC,
@@ -1217,10 +1217,10 @@ enum nft_last_attributes {
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
- * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
+ * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U16)
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA=
_U32)
- * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U16)
  * @NFTA_LOG_LEVEL: log level (NLA_U32)
  * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
--
2.38.4


