From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 6/7] allow empty strings in argument parser
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.68280.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:54073 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753048AbYA0SkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:40:17 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 ip6tables-restore.c |   12 +++++-------
 iptables-restore.c  |   12 +++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)


diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index f9d97ef..ff6b989 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -366,14 +366,12 @@ int main(int argc, char *argv[])
 			for (curchar = parsestart; *curchar; curchar++) {
 				char param_buffer[1024];
 
-				if (escaped) {
-					param_buffer[param_len++] = *curchar;
-					escaped = 0;
-					continue;
-				}
-
 				if (quote_open) {
-					if (*curchar == '\\') {
+					if (escaped) {
+						param_buffer[param_len++] = *curchar;
+						escaped = 0;
+						continue;
+					} else if (*curchar == '\\') {
 						escaped = 1;
 						continue;
 					} else if (*curchar == '"') {
diff --git a/iptables-restore.c b/iptables-restore.c
index d0d3bd7..8e1b638 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -373,14 +373,12 @@ main(int argc, char *argv[])
 			for (curchar = parsestart; *curchar; curchar++) {
 				char param_buffer[1024];
 
-				if (escaped) {
-					param_buffer[param_len++] = *curchar;
-					escaped = 0;
-					continue;
-				}
-
 				if (quote_open) {
-					if (*curchar == '\\') {
+					if (escaped) {
+						param_buffer[param_len++] = *curchar;
+						escaped = 0;
+						continue;
+					} else if (*curchar == '\\') {
 						escaped = 1;
 						continue;
 					} else if (*curchar == '"') {


