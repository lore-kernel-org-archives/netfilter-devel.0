From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] state: report spaces in the state list parsing
Date: Wed, 19 Nov 2008 11:11:48 +0100
Message-ID: <4923E664.5020602@netfilter.org>
References: <20081118234311.15750.80335.stgit@Decadence> <20081118234336.15750.52780.stgit@Decadence> <alpine.LNX.1.10.0811191029090.30388@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010109050401030204080300"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53805 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753499AbYKSKPJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:15:09 -0500
In-Reply-To: <alpine.LNX.1.10.0811191029090.30388@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010109050401030204080300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Wednesday 2008-11-19 00:43, Pablo Neira Ayuso wrote:
> 
>> Now this returns:
>>
>> iptables v1.4.2-rc1: `--state' requires a list of states with no
>> spaces, e.g. ESTABLISHED,RELATED
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>>
>> extensions/libxt_state.c |    5 ++++-
>> 1 files changed, 4 insertions(+), 1 deletions(-)
> 
> This also needs to be done for libxt_conntrack.c I guess.

Thanks for the spot, new patch attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010109050401030204080300
Content-Type: text/x-diff;
 name="fix-state-parsing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-state-parsing.patch"

state: report spaces in the state list parsing

From: Pablo Neira Ayuso <pablo@netfilter.org>

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

This patch also applies to libxt_conntrack which has a copy of the
function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 extensions/libxt_conntrack.c |    5 ++++-
 extensions/libxt_state.c     |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 79ed3b8..5f3257c 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -107,7 +107,10 @@ parse_states(const char *arg, struct xt_conntrack_info *sinfo)
 			exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
 		arg = comma+1;
 	}
-
+	if (!*arg)
+		exit_error(PARAMETER_PROBLEM, "`--ctstate' requires a list of "
+					      "states with no spaces, e.g. "
+					      "ESTABLISHED,RELATED");
 	if (strlen(arg) == 0 || !parse_state(arg, strlen(arg), sinfo))
 		exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
 }
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

--------------010109050401030204080300--
