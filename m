Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD11EC48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B0C204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 06:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfFYG55 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:57:57 -0400
Received: from a3.inai.de ([88.198.85.195]:40116 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727622AbfFYG55 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 02:57:57 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id 33D2725EAAF3; Tue, 25 Jun 2019 08:57:54 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 627C33BB696A;
        Tue, 25 Jun 2019 08:57:53 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/3] daemons: review owner and permissions on PF_LOCAL sockets
Date:   Tue, 25 Jun 2019 08:57:51 +0200
Message-Id: <20190625065753.31059-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Armin Schöffmann <armin.schoeffmann@aegaeon.de>

Correctly set the desired owner (from config file) and permission
settings for PF_LOCAL sockets of kopano-{server, dagent, gateway,
ical, statsd, indexd}. This was inconsistently handled before and got
substantially broken by changes introduced with commit
kopanocore-8.7.81-162-g5995dbf7c [MERGE].

[Amendement: Services normally exposed via TCP/IP get to have
S_IxOTH, services normally only exposed via PF_LOCAL socket get not
to have S_IxOTH. —jengelh]

Fixes: kopanocore-8.7.81-146-g1dbcce2e3
References: KF-2512
---
 ECtools/idx_net.cpp                        |  3 ++-
 ECtools/statsd.cpp                         |  3 ++-
 caldav/CalDAV.cpp                          |  7 +++++--
 gateway/Gateway.cpp                        | 13 +++++++++----
 provider/server/ECSoapServerConnection.cpp | 15 ++++++++++-----
 spooler/DAgent.cpp                         |  3 ++-
 6 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/ECtools/idx_net.cpp b/ECtools/idx_net.cpp
index 246f34971..b624cd4a0 100644
--- a/ECtools/idx_net.cpp
+++ b/ECtools/idx_net.cpp
@@ -75,7 +75,8 @@ static int idx_listen(ECConfig *cfg, std::vector<struct pollfd> &pollers)
 	x.events = POLLIN;
 	pollers.reserve(idx_sock.size());
 	for (const auto &spec : idx_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &x.fd, S_IRUSR | S_IWUSR);
+		auto ret = ec_listen_generic(spec.c_str(), &x.fd, S_IRWUG,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0)
 			return ret;
 		pollers.push_back(x);
diff --git a/ECtools/statsd.cpp b/ECtools/statsd.cpp
index a49e8b312..27d058554 100644
--- a/ECtools/statsd.cpp
+++ b/ECtools/statsd.cpp
@@ -205,7 +205,8 @@ static HRESULT sd_listen(ECConfig *cfg, struct socks &sk)
 	memset(&pfd, 0, sizeof(pfd));
 	pfd.events = POLLIN;
 	for (const auto &spec : tokenize(cfg->GetSetting("statsd_listen"), ' ', true)) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0)
 			return MAPI_E_NETWORK_ERROR;
 		sk.pollfd.push_back(pfd);
diff --git a/caldav/CalDAV.cpp b/caldav/CalDAV.cpp
index 4f68c6dd4..007509877 100644
--- a/caldav/CalDAV.cpp
+++ b/caldav/CalDAV.cpp
@@ -28,6 +28,7 @@
 #include <iostream>
 #include <string>
 #include <getopt.h>
+#include <sys/stat.h>
 #include <kopano/ECConfig.h>
 #include <kopano/ECLogger.h>
 #include <kopano/ECChannel.h>
@@ -334,7 +335,8 @@ static HRESULT ical_listen(ECConfig *cfg)
 	memset(&pfd, 0, sizeof(pfd));
 	pfd.events = POLLIN;
 	for (const auto &spec : ical_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return MAPI_E_NETWORK_ERROR;
@@ -348,7 +350,8 @@ static HRESULT ical_listen(ECConfig *cfg)
 		g_socks.ssl.push_back(false);
 	}
 	for (const auto &spec : icals_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return MAPI_E_NETWORK_ERROR;
diff --git a/gateway/Gateway.cpp b/gateway/Gateway.cpp
index b44df3af6..2d6c0d9c7 100644
--- a/gateway/Gateway.cpp
+++ b/gateway/Gateway.cpp
@@ -16,6 +16,7 @@
 #include <netdb.h>
 #include <poll.h>
 #include <sys/resource.h>
+#include <sys/stat.h>
 #include <inetmapi/inetmapi.h>
 #include <mapi.h>
 #include <mapix.h>
@@ -471,7 +472,8 @@ static HRESULT gw_listen(ECConfig *cfg)
 	memset(&pfd, 0, sizeof(pfd));
 	pfd.events = POLLIN;
 	for (const auto &spec : pop3_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return MAPI_E_NETWORK_ERROR;
@@ -486,7 +488,8 @@ static HRESULT gw_listen(ECConfig *cfg)
 		g_socks.ssl.push_back(false);
 	}
 	for (const auto &spec : pop3s_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return MAPI_E_NETWORK_ERROR;
@@ -501,7 +504,8 @@ static HRESULT gw_listen(ECConfig *cfg)
 		g_socks.ssl.push_back(true);
 	}
 	for (const auto &spec : imap_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return MAPI_E_NETWORK_ERROR;
@@ -516,7 +520,8 @@ static HRESULT gw_listen(ECConfig *cfg)
 		g_socks.ssl.push_back(false);
 	}
 	for (const auto &spec : imaps_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd);
+		auto ret = ec_listen_generic(spec.c_str(), &pfd.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return MAPI_E_NETWORK_ERROR;
diff --git a/provider/server/ECSoapServerConnection.cpp b/provider/server/ECSoapServerConnection.cpp
index 3725bc690..78f480b2f 100644
--- a/provider/server/ECSoapServerConnection.cpp
+++ b/provider/server/ECSoapServerConnection.cpp
@@ -160,7 +160,8 @@ static int ignore_shutdown(struct soap *, SOAP_SOCKET, int shuttype)
 }
 
 static void custom_soap_bind(struct soap *soap, const char *bindspec,
-    bool v6only, int port)
+    bool v6only, int port = 0, int mode = -1, const char *user = nullptr,
+    const char *group = nullptr)
 {
 #if GSOAP_VERSION >= 20857
 	/* The v6only field exists in 2.8.56, but has no effect there. */
@@ -168,7 +169,7 @@ static void custom_soap_bind(struct soap *soap, const char *bindspec,
 #endif
 	soap->sndbuf = soap->rcvbuf = 0;
 	soap->bind_flags = SO_REUSEADDR;
-	auto ret = ec_listen_generic(bindspec, &soap->master);
+	auto ret = ec_listen_generic(bindspec, &soap->master, mode, user, group);
 	if (ret < 0) {
 		ec_log_crit("Unable to bind to %s: %s. Terminating.", bindspec,
 			soap->fault != nullptr ? soap->fault->faultstring : strerror(errno));
@@ -258,11 +259,15 @@ ECRESULT ECSoapServerConnection::ListenPipe(const char* lpPipeName, bool bPriori
 	std::unique_ptr<struct soap, ec_soap_deleter> lpsSoap(soap_new2(SOAP_IO_KEEPALIVE | SOAP_XML_TREE | SOAP_C_UTFSTRING, SOAP_IO_KEEPALIVE | SOAP_XML_TREE | SOAP_C_UTFSTRING));
 	if (lpsSoap == nullptr)
 		return KCERR_NOT_ENOUGH_MEMORY;
-	if (bPriority)
+	unsigned int mode = S_IRWUG;
+	if (bPriority) {
 		kopano_new_soap_listener(CONNECTION_TYPE_NAMED_PIPE_PRIORITY, lpsSoap.get());
-	else
+	} else {
 		kopano_new_soap_listener(CONNECTION_TYPE_NAMED_PIPE, lpsSoap.get());
-	custom_soap_bind(lpsSoap.get(), lpPipeName, false, 0);
+		mode |= S_IROTH | S_IWOTH;
+	}
+	custom_soap_bind(lpsSoap.get(), lpPipeName, false, 0, mode,
+		m_lpConfig->GetSetting("run_as_user"), m_lpConfig->GetSetting("run_as_group"));
 	/* Manually check for attachments, independent of streaming support. */
 	soap_post_check_mime_attachments(lpsSoap.get());
 	m_lpDispatcher->AddListenSocket(std::move(lpsSoap));
diff --git a/spooler/DAgent.cpp b/spooler/DAgent.cpp
index 6b21209aa..553a1d48b 100644
--- a/spooler/DAgent.cpp
+++ b/spooler/DAgent.cpp
@@ -2841,7 +2841,8 @@ static int dagent_listen(ECConfig *cfg, std::vector<struct pollfd> &pollers,
 	pollers.reserve(lmtp_sock.size());
 	closefd.reserve(lmtp_sock.size());
 	for (const auto &spec : lmtp_sock) {
-		auto ret = ec_listen_generic(spec.c_str(), &x.fd, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
+		auto ret = ec_listen_generic(spec.c_str(), &x.fd, S_IRWUG | S_IROTH | S_IWOTH,
+		           cfg->GetSetting("run_as_user"), cfg->GetSetting("run_as_group"));
 		if (ret < 0) {
 			ec_log_err("Listening on %s failed: %s", spec.c_str(), strerror(-ret));
 			return ret;
-- 
2.21.0

