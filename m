From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] state: report spaces in the state list parsing
Date: Wed, 19 Nov 2008 00:43:36 +0100
Message-ID: <20081118234336.15750.52780.stgit@Decadence>
References: <20081118234311.15750.80335.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53138 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752158AbYKRXns (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:43:48 -0500
In-Reply-To: <20081118234311.15750.80335.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds better error reporting when the user inserts a space
between two states with the --state option.

iptables -I INPUT -m state ESTABLISHED, RELATED
                                       ^
				  mind the space

results in:

iptables v1.4.2-rc1: Bad state `'
Try `iptables -h' or 'iptables --help' for more information.

Now this returns:

iptables v1.4.2-rc1: `--state' requires a list of states with no
spaces, e.g. ESTABLISHED,RELATED

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 extensions/libxt_state.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 3af2e48..ae8ae7b 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -54,7 +54,10 @@ state_parse_states(const char *arg, struct xt_state_info *sinfo)
 			exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
 		arg = comma+1;
 	}
-
+	if (!*arg)
+		exit_error(PARAMETER_PROBLEM, "`--state' requires a list of "
+					      "states with no spaces, e.g. "
+					      "ESTABLISHED,RELATED");
 	if (strlen(arg) == 0 || !state_parse_state(arg, strlen(arg), sinfo))
 		exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
 }

