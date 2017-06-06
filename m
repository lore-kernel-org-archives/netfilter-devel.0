From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 3/4] conntrackd: cleanup if failed forking
Date: Tue, 06 Jun 2017 12:58:38 +0200
Message-ID: <149674671849.18546.543096306345523924.stgit@nfdev2.cica.es>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40565 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751499AbdFFK6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 06:58:52 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id AC9DE51F352
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 10:58:45 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HFPKeKpF85jr for <netfilter-devel@vger.kernel.org>;
        Tue,  6 Jun 2017 12:58:39 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 356AF51F358
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 12:58:39 +0200 (CEST)
In-Reply-To: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Close the logs and lockfile if error while forking.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/main.c b/src/main.c
index bab7772..3b19160 100644
--- a/src/main.c
+++ b/src/main.c
@@ -386,6 +386,8 @@ int main(int argc, char *argv[])
 
 		if ((pid = fork()) == -1) {
 			dlog(LOG_ERR, "fork has failed: %s", strerror(errno));
+			close_log();
+			unlink(CONFIG(lockfile));
 			exit(EXIT_FAILURE);
 		} else if (pid) {
 			sd_ct_mainpid(pid);

