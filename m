Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4983D9DCB
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225846; cv=none; b=mG/epMk/2dkvS9LNZNrzdxxa90pCGaoM4DIlwd3kyEH/oIR4ZXyggKVcYQq8NFRVk75ESLTgrtkhOkqrJ69uPofOI4vyxljtBaRdc8fKf165HCFb64IVDPvknhRiMwG0FRMWjh7y+Ufvl5Jj6SNFbhN6+lT0XxlLoY9N/rIZq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225846; c=relaxed/simple;
	bh=XZxRbYNB+p8MYv18ejMQ4A6b45jzlV4FremS2KhPQ9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WAUaDYASl0m9/Cm+MBnEm3pi1RA4M8W4JouMtsBXynxX/lcRcLRiiqBDGKg/Bwf6KgObyQso4y9NofBosYsyHJ2lSJ6ThBgPoWX5SykNC++Xp5bkG5lAhT8Kh7fFkIX8qk1Kp7jGvLLncwczAUn9zN9HIpgq5mUDv5znrKYarag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NB8Q9UYc; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NB8Q9UYc"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67be41d5eeeso7135063a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 14:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779225843; x=1779830643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nPKRLa3wLXnIh4n1MboCUOELValbCWPOOcATx5jo12c=;
        b=NB8Q9UYcygv0OIEymIvT9a6PCp05ij/iH2qfOHDqyLcQUAwGpU5KE9ihFHdoU7jmQm
         a2ro741XH0GBb8gwbJFl8zEZxXze8DwRHdJChKN8ERVo+eyL9qXjld2vY3tKDs85i3Hd
         kuoZjMVJxYYwOxlOEcUWOjBMjSKIwNkQ4T/VJcdge/7otuy6ORASC+Dd+ME8UqH+5yBi
         4Vptnt5JZMPM2ZL9/W9da2MGQmj7H7IIAhtm8dBnq9vZMhIvtQNaxqeCenlkIKVK8ZiH
         clQFhTy+u+KmivMxQzHKzRmypI9pygJcZp/Nkq9rR1lAbfDd5eTSxhhH42ooj4fDLfVh
         iEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779225843; x=1779830643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPKRLa3wLXnIh4n1MboCUOELValbCWPOOcATx5jo12c=;
        b=Wp+xQGN9WrX0ovlS8P4l8T/nNV+g0Zb2b3aAqp43KyDUP/fdd/RJdwfRUF4EtR7X33
         D7aRJCCSKqb6iCgpj5GdQJcofGH7LzqenKEHfNzvxb7MPn91CuAWQUZHV+bKlmDfzm/M
         rqRCrrIFB8lMvubz5DgmsF9UEwRJPe+iJ4zhzTJ3JAZY7vYrT/PUi8k6syZhAe//FCSb
         lBPiEw0sIdSjPc3D8v6zj/gGofha7tccYbncpMeFI9dnWgquyQTMpzaMWMIijSQH5X3Z
         TyetKytH9gCM/f3fwuZ58nJ1mmlXlC0y0VIwJc1VUjSzICt5nvJQNjMYJRW/4Rvp22bk
         70QQ==
X-Forwarded-Encrypted: i=1; AFNElJ8abvNFYlZDX5MWm1lwuToCRzMeWKbk5dw3OlkF/DlW+3vIYZS18LJaYKvFPLKtAzrkD3fEf8ZlOZLE4pvi148=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx59M2FaGcEAWldp+IpSMJLH7pSN6Ac56HaeZ7f4LDnCNENmMNW
	N0Nt2LBJNC82phu4EXH8b+jxPB6gX0VdJkBV43X5ubJlA6D6KQRS2gVrc/OJFOs70zPFoQ==
X-Gm-Gg: Acq92OEDBivU62wLuDpFBZ5XTSpFtjEZ7NrmoL3ff0IhYXcReSLpTyRgVKpf9VGtnY3
	1ksn58qzXrvl5DEzeOdjEfBdThhkUD5W+pBDARwsC1ikTrFhUWf/XpC0q9kVQjGe712umXJDtuF
	QbhIU7cON6HTCDLhWVQVn8PgF3j4vsYbiEGkmpf7Zq6aXcYgkm+ogqlGWDMVn1KlcuI/mq1d3Ab
	14GieAS4KfhEP1Zf+eJ4HGn9NgPAZaPsJBHhhD7D84VLNaFd8hJUP/SZldhZ3POfuJHlTMYyLfh
	46nTneXwo85Hh84rxdIYdMSop3R7JNsnheGrhFUjA6GJoLyjPAN0sZwbzYvpis3OzsYegbIFeH+
	JDNdQVBbH9zdgu+DOtrjHADYuMzEqmq7bt/GD0TFGeorGCRqt2FMhJdvfAG1rJCYj27FzlTFTh7
	RWYELu5x6DeyLJibkBo3p2vnnXwcfS7DF5P2r0wvKhq5hXpy87Oq77WZKph1Qh13/rh2nWtxmIY
	w==
X-Received: by 2002:a05:6402:1d88:b0:679:223c:d181 with SMTP id 4fb4d7f45d1cf-683bd096b2dmr8279933a12.15.1779225843297;
        Tue, 19 May 2026 14:24:03 -0700 (PDT)
Received: from node ([202.47.63.86])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6831187d5f0sm6891416a12.28.2026.05.19.14.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 14:24:02 -0700 (PDT)
From: Muhammad Bilal <meatuni001@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
Date: Tue, 19 May 2026 17:23:28 -0400
Message-ID: <20260519212328.28290-1-meatuni001@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dcc() treats data_end as an inclusive end pointer, but its only
caller passes data_limit = ib_ptr + datalen, which points one past the
last valid byte.

The newline search loop iterates while tmp <= data_end, so when no
newline is present, *tmp is read at tmp == data_end, one byte beyond
the region filled by skb_header_pointer().

irc_buffer is kmalloc'd as MAX_SEARCH_SIZE + 1 bytes and datalen is
capped at MAX_SEARCH_SIZE, so the stray read does not fault.  The byte
is uninitialized or stale; if it contains an ASCII digit, simple_strtoul
will consume it and produce a wrong DCC IP or port in the conntrack
expectation.  The extra allocation byte is also a fragile guard: if the
cap or allocation size changes, this becomes a real out-of-bounds read.

Change the loop and its post-loop check to use strict less-than,
consistent with the caller's exclusive-end convention.  Update the
function comment accordingly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
---
 net/netfilter/nf_conntrack_irc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 522183b9a..9a7b8f622 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -59,7 +59,7 @@ static const char *const dccprotos[] = {
 /* tries to get the ip_addr and port out of a dcc command
  * return value: -1 on failure, 0 on success
  *	data		pointer to first byte of DCC command data
- *	data_end	pointer to last byte of dcc command data
+ *	data_end	one past end of data
  *	ip		returns parsed ip of dcc command
  *	port		returns parsed port of dcc command
  *	ad_beg_p	returns pointer to first byte of addr data
@@ -77,10 +77,10 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 
 	/* Make sure we have a newline character within the packet boundaries
 	 * because simple_strtoul parses until the first invalid character. */
-	for (tmp = data; tmp <= data_end; tmp++)
+	for (tmp = data; tmp < data_end; tmp++)
 		if (*tmp == '\n')
 			break;
-	if (tmp > data_end || *tmp != '\n')
+	if (tmp >= data_end || *tmp != '\n')
 		return -1;
 
 	*ad_beg_p = data;
-- 
2.54.0

