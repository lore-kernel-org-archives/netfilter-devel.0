Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=83.166.143.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795271686;
	b=elivWylSN6WeKAiknUhfkPDiOLNr6oB4wfD4wQJOa2pgrCr4Cu7QQlqMzruIQUrUJeDh
	 gFuPeQK1zvGPm62K4fwTrFllcI8F2UUELIHYREJfTfGuXuQFHycLy42ntjwdP9RC26gF4
	 7vyCBU1221NAoY+Z69+t4nOBZN62h73f3j3uMu3db1KYnhmxGhE4+uvQMD9NVeOab0bNQ
	 ECN+xGh6x96I57EBqIiTQln16O+SSCIoAoWVPfbAfKkeFJvCvn2NWA2xGOdlvcpvfjqn4
	 chl8kapz+83kPxsDIsnTSXHhVnta8v2Sf5b0oDvijsgLDX17TE24xbhODHfw9bmcu5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795271686;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=aZvBGzirPSsLR3yXQ3wprP8lYJdjT8YDuavqwECtL+4=;
	b=DUqP5Y8P7pTCz6qFqcHV9546FkXaOUGqaNRjGJ5LG37gS80Ig+gjtKHCX0dKoxJFSA78
	 tb63jagBfXnThzaBcl8N1XEMAQ5ZBJ7xCU4FeSTBjhYWm6gJ82UkbHzuSSEy+cgE5R404
	 TEbT/F4BIy0yxBJw3S8D2fw0yh9Z6p5Cmo7urBJ5Ipt1Fbc2xSLI3U8wR3w/u5nnicy9+
	 J0V8iPubnjQT/hQDYE7mCLSeZLTWsCFDjJWWIZSk3ER5ZRFmKRiM2+pEVxo7L8eh9ZVlf
	 /XJCesKoPLkksAGZedbaLXpN3RJQjo5Hd42jA4q+xPqISbnvwKLT2vdpHwGoczraqKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=C4QW6wzm;
	arc=none smtp.remote-ip=83.166.143.171
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [83.166.143.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C7606A33A
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 14:34:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE7C7606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=C4QW6wzm
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jWvqL4fLWzcDW;
	Sat, 21 Nov 2026 15:34:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1795271678;
	bh=aZvBGzirPSsLR3yXQ3wprP8lYJdjT8YDuavqwECtL+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4QW6wzmJKOSqcD0Ov9wL8mA3KPKGxEayaTNxMKVrAMzPc5MSNVedh9eZ+PHTgXBp
	 rGs8w3n2mMoxb8Em8UbkFkPDQF8TlbnLnEJw+3nd5bhjLdO9vcRDgQ1uJopj4QSPsj
	 rod1NXJk7MwesVWsnnUj208KOnO2Xgt6ZXbDG/TYNsZU2a5CLzPvrMtUXtHVR1sCYC
	 +DdgUrrbaOHpH+k8TXFN8WLBWzMEDkt5YCPNKpeou2/7cHHjk8Csb795HUzVfI0iQr
	 Xm4hjKEFgsZK2vWMshIoRTTSqK6Fim80LMSgTbMgdp3CBJMalZ6gAN6OLNhqKr5q+U
	 bL+kY7sRuyHOg==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jWvqK5bZzz6f8;
	Sat, 21 Nov 2026 15:34:37 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl v2 2/2] callback: remove the errno sign workaround in mnl_cb_error()
Date: Sat, 21 Nov 2026 15:34:07 +0100
Message-ID: <20261121143407.19426-3-florian.stosse@harvester.fr>
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

The kernel reports the error of an NLMSG_ERROR message as a negative
errno, or 0 for an acknowledgment. mnl_cb_error() also accepts a
positive value, a workaround for very old kernels. Remove it and always
negate the error.

An NLMSG_ERROR with a positive error now sets a negative errno.

Assisted-by: LLM
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---

Notes:
    v2: drop the INT_MIN check and remove the workaround instead, as
    suggested.
    
    The branch that goes is the one for positive values. The kernel sends a
    negative errno (netlink(7): "Negative errno or 0 for acknowledgements"),
    so the negation stays. Two consequences:
    
    - -err->error still overflows for an NLMSG_ERROR whose error is INT_MIN.
      The kernel never sends that value, so only a hand-built message gets
      there. UBSan reports:
      "negation of -2147483648 cannot be represented in type 'int'"
    - A positive error now gives a negative errno.
    
    If you prefer no undefined behaviour at all,
    errno = -(unsigned int)err->error avoids it without a special case.
    I left it out of the patch.

 src/callback.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/src/callback.c b/src/callback.c
index 703ae80..6bd8259 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -24,11 +24,7 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
 		errno = EBADMSG;
 		return MNL_CB_ERROR;
 	}
-	/* Netlink subsystems returns the errno value with different signess */
-	if (err->error < 0)
-		errno = -err->error;
-	else
-		errno = err->error;
+	errno = -err->error;
 
 	return err->error == 0 ? MNL_CB_STOP : MNL_CB_ERROR;
 }
-- 
2.56.0.windows.4

