From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] Implementation for to test the function for
 exporting chains to JSON format
Date: Sat, 08 Jun 2013 15:36:12 +0200
Message-ID: <20130608133612.10197.37919.stgit@Ph0enix>
References: <20130608133222.10197.21456.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:40600 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab3FHNgQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:36:16 -0400
Received: by mail-we0-f170.google.com with SMTP id w57so3829756wes.29
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jun 2013 06:36:15 -0700 (PDT)
Received: from [127.0.1.1] (89.153.20.95.dynamic.jazztel.es. [95.20.153.89])
        by mx.google.com with ESMTPSA id ft10sm2158269wib.7.2013.06.08.06.36.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 08 Jun 2013 06:36:14 -0700 (PDT)
In-Reply-To: <20130608133222.10197.21456.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Alvaro Neira Ayuso <alvaroneay@gmail.com>


---
 examples/nft-chain-get.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index b815523..459b79e 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -90,8 +90,11 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (strcmp(argv[argc-1], "xml") == 0)
+	if (strcmp(argv[argc-1], "xml") == 0){
 		type = NFT_CHAIN_O_XML;
+	}else if (strcmp(argv[argc-1], "json") == 0){
+		type = NFT_CHAIN_O_JSON;
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {

