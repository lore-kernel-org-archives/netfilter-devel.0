Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2552C77B61
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 16:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbjDUQD4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 12:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjDUQD4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 12:03:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338741384A
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2023 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qhnxK9b1o9a08eVRzpLNjTUFh1nsvMrd1h1EGdTK0jU=; b=QABtZuhOZB2c8YeKEZLScTI8tI
        8rdyXEZs0mZuy7KnpkKMntjzcPX+df20Fx7H2xWIs6nZvfkrih9ZO7JqWRykBiHYDkCc1a94tHiSb
        EAJr7DxZHUFv2MdvcVdbPRXpyKuxvUTExbzpAJnv2Ya7YZx/+81O/SVIf0lCBdTjx6Lym/9w3QWYS
        Sy97YCuYl/cmbK2IzhuNmSRCWe4oj0lxLFzIJ1876Do0hwzC8iMky3Fozm1NCfxPznnDTSaA8Vlmh
        Kd14WGSvnDPsHPO1zzfnbnQyfQ6UeQIWC5aHYtskl62PBXFivCHRFKIiohDlA3IKUOjbe8FGZwmL4
        5Q7xFroQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pptEn-0007AC-KK
        for netfilter-devel@vger.kernel.org; Fri, 21 Apr 2023 18:03:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] utils: nfbpf_compile: Replace pcap_compile_nopcap()
Date:   Fri, 21 Apr 2023 18:04:08 +0200
Message-Id: <20230421160409.7586-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function is deprecated. Eliminate the warning by use of
pcap_open_dead(), pcap_compile() and pcap_close() just how
pcap_compile_nopcap() is implemented internally in libpcap.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 utils/nfbpf_compile.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/utils/nfbpf_compile.c b/utils/nfbpf_compile.c
index 2c46c7b026cc8..c9e763dcf144c 100644
--- a/utils/nfbpf_compile.c
+++ b/utils/nfbpf_compile.c
@@ -17,6 +17,7 @@ int main(int argc, char **argv)
 	struct bpf_program program;
 	struct bpf_insn *ins;
 	int i, dlt = DLT_RAW;
+	pcap_t *pcap;
 
 	if (argc < 2 || argc > 3) {
 		fprintf(stderr, "Usage:    %s [link] '<program>'\n\n"
@@ -36,9 +37,15 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (pcap_compile_nopcap(65535, dlt, &program, argv[argc - 1], 1,
+	pcap = pcap_open_dead(dlt, 65535);
+	if (!pcap) {
+		fprintf(stderr, "Memory allocation failure\n");
+		return 1;
+	}
+	if (pcap_compile(pcap, &program, argv[argc - 1], 1,
 				PCAP_NETMASK_UNKNOWN)) {
 		fprintf(stderr, "Compilation error\n");
+		pcap_close(pcap);
 		return 1;
 	}
 
@@ -50,6 +57,7 @@ int main(int argc, char **argv)
 	printf("%u %u %u %u\n", ins->code, ins->jt, ins->jf, ins->k);
 
 	pcap_freecode(&program);
+	pcap_close(pcap);
 	return 0;
 }
 
-- 
2.40.0

