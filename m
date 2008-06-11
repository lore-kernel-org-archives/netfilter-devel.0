From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Wed, 11 Jun 2008 15:25:51 +0200
Message-ID: <484FD25F.2010800@netfilter.org>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080306020909070006040404"
Cc: netfilter@vger.kernel.org, sabelka@iue.tuwien.ac.at,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Marco Barbero <marco.barbero@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47558 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754172AbYFKNTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:19:04 -0400
In-Reply-To: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080306020909070006040404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marco,

Marco Barbero wrote:
> conntrack-tools-0.9.7
> libnetfilter_conntrack-0.0.94
> libnfnetlink-0.0.38
> 
> kernel 2.6.25.5
> Mode ALARM
> 
> conntrackd -c from node master:
> 
> looking logs:
> 
> a lot of  [ERROR] commit: Invalid argument
> Mon Jun  9 15:01:26 2008        tcp      6 180 TIME_WAIT
> src=192.168.200.14 dst=62.149.195.137 sport=47144 dport=80 src=x.x.x.x
> dst=192.168.200.14 sport=80 dport=47144 [ASSURED] mark=0
> 
> and at the end:
> 
> [Mon Jun  9 15:01:26 2008] (pid=13176) [notice] Committed 1172 new entries
> [Mon Jun  9 15:01:26 2008] (pid=13176) [notice] 3294 entries can't be committed
> 
> Any hints?

Are your scripts committing the entries twice (ie. invoking conntrackd 
-c several times)? The only way to reproduce this that I have found is 
to double insert an existing conntrack with some NAT handling. In the 
upcoming 2.6.26 you'll get a EBUSY instead of EINVAL which sounds more 
reasonable.

Anyhow, does the patch attached fix this behaviour? The idea behind it 
is to check if there is a conntrack present in kernel, if so, just 
update the attributes of the conntrack object that are changeable to 
avoid the error. Would you mind testing it?

> [...]
> solved kernel panic issues but still I got 'entries can't be committed'
> [ERROR] commit: Invalid argument

Patrick posted a patch to netfilter-devel to fix the kernel panics. He 
has also passed it to -stable.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------080306020909070006040404
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/cache_iterators.c b/src/cache_iterators.c
index c26d349..2fe7278 100644
--- a/src/cache_iterators.c
+++ b/src/cache_iterators.c
@@ -91,20 +91,29 @@ static int do_commit(void *data1, void *
 	 */
 	nfct_set_attr_u32(ct, ATTR_TIMEOUT, CONFIG(commit_timeout));
 
-	ret = nl_create_conntrack(ct);
-	if (ret == -1) {
-		switch(errno) {
-			case EEXIST:
-				c->commit_exist++;
-				break;
-			default:
-				dlog(LOG_ERR, "commit: %s", strerror(errno));
-				dlog_ct(STATE(log), u->ct, NFCT_O_PLAIN);
-				c->commit_fail++;
-				break;
-		}
-	} else {
-		c->commit_ok++;
+	ret = nl_exist_conntrack(ct);
+	switch (ret) {
+	case -1:
+		dlog(LOG_ERR, "commit-exist: %s", strerror(errno));
+		dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
+		break;
+	case 0:
+		if (nl_create_conntrack(ct) == -1) {
+			dlog(LOG_ERR, "commit-create: %s", strerror(errno));
+			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
+			c->commit_fail++;
+		} else
+			c->commit_ok++;
+		break;
+	case 1:
+		c->commit_exist++;
+		if (nl_update_conntrack(ct) == -1) {
+			dlog(LOG_ERR, "commit-update: %s", strerror(errno));
+			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
+			c->commit_fail++;
+		} else
+			c->commit_ok++;
+		break;
 	}
 
 	/* keep iterating even if we have found errors */

--------------080306020909070006040404--
