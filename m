Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC4A46B7
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312860; cv=none; b=EsYWd4LGrfZP2zooDlD0Y87PBD2kxkWe+2sBFcrWD7Q+9nWTsJAzZi/dThZsRiEwroPFuh4iXgb2f9rDL+Jtr6mg/z9y0gIdf5AHg3h7jCJrZ764il1xGGeaA2hm1BOOOSNdwVGkQ2YKaA/lpFV07CMudGKStYsSpPo01OBCi7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312860; c=relaxed/simple;
	bh=+s9x+3J/y670g4nj+D61f/mx8OaLWwtMIg7kk7fYNAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg/vIaB6TWM/jV5MqH1A3/IRgTRIS2lpXUS/92ZGIiGGwoy6B6hhWFg7wQ15E0qSrXUTEgRaa+fXL7D6LQpsCwo96XoBCHx7K7q1bmA/wQEe9VEHhhMmsTxyz+8jJxB3Rt5F6YjGRhbYms7Fi/y0ZxpuuNftIfCqEyQJUHSUrRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YlLc3uVX; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YlLc3uVX"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-68fcedcf8aaso10092586d6.2
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2024 09:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709312858; x=1709917658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4Dp1aflshjG5qXMoiU/r/Blnmp7WCLl5SGk96BBnJw=;
        b=YlLc3uVXLWG38RgePhmXNNqLCgZig4Bw9NXovVVv3LqZzVY3nKRL4UMdW7qMPciLZg
         klSGhNU1iPOFQArSi7xLwzYLQEZ9pLJQVyM+IFaNCHX8v1340JpY9W6z84kSOzZBRA+O
         yrTTmZmIUKbF4hNuy3eeOFhXZtFt4pxeYRx4TLC+NFexmP33nUBMxrkZKPVxdXpD8GWr
         A0W7qv30xCz4K/keVi2Q5QYLgZmcozKKF/s/6Mzv20FEf+HUSI3FQofjHehYLhlV/M/5
         Yv+8nsZrvyUKY9dvl844F7CSEGdjGbcdwUJ951rCvC2nNR9R28SBg9sLURCDtwXRxOGZ
         4O0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709312858; x=1709917658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4Dp1aflshjG5qXMoiU/r/Blnmp7WCLl5SGk96BBnJw=;
        b=Tv9doX3FVA2u9xcAzhQVVo/8bP0G5bj444zJ985JHNJb3h6iRo8rnSsZhuTkVxMFvr
         m7K4Pb3S2F8LUZC25wR+BHa8OcTPPg8Dm6+xFUnjtZSJRgtj0jx0GXLBGJK1GnwTDbMr
         jeKnH6I4BVqbLCYtDi4C90ZuX+D6sk8rtfCPoSHRJ4oGk9RSdp0icm1eQGNOyWBQEAyB
         HV+vctpmp5Vg69wBPgdTUlCEAewsDQp680dioUETR8U+2hH9HuMCT+Dri8woJfLqmPcb
         oKWwQZE6JihlskliYcA4Cwztlx6ffW+dlYIwxijn7XEWQLyy1J3dDDKJJFEMb4FQHP5L
         lN2w==
X-Gm-Message-State: AOJu0YxbXgREj+p6sj5H2lL52819ns9Xe1ZDe7f9Uc1SgFpQg/pg2w+7
	BilqZOpIIk7NXuxfFK4d4M1h5U321TMX1MVRNrHuy0D2aWPe0K0mPlJFTXGR
X-Google-Smtp-Source: AGHT+IEWGjDUUSWp79x9P4OyJLafUDK6kp6rw8YAj8T5xlO5a0aZhc3B1ArzIP7DUFF4AlM4D3pq8g==
X-Received: by 2002:a0c:ae91:0:b0:690:2d3e:aa4b with SMTP id j17-20020a0cae91000000b006902d3eaa4bmr2576752qvd.36.1709312858035;
        Fri, 01 Mar 2024 09:07:38 -0800 (PST)
Received: from fedora.phub.net.cable.rogers.com ([2607:fea8:79d7:c400::557b])
        by smtp.gmail.com with ESMTPSA id nz10-20020a0562143a8a00b006903af52cbfsm2067261qvb.40.2024.03.01.09.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 09:07:37 -0800 (PST)
From: Donald Yandt <donald.yandt@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Donald Yandt <donald.yandt@gmail.com>
Subject: [PATCH conntrack-tools 3/3] conntrackd: exit with failure status
Date: Fri,  1 Mar 2024 12:07:31 -0500
Message-ID: <20240301170731.21657-4-donald.yandt@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240301170731.21657-1-donald.yandt@gmail.com>
References: <20240301170731.21657-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
---
 src/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index de4773d..c6b2600 100644
--- a/src/main.c
+++ b/src/main.c
@@ -175,7 +175,7 @@ int main(int argc, char *argv[])
 			}
 			show_usage(argv[0]);
 			dlog(LOG_ERR, "Missing config filename");
-			break;
+			exit(EXIT_FAILURE);
 		case 'F':
 			set_operation_mode(&type, REQUEST, argv);
 			i = set_action_by_table(i, argc, argv,
@@ -309,8 +309,7 @@ int main(int argc, char *argv[])
 		default:
 			show_usage(argv[0]);
 			dlog(LOG_ERR, "Unknown option: %s", argv[i]);
-			return 0;
-			break;
+			exit(EXIT_FAILURE);
 		}
 	}
 
-- 
2.44.0

