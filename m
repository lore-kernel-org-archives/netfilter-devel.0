From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH] nfacct: correct regressions in v1.0.1
Date: Tue, 05 Mar 2013 12:47:51 +0000
Message-ID: <5135E977.1000905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52828 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CEMsB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:48:01 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so5492165wgb.25
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2013 04:48:00 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes regressions present in v1.0.1, introduced as a result of
commit d17c772c98057b2cc0118274605d292809ff6b1e.


Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
  src/nfacct.c |    5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index 4ce817d..21d4df8 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -218,7 +218,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
  	return 0;
  }

-static int _nfacct_cmd_add(char *name, int pkts, int bytes)
+static int _nfacct_cmd_add(char *name,
+			   long long unsigned pkts, long long unsigned bytes)
  {
  	struct mnl_socket *nl;
  	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -536,7 +537,7 @@ static int nfacct_cmd_restore(int argc, char *argv[])
  			return -1;
  		}
  		*semicolon = 0;
-		ret = sscanf(buffer, "{ pkts = %lu, bytes = %lu } = %s",
+		ret = sscanf(buffer, "{ pkts = %llu, bytes = %llu } = %s",
  		       &pkts, &bytes, name);
  		if (ret != 3) {
  			nfacct_perror("error reading input");


