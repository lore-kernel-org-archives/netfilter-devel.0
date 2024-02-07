Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0AB24208
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317431; cv=none; b=AW2Gbks5ue1XqdxZ6ZGdqOoL2oEm/wASBxQRnkAJ+cFdGrqYCd1uSPt8NGN7GnBeAiAgpTo89rJt5K9P0/5xolRcSsvdQgRCxcfruwGr4RlmbLWmFiQjOAHcSOPMunsGhSDWADt8qL8XbylrS6fwAJbx29ALDB/1bTnfBljgpTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317431; c=relaxed/simple;
	bh=z7vOH20uxyDHn3JCapkbk8U8szhYMBeXxG8tKYeyxLs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gYyHLyqcNdxQzmWEEDY6NJh9l02t1O/46HJ5uYS5clTDKSuwfe97UYx4A851GhbASV0yR4p1FA2PHGs2bBOJP3NUovTPXVzFsGSyaeoB3aoCDJ+s90/MAH+EJl0ULOkbPZ4MEorBR/Jr+2Pm9jFE3mcOcPjRG1UrfxqKoM8B4p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr; spf=pass smtp.mailfrom=green-communications.fr; arc=none smtp.client-ip=212.227.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=green-communications.fr
Received: from mail.qult.net ([78.193.33.39]) by mrelayeu.kundenserver.de
 (mreue009 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1MPooN-1rJlB00Bfv-00Mwnd for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb
 2024 15:50:21 +0100
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.90_1)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1rXjFk-0005xX-JA
	for netfilter-devel@vger.kernel.org; Wed, 07 Feb 2024 15:50:20 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.96)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1rXjFd-00HPst-1B
	for netfilter-devel@vger.kernel.org;
	Wed, 07 Feb 2024 15:50:13 +0100
Date: Wed, 7 Feb 2024 15:50:13 +0100
From: Ignacy =?utf-8?B?R2F3xJlkemtp?= <ignacy.gawedzki@green-communications.fr>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack] conntrack: don't print [USERSPACE] information in
 case of XML output
Message-ID: <20240207145013.xzdc6kudqwinzdbt@zenon.in.qult.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ux6QimwUndIQXe3hKoyx/OHpWovvZHxvcOp1BdBCHRBEAGBDkv3
 O4irPCSRxSd5mch8WjxwOO34kYphH3KfQf4CgV+G/i2EHz/dvKZa9g+uC2EPae/oddCS0eM
 7lMTQYW2KNxjzC1qwHN0tbINQXIQybdUDSYf8KySgISknPO2B0vlclnriwU9nMPHPo8wmI8
 DSMaoPvG9tZbqbNjBPqQQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZOky/kESXck=;DxQR6hVdAi8r8B7wDrwi8Lj3fcQ
 EvQo4WNNtirBTOf5iJoGHMQewinmUUhDC3KotgYSOfsx745w87YrYCYwGFac+BV8c+aUFaYz2
 vwCbBBIi1WGW17VEoY4Qdd/VjwrcFvHrqIc2q4W3fr9TZeo/Evr89hKus08JnsKZ+c2/HO3lb
 3akt5Sl5ecEINcn1gH1kqQEOJOWU40YChRjWhKOKsMNEHsDRWIE/XMrZzzq4HnofU8K2Y9IRP
 8VgEsAzKHc1jjpU06R1foQQEblO/lgWYfxyg/QUQUA7X87rBFrKfcUNDglB+ucyZRuM89Qqrc
 zURhKAk+iUqle0pvprvsAfzSVDfeTOE5/OQfA84WbXmB8cgynpVcFafW8eaGJbrRg6nw19WnH
 ZbtrfcqaDb5SM3EE3riFX3fE+770YfTGRpmT/9CqxTOWEAMij4PbldgkgEbR0XLrNyOnxTej4
 N/fc/PQf+r3EvA1e0BH1rFYFWWmTXo9iRDi2dFcwuHFy5G/Z1LgUAd+0F+h9aGlUKYvLUREJa
 bgN29o1YcD7xD5W9kjtZCJjW9bcjCsESe/rgSzJ7vJ+ne4wugUWt9BKTETWmUNL+kH01jOpQD
 bJuJItItQTnalRZQc414OWe4pYz7HeX2t4vr0Ewc3jk/Dq0bCDhuRyO05jbGLzEQ28ksjx27b
 NlAcAth8DKTg7CwtwfPuz6mEIdjvo+CdzNWeU3Py0M44jWiMcESQ0H3quQgdzFZShX1MIYvuQ
 Y7VDsUGQRk9qUBTVFG3AYjr+5gHwdxFyIu3NGjlBjF1TQiLf2kb9rU=

In case XML output is requested, refrain from appending "[USERSPACE]"
and details to the output.

Signed-off-by: Ignacy Gawêdzki <ignacy.gawedzki@green-communications.fr>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index c1551ca..0d71352 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1944,7 +1944,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, type, op_type, op_flags, labelmap);
 done:
-	if (nlh->nlmsg_pid) {
+	if (nlh->nlmsg_pid && !(output_mask & _O_XML)) {
 		char *prog = get_progname(nlh->nlmsg_pid);
 
 		if (prog)
-- 
2.40.1
