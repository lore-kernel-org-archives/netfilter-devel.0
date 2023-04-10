Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B669C76196
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Apr 2023 18:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjDJSDR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Apr 2023 14:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDJSDQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2023 14:03:16 -0400
Received: from libel.victim.com (libel.victim.com [5.200.21.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE0A170A
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=pifke.org;
         s=sept2013; h=Content-Type:MIME-Version:Message-ID:Date:References:
        In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LMOEXi7yS0Ibo7mxro4tujnhn3YKIJBwGInKwomi048=; b=Oj9gtifulxxpJry7IVfVlV7d/7
        hyJbpqEm34BwWCS0R5FudKh3r/M6arR/6f9wezW0g49e5ftcrOXYMANEfluCcTu5EQPBTmad3JWsH
        64z65mleM29v7CwwurOE2O9dri6t30fvv121T1VqwrBt0ZQ1qUJ0aPnbaWDyw7Z+Cf1UuMb57IeAx
        aziFEYewCXqafVEpEroQvfkfWQGBYRQo2pxO77b3d0vLzwxzVRzInSC3s/Nlq8fCLaga7Nz+lVDYH
        e6ARguNxMbFEr8k4vEUQ68liAyoF1wyInocCQCrpbXfu8ir9+ifnZwO5/wQlmAl+jHN/JRDnD/XpM
        WetVhdNg==;
Received: from [2620:b0:2000:da00::2] (helo=stabbing.victim.com)
        by libel.victim.com with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim)
        (envelope-from <dave@pifke.org>)
        id 1plvrC-0001IX-Vl; Mon, 10 Apr 2023 18:03:11 +0000
From:   Dave Pifke <dave@pifke.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: try SO_SNDBUF before SO_SNDBUFFORCE
In-Reply-To: <ZDH0EJN9O0DrWp0W@calendula>
References: <87wn2n8ghs.fsf@stabbing.victim.com> <ZDH0EJN9O0DrWp0W@calendula>
Date:   Mon, 10 Apr 2023 12:03:34 -0600
Message-ID: <87r0sr8vih.fsf@stabbing.victim.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> setsockopt() with SO_SNDBUF never fails: it trims the newbuffsiz that is
> specified by net.core.wmem_max

Oh, good catch!  Your revised patch LGTM, and is closer to what was
being done in the immediately proceeding function, mnl_set_rcvbuffer.

However, after thinking about it, I feel we should be checking the
receiver value after setsockopt returns.  If someone is running
e.g. AppArmor, it seems better to me to attempt the non-privileged
operation first, to avoid adding noise in the logs.

Also, I don't think there are any current situations where
SO_SNDBUFFORCE might also trim down the value, but after re-reading the
man page, I'm not sure the contract precludes that in the future.

Attached is a V3 patch for consideration, which also changes the code to
attempt the non-privileged SO_RCVBUF before SO_RCVBUFFORCE.  I defer to
your judgment on which version is actually better; I tested both and
they both work a) in a container where SO_SNDBUFFORCE fails, and b)
outside a container with wmem_max set to a small-ish value where
SO_SNDBUFFORCE is required.

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=so-sndbuf-v3.patch

diff --git a/src/mnl.c b/src/mnl.c
index 26f943db..dcc22b82 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -259,10 +259,19 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 	if (newbuffsiz <= sndnlbuffsiz)
 		return;
 
-	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
-	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
-		       &newbuffsiz, sizeof(socklen_t)) < 0)
-		return;
+	/* Raise sender buffer length to avoid hitting -EMSGSIZE.  The kernel may
+	 * reduce this to /proc/sys/net/core/wmem_max, see socket(7).
+	 */
+	sndnlbuffsiz = newbuffsiz;
+	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
+		   &sndnlbuffsiz, sizeof(socklen_t)) < 0 || sndnlbuffsiz < newbuffsiz) {
+		/* If SO_SNDBUF failed or the resulting size is still too small, try
+		 * again with SO_SNDBUFFORCE.  This requires CAP_NET_ADMIN.
+		 */
+		sndnlbuffsiz = newbuffsiz;
+		setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
+		   &sndnlbuffsiz, sizeof(socklen_t));
+	}
 }
 
 static unsigned int nlsndbufsiz;
@@ -280,14 +289,16 @@ static int mnl_set_rcvbuffer(const struct mnl_socket *nl, socklen_t bufsiz)
 	if (nlsndbufsiz >= bufsiz)
 		return 0;
 
-	ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
-			 &bufsiz, sizeof(socklen_t));
-	if (ret < 0) {
-		/* If this doesn't work, try to reach the system wide maximum
-		 * (or whatever the user requested).
+	nlsndbufsiz = bufsiz;
+	ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
+			 &nlsndbufsiz, sizeof(socklen_t));
+	if (ret < 0 || nlsndbufsiz < bufsiz) {
+		/* If this doesn't work, try again with SO_RCVBUFFORCE.  This requires
+		 * CAP_NET_ADMIN.
 		 */
-		ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
-				 &bufsiz, sizeof(socklen_t));
+		nlsndbufsiz = bufsiz;
+		ret = setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUFFORCE,
+				 &nlsndbufsiz, sizeof(socklen_t));
 	}
 
 	return ret;

--=-=-=
Content-Type: text/plain



-- 
Dave Pifke, dave@pifke.org

--=-=-=--
