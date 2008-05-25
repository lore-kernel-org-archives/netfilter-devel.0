From: Kristof Provost <Kristof@sigsegv.be>
Subject: [PATCH] Bugzilla 482: Allow symbolic port in REDIRECT --to-port
Date: Sun, 25 May 2008 19:40:48 +0000
Message-ID: <20080525194048.GB22406@nereid>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhineheart.priorweb.be ([213.193.229.215]:45513 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754580AbYEYTj0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 May 2008 15:39:26 -0400
Received: from triton.sigsegv.be (dD5769270.access.telenet.be [213.118.146.112])
	by rhineheart.priorweb.be (Postfix) with ESMTP
	for <netfilter-devel@vger.kernel.org>; Sun, 25 May 2008 21:39:20 +0200 (CEST)
Received: from nereid (unknown [172.16.0.8])
	by triton.sigsegv.be (Postfix) with SMTP id 8D67D1D964
	for <netfilter-devel@vger.kernel.org>; Sun, 25 May 2008 19:39:44 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Signed-off-by: Kristof Provost <kristof@sigsegv.be>
- ---
 extensions/libipt_REDIRECT.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index b4c73bb..c03562b 100644
- --- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -49,6 +49,9 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 		exit_error(PARAMETER_PROBLEM, "IP address not permitted\n");
 
 	port = atoi(arg);
+	if (port == 0)
+		port = service_to_port(arg, NULL);
+
 	if (port == 0 || port > 65535)
 		exit_error(PARAMETER_PROBLEM, "Port `%s' not valid\n", arg);
 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIOcDAUEZ9DhGwDugRAlRNAJ9pWRB+JNhJtNzCmtoioWeISdScPwCeJiCi
b3D0yAzePmT52f37CM88MrA=
=Vph2
-----END PGP SIGNATURE-----
