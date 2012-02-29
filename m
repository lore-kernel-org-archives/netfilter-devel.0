From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] const-ify static data objects
Date: Wed, 29 Feb 2012 08:15:38 +0100
Message-ID: <1330499742-28091-3-git-send-email-jengelh@medozas.de>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48517 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966113Ab2B2HPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:50 -0500
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/libnetfilter_cttimeout.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/libnetfilter_cttimeout.c b/src/libnetfilter_cttimeout.c
index 2f1ba79..6050514 100644
--- a/src/libnetfilter_cttimeout.c
+++ b/src/libnetfilter_cttimeout.c
@@ -21,7 +21,7 @@
 
 #include <libnetfilter_cttimeout/libnetfilter_cttimeout.h>
 
-static char *tcp_state_to_name[] = {
+static const char *const tcp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_TCP_SYN_SENT]	= "SYN_SENT",
 	[NFCT_TIMEOUT_ATTR_TCP_SYN_RECV]	= "SYN_RECV",
 	[NFCT_TIMEOUT_ATTR_TCP_ESTABLISHED]	= "ESTABLISHED",
@@ -35,16 +35,16 @@ static char *tcp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_TCP_UNACK]		= "UNACKNOWLEDGED",
 };
 
-static char *generic_state_to_name[] = {
+static const char *const generic_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_GENERIC]		= "TIMEOUT",
 };
 
-static char *udp_state_to_name[] = {
+static const char *const udp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_UDP_UNREPLIED]	= "UNREPLIED",
 	[NFCT_TIMEOUT_ATTR_UDP_REPLIED]		= "REPLIED",
 };
 
-static char *sctp_state_to_name[] = {
+static const char *const sctp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_SCTP_CLOSED]			= "CLOSED",
 	[NFCT_TIMEOUT_ATTR_SCTP_COOKIE_WAIT]		= "COOKIE_WAIT",
 	[NFCT_TIMEOUT_ATTR_SCTP_COOKIE_ECHOED]		= "COOKIE_ECHOED",
@@ -54,7 +54,7 @@ static char *sctp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_SCTP_SHUTDOWN_ACK_SENT]	= "SHUTDOWN_ACK_SENT",
 };
 
-static char *dccp_state_to_name[] = {
+static const char *const dccp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_DCCP_REQUEST]	= "REQUEST",
 	[NFCT_TIMEOUT_ATTR_DCCP_RESPOND]	= "RESPOND",
 	[NFCT_TIMEOUT_ATTR_DCCP_PARTOPEN]	= "PARTOPEN",
@@ -64,14 +64,14 @@ static char *dccp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_DCCP_TIMEWAIT]	= "TIMEWAIT",
 };
 
-static char *icmp_state_to_name[] = {
+static const char *const icmp_state_to_name[] = {
 	[NFCT_TIMEOUT_ATTR_ICMP]		= "TIMEOUT",
 };
 
 static struct {
 	uint32_t nlattr_max;
 	uint32_t attr_max;
-	char **state_to_name;
+	const char *const *state_to_name;
 } timeout_protocol[IPPROTO_MAX] = {
 	[IPPROTO_ICMP]	= {
 		.nlattr_max	= __CTA_TIMEOUT_ICMP_MAX,
-- 
1.7.7

