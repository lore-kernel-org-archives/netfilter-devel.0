Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F96C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Feb 2022 17:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351951AbiBKRM2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 12:12:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351944AbiBKRM1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 12:12:27 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5784C02
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 09:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OYg+pXLIehsDnDCBtJbRdtal+A6hxtSX0BjMiFPnCPg=; b=Cou/fLU8+YE1fxdf9FnPyD2NKP
        KAN5e7LJ3Ly1azqbYp/Psq0xM+ncQOdFn2GvS5s9lGfkX5iwwbFg86jYbGoDOfE8HbWk+4NK5aRx2
        zMxtjglZ8jtzV4RMR7qXl6utOUpvINR8Ts/S2MgZearnC4JhZAE0TcfSBifRxnClwV3dtHPf8QuQR
        lASM8hMZ1hbq36msyE3FuxHvFXXiUkRkQVLNbeHqGUkzE94r2CrZc4ixyf6e6v4lk/Cnie22Gd6Oe
        P3Uo3YnibnqPCGf2j5POPZJQs+hmoSIkFr/XI0HmqmRqP3ogit3/yfz7Wm0AOxcKSoO/FLH6kfru2
        6s5rZOGA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nIZT6-0006U4-7J; Fri, 11 Feb 2022 18:12:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] Improve error messages for unsupported extensions
Date:   Fri, 11 Feb 2022 18:12:11 +0100
Message-Id: <20220211171211.26484-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211171211.26484-1-phil@nwl.cc>
References: <20220211171211.26484-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a given extension was not supported by the kernel, iptables would
print a rather confusing error message if extension parameters were
given:

| # rm /lib/modules/$(uname -r)/kernel/net/netfilter/xt_LOG.ko
| # iptables -A FORWARD -j LOG --log-prefix foo
| iptables v1.8.7 (legacy): unknown option "--log-prefix"

Avoid this by pretending extension revision 0 is always supported. It is
the same hack as used to successfully print extension help texts as
unprivileged user, extended to all error codes to serve privileged ones
as well.

In addition, print a warning if kernel rejected revision 0 and it's not
a permissions problem. This helps users find out which extension in a
rule the kernel didn't like.

Finally, the above commands result in these messages:

| Warning: Extension LOG revision 0 not supported, missing kernel module?
| iptables: No chain/target/match by that name.

Or, for iptables-nft:

| Warning: Extension LOG revision 0 not supported, missing kernel module?
| iptables v1.8.7 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain FORWARD

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c       | 12 +++++++++---
 libxtables/xtables.c |  7 ++++++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 041e1b8ccd3e5..d011d7c88da12 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3514,10 +3514,16 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
 err:
 	mnl_socket_close(nl);
 
-	/* pretend revision 0 is valid if not permitted to check -
-	 * this is required for printing extension help texts as user */
-	if (ret < 0 && errno == EPERM && rev == 0)
+	/* pretend revision 0 is valid -
+	 * this is required for printing extension help texts as user, also
+	 * helps error messaging on unavailable kernel extension */
+	if (ret < 0 && rev == 0) {
+		if (errno != EPERM)
+			fprintf(stderr,
+				"Warning: Extension %s revision 0 not supported, missing kernel module?\n",
+				name);
 		return 1;
+	}
 
 	return ret < 0 ? 0 : 1;
 }
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index b34d62acf6015..87424d045466b 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -958,7 +958,12 @@ int xtables_compatible_revision(const char *name, uint8_t revision, int opt)
 		/* Definitely don't support this? */
 		if (errno == ENOENT || errno == EPROTONOSUPPORT) {
 			close(sockfd);
-			return 0;
+			/* Pretend revision 0 support for better error messaging */
+			if (revision == 0)
+				fprintf(stderr,
+					"Warning: Extension %s revision 0 not supported, missing kernel module?\n",
+					name);
+			return (revision == 0);
 		} else if (errno == ENOPROTOOPT) {
 			close(sockfd);
 			/* Assume only revision 0 support (old kernel) */
-- 
2.34.1

