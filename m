Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.25.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795271684;
	b=QPl8eKOYLzZWkZu+zDFUMgL45P96K9+rDCGrDV3Qs8xgehphVXkr/mD7JhmgmDabBNui
	 M8uPkXOQXvPI9Oc/wG8CJRt8/gHLsVmCNoKSl4xV5Pnaf98CTs43KjPSFsXh93NRpWC5R
	 i2uRK7janaEZO+muhDZvvb83bRxC+jvgxq8bEhstH7nwocHbS3oFXIJbh/Y0mzN2NPFd3
	 bgQPybd2zpajoOr096mLAyRbEIFRn+4JDgkSlGmw0bTNYl6kt36Iw5XhruS6baKFQdZu0
	 uVV26gBCUEvzm2JddgtPowv/6CcMiOCch7c0MINvIVaAf1EUVrOOVOxHdIPzT4EEGxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795271684;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=BzC8uNR1Bz26Zr1bJ1kRnam8fI6ABQyT2mLGoAMpGPk=;
	b=dHdnlmgtKR5O6CnfIKPfb1ilRF29vh4i+Wc3z/x3y15fQIT+V8EvjhmA9aGnocDiguCV
	 ezj9+tFEKF49Z78fk0oy22wgrZMTikYAoqRVceW6dqVjRMOzYN/vhUL0fukLUnavZ0qUN
	 1nNKN0IKzFwU3BMDyI0xpsaH6rH45uow5+96mdOENMutcusBFWg7z/7JGZ0rTTF79vSpK
	 H0vxXxkEPEcfNrDrMUX4B1vogJGW+sY9/8TmFPrlnmeAbJmzGNwZ/zMcTigvoCyPEVZ+U
	 aG/1vuRNSkiVMghyRnDZOmioRKD5hpSPq20Sd4/lHTBb4KLxt/6pOPhQNMy+6Yl09hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=oNl03MFL;
	arc=none smtp.remote-ip=185.125.25.13
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [185.125.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B628606A33F
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 14:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B628606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=oNl03MFL
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jWvqH5lFmzZyH;
	Sat, 21 Nov 2026 15:34:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1795271675;
	bh=BzC8uNR1Bz26Zr1bJ1kRnam8fI6ABQyT2mLGoAMpGPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNl03MFLqfw/g+mpl58Ojulh08EjMlok7AqfBYuHcmPuJsFnChzzbZF9/t7Hf0dqn
	 Q2YoQxD6jCp4UojToSfI+XUIPTfQDRJYFniKjnfoW6ttUsvjZnO9Rz7vMybikkhzO+
	 LX7i1MNuA0tGGIwX0XFROPkqRJ9WAQn39u/KXSbwfXoflQNodSPkerksoHmnn4/EhX
	 a3gkErKboK1XstI4A6DNddRrjqijkdcBi9Cw0AqeQvoaCNOjcgfXMUYbmFulD4HnH0
	 F1zbk9mz5aSr/Xc8QkGxkN0swnOVT8/d6p+3eB2yhoRK3CZq49/USKzXmsZpHlkHHm
	 GA5DIpXrQt6Yw==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jWvqH0WF0z7KQ;
	Sat, 21 Nov 2026 15:34:35 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl v2 1/2] nlmsg: do not read past nlmsg_len in mnl_nlmsg_fprintf()
Date: Sat, 21 Nov 2026 15:34:06 +0100
Message-ID: <20261121143407.19426-2-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261121143407.19426-1-florian.stosse@harvester.fr>
References: <20261121143407.19426-1-florian.stosse@harvester.fr>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

mnl_nlmsg_fprintf_payload() prints the message in 4-byte words while
i < nlmsg_len. mnl_nlmsg_ok() does not require nlmsg_len to be a multiple
of 4, so for an unaligned length the last word reads up to 3 bytes past
the end of the message, and past the buffer when it ends there.

Only print complete words in the loop, then print the 1 to 3 bytes left
over on a last row labelled "trailing bytes", so that the dump shows
them:

| 42 42 42     |	| trailing bytes |

Assisted-by: LLM
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---

Notes:
    v2: print the 1 to 3 bytes left over on a last row labelled
    "trailing bytes" instead of skipping them, as suggested. Aligned messages
    print exactly as before.

 src/nlmsg.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index f8eed79..0db0fa7 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -302,7 +302,7 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
 	if (fdnum != -1)
 		colorize = isatty(fdnum);
 
-	for (i=sizeof(struct nlmsghdr); i<nlh->nlmsg_len; i+=4) {
+	for (i=sizeof(struct nlmsghdr); i + 4 <= nlh->nlmsg_len; i+=4) {
 		char *b = (char *) nlh;
 		struct nlattr *attr = (struct nlattr *) (b+i);
 
@@ -346,6 +346,20 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
 				isprint(b[i+3]) ? b[i+3] : ' ');
 		}
 	}
+	/* nlmsg_len is not a multiple of 4: print the bytes left over. */
+	if (i < nlh->nlmsg_len) {
+		const char *b = (const char *) nlh;
+		unsigned int j;
+
+		fprintf(fd, "|");
+		for (j = i; j < i + 4; j++) {
+			if (j < nlh->nlmsg_len)
+				fprintf(fd, " %.2x", 0xff & b[j]);
+			else
+				fprintf(fd, "   ");
+		}
+		fprintf(fd, "  |\t| trailing bytes |\n");
+	}
 	fprintf(fd, "----------------\t------------------\n");
 }
 
-- 
2.56.0.windows.4

