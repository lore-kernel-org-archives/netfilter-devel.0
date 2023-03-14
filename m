Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331E9C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Mar 2023 09:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjCNJqo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Mar 2023 05:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjCNJqc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2023 05:46:32 -0400
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B9A99C32
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2023 02:46:19 -0700 (PDT)
Date:   Tue, 14 Mar 2023 09:46:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.ch;
        s=2hicwqw3onawrdix2wymvjlzxm.protonmail; t=1678787177; x=1679046377;
        bh=cvFGEqHEe3ATavTtM2a44KRchq0E9uMiNOzvBuzRsz8=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=HshQKoXZqwmhLU0t9iCKhh4pTk7nRfRvFFOlM9R/MvD3qw4ZCsuaFepxxWauFUQFW
         wPc3yrPz+RoIbTCVVYCkoDMx1VUX63KxIjnSB/qbJT/IBmucK/1fCqcwAhjG9h8v6r
         UOBaDOV1ySSMipFUhP329chT/HemauG9KKuhIi67a7Z7drXBKyR5v/aZzEL5ADbkOV
         BfJ6zT0mId0pnsmeLH/gfjzklea6pj8hxzz7OM7Rz+fQksaqNveUQCBfXO1PK1ujvV
         QCGzDfiHM8UjJHuFo21zVbrjEVPNpbE5Jjwm/o4yS7bC6/i8CBeQ6QTzRm2i3t2mqN
         AoP9JVVjohTlg==
To:     netfilter-devel@vger.kernel.org
From:   Matthieu De Beule <matthieu.debeule@proton.ch>
Cc:     Matthieu De Beule <matthieu.debeule@proton.ch>
Subject: [PATCH] Correct documentation errors in nf_tables.h
Message-ID: <20230314094412.56298-1-matthieu.debeule@proton.ch>
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
---
 include/uapi/linux/netfilter/nf_tables.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/=
netfilter/nf_tables.h
index 466fd3f4447c..71ddb0562e67 100644
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


