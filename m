Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0CA12E73
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 08:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710319838; cv=none; b=szj1mWPKkQuG5mC7b7yVUS5ZPCtpB4ATuVXw2khMDA4P0VmQgHxiaRDJfLKNqEG6/HADxKgtmxovqI3/4Ji2aZHWnzknK6wlNMetXKK6u7pmg6scBHbVl9GDPrgyFyz700RTt0lymfGCfLWFnGW10KR7rvPeadgOiEvKDgyLrwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710319838; c=relaxed/simple;
	bh=3FZv8IfFtrSxKsmljOyF8aBns+vfNXXDGDeeGQeA3eY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=QPj8xo/6qSQGyzOUi8DVgvNFpScZGq1u4ME2JHQTRtYP8HK+W8k6/DFD/7aUQf/UqNKKgUmJF8ebXKJ3JbDUhSmJUb1PAJ4TPAQCuNgGiFAR2wRYQFEREHdSrakSOww5oKJX1hU4eXYW7Hx1Lvlt5+rmImT6BGPoxddllWaK+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1i1jJcH; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1i1jJcH"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-690cffa8a0bso18823966d6.0
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 01:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710319836; x=1710924636; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C0R5AMjzO13Vh6jEbH2DLCdOANEpk5NQFwPEaBLdZw4=;
        b=Q1i1jJcHX/GkdWET8C/MGex/bFNql4hIkFNKgBa2vmwo45qSHa3pvbsiaWNhZ5oKaK
         nsxB1HnyBQB0HQ//KRY8yJ72cA8cpM8/8+twuZfekcNCGiZXfYMqmvnu3nK4+gjKP213
         1Liuu5k951KXGQnxCYBsU100qpbykqGx7yfbPnGEfg/aPF0YUKFh9zIDszn6DyJObdaK
         oym8F3HDTOxSK4VsREKRbDhMd4yRGsZ+S9WoihawsBl9GdNMalLndAUXVXo1htfifxnt
         szvwIgrVYJk2HKeubftJESf9CQ1WmFvb6NLt//C6Q21JSkSOIL5hD1fAa8cTs6FvKlk9
         jVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710319836; x=1710924636;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C0R5AMjzO13Vh6jEbH2DLCdOANEpk5NQFwPEaBLdZw4=;
        b=Wb4Y7l8BcYDwLpftV0vrdBfeCi+bR+wxIqEH7lyVjMDVEaUThGHDooEamYc7pVtj7b
         ndbhFe7inTRiGerZnffRGAG1kiaZXSZuXPfVYKjLw2XZOmlu1/zKhIV1tCmv4M7eDnfF
         N86TuAOkbq9swkdeuP/k5HdGoITVm1Vh2foP68n37au5/ufFTu3Cx620C5ZGkxYUExYi
         EXjB3ByT1WlwM044LIjAze82/iyI7RmgUS2DoGiSR8OIlQHI9NqW5ETXXONPwNoxbGSt
         3mrrB2EJw46YbbW4NK/B3XoDUsleQdFgkt+5iX4P5sWH8favu+0U89hmw50kwfO2WcoC
         aSAg==
X-Gm-Message-State: AOJu0YyJpoTZQ910AvAWWhHtQ4QLJcBTSfkhX3ZLfVhGPTnicgpwEDvJ
	6yOuptc07U1rCS9Wknw5w2k00biTl7kJf5TcdEk1tjLwLsUI3ZPeMhHoPgbcRVIENzLPsWZxUhp
	K9uzZXX9sm735uD1XJQfEVfy22qa0+595B2k=
X-Google-Smtp-Source: AGHT+IEc1YMFDZK7OxteI5cywQBeYvaPGPg9N3yPowAO+RpxCxa+bpCnuxCyhLrOr1KlETLfBoVFXwD9sbVJ0Krbs3o=
X-Received: by 2002:a05:6214:a12:b0:690:e3aa:d2a1 with SMTP id
 dw18-20020a0562140a1200b00690e3aad2a1mr4323226qvb.2.1710319835779; Wed, 13
 Mar 2024 01:50:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 13 Mar 2024 14:20:23 +0530
Message-ID: <CAPtndGAHG-xKJrU3+9hYtcmbBizK4p_4w1kn_eTN0F8B6KB8kw@mail.gmail.com>
Subject: [PATCH] nftables: Fixed the issue with merging the payload in case of
 invert filter for tcp src and dst ports
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Wed, 13 Mar 2024 01:32:42 -0700
Subject: [PATCH] nftables: Fixed the issue with merging the payload in case of
 invert filter for tcp src and dst ports

Signed-off-by: Sriram Rajagopalan <sriramr@arista.com>
---
 src/rule.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 9e418d8c..45289cc0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2766,7 +2766,6 @@ static void stmt_reduce(const struct rule *rule)
                        switch (stmt->expr->op) {
                        case OP_EQ:
                        case OP_IMPLICIT:
-                       case OP_NEQ:
                                break;
                        default:
                                continue;
--
2.41.0
