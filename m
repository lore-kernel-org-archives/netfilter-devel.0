Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774C93A75B9
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775830130; cv=none; b=dTCC7jvLrbLWGaqSHRw5kZR5HuQkXMwt/gcP4rtPWxDmdaO0QTc8Wvo5hj4m8hJUXsonHvU0G4/vtpImR6SQlpsX5xGHZfr3N1pdbETfGNJ4JIAIPaRoxyrOJEXQ8bTZk4ab3IlI/xtRft6n2AU0k8UY23iwlUcMGihfqGPZZ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775830130; c=relaxed/simple;
	bh=Jfy2usjb7LD5diX+bK57ihlhuNRqd/S/obMi4Uou+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B7oSQuGlDNxZStWFF3GfKZthQhfIOQwCZ7tAMqgGdtJ3vJmjp5wDubvVzgWPvTubMQ31/imBSq5OtCcxL06lOb7ufi3BWUUxvVrPnhxs98CBYa2i1INU9tdGJiJ8BEYo3qCASKoiVH4KYIiacOyilogAnPCiyYoxvCakVcORTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7RvrodS; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7RvrodS"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d572f7437so1448855f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 07:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775830128; x=1776434928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aK+3YdeKNNJBdXuNMI1GNmLQlCMgDOjeM6utJ1G5yTg=;
        b=Z7RvrodS43h+b1+a6//5902vMsOLFTUeqfXODh3+vqshZhF1J7XFE6ti4wpv9HQLGG
         e1v4URDjXalZ/QhJr0BgY7RhErT3SppFbtndcIvpMsMfl7vvLWVZmqhhEMBKrp52qiJ9
         07CRMaHPP4NEJ0v3sIFAr8sblrzSnrnXKM8+MrkMKbBIs1OS57qliAByf1Y8DikMvLJj
         7l5QYfA9n9IHPf81PnWwv1h3xkCC7N/KnsIGJleqaV9m0M8GtPpBDKEO21gdeUyqimbz
         8dkvBebDLRbJ22P8c8Svfe7cA6N+A4pH5tgeqxw+srVy7XWSXJ+aAsK+SGJpeHpVErpm
         Fcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775830128; x=1776434928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aK+3YdeKNNJBdXuNMI1GNmLQlCMgDOjeM6utJ1G5yTg=;
        b=jsYvITTV39VQt51OxBuF0fuExeyG5d4euHEf/s+TySEfZ3wclcqOkNKIBCa2cqB8CN
         4UVMYm4ej0DIm/gmCwJ0XtCys/FO7MhNyKeEgY4QnAINtklxap0okLgD9pv9mLJOFFN2
         W9zgt1GvvJcS+Kh8h24q9mjyoXjHnxTq4xJ+6FdZMFfyNEYpxbTgTINiaRLtAYTPlbcZ
         6IfccTcfhjTVleyQr6ebWjn//DtGGWB+AVLsXyzPf1bggBazZRribFwNC63V+LK3co1f
         Pn1Q0t8YHbUDlrS7qjR0FaB3K1AmeqeNQRDXzfMMY+pQtZx9gJTzqi5P1QikNTPy0RhN
         AFeg==
X-Gm-Message-State: AOJu0YwitxGacopXrGhaNIt+PXk4ETnr/edg28KA3e8xFcuzyZfqM7Xn
	O4Wg4+nXDbMBS33Lk1ZNDj36ni8GObJ3I/Wg+lzdr3hA+fDuVKreRG9TphZfas8sd5kYVw==
X-Gm-Gg: AeBDievUU3JnbzA46PekAHBV5cy547Tv+p0PpCkL4q4ICgbkUedLnLzXyqNLa3r18OG
	DN1XqmJ/ahWv2FsY20Di0sQwcVH5N/72+pRzGk9pAoQPrsqbEujp+3whVpcApt72Nhd7IQ1Rv1k
	V3cnANZLB8RiAuXVDauuZXPwAQRR7f4fvzFyS7c+nEFRW30rNIbwsY0H2e7GCKCAqR61SA7bIE3
	ZqwAd4oa/7Dyu5EeQpAd7mVWB6DpHrlq1z8EzB3jKBeF9ztv74L8LuJ6vrBwoFSNBcedZKijDnX
	UTEykAzQPDA9IoP8BwT93c8CsRkne3vHkeJ7YK4t2HrKwWot+Zs5UJzN9mHVXlXNhzKHdiqUXTf
	DT4xWUMqhwtU6i/faGU0E/a7mUtGM9CUAjYPtWTKiwK3JL1mdxBAX2bDNTMF54yGoNErnHUQIAi
	G2DProMauCuagJPfae9aVEH4TAE/QCaDPYCLDq/Fach20+fmBD7xZxe4I0HknQbK2c/bEp
X-Received: by 2002:a05:6000:2403:b0:43d:4b00:9ee7 with SMTP id ffacd0b85a97d-43d642d1b1cmr4856702f8f.33.1775830127576;
        Fri, 10 Apr 2026 07:08:47 -0700 (PDT)
Received: from kali.station (net-2-39-22-72.cust.vodafonedsl.it. [2.39.22.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e462fdsm7276172f8f.22.2026.04.10.07.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 07:08:47 -0700 (PDT)
From: Cyber-JA <giuseppecaruso0990@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Cyber-JA <giuseppecaruso0990@gmail.com>
Subject: [PATCH 2/2] netfilter: validate values parsed by try_number
Date: Fri, 10 Apr 2026 10:08:43 -0400
Message-ID: <20260410140843.52027-1-giuseppecaruso0990@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

try_number() parses comma-separated decimal values from FTP PORT and
EPRT commands into a u_int32_t array, but does not validate that each
value fits in a single octet. RFC 959 specifies that PORT parameters
are decimal integers in the range 0-255, representing the four octets
of an IP address followed by two octets encoding the port number.

Values exceeding 255 are silently accepted. In try_rfc959(), the raw
u32 values are combined via shift-and-OR to form the IP and port:

  cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16) |
                     (array[2] << 8) | array[3]);
  cmd->u.tcp.port = htons((array[4] << 8) | array[5]);

When array elements exceed 255, bits from one field bleed into adjacent
fields after shifting, producing IP addresses and port numbers that
differ from what the text representation suggests. For example,
"PORT 10,0,1,2,256,22" yields port (256<<8)|22 = 65558, truncated to
u16 = 22. This mismatch between the textual and computed values can
confuse network monitoring tools that parse FTP commands independently.

Reject the command by returning 0 (no match) when any accumulated
value exceeds 255.

Signed-off-by: Giuseppe Caruso <giuseppecaruso0990@gmail.com>
---
 net/netfilter/nf_conntrack_ftp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 5e00f9123c38..12a6d9dd16a5 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -126,6 +126,10 @@ static int try_number(const char *data, size_t dlen, u_int32_t array[],
 	for (i = 0, len = 0; len < dlen && i < array_size; len++, data++) {
 		if (*data >= '0' && *data <= '9') {
 			array[i] = array[i]*10 + *data - '0';
+			if (array[i] > 255) {
+				pr_debug("try_number: %u > 255\n", array[i]);
+				return 0;
+			}
 		}
 		else if (*data == sep)
 			i++;
-- 
2.53.0

