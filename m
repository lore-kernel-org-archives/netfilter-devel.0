Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791062D739B
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Mar 2026 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772985174; cv=none; b=NlqgzghVLLKd7OkwPtnea6j5AndvbDEglQWb8AfaTrbbaQ7Iz1q6sGNCBl1pW2GFAE3e+1m29JeClDbEeNIaJ7NjVqjonLvOO1wpnfaq1TIB44NPFFu9qpCwyUmSgpoUXT3jl5zqeU0OGaW83f/EVxvhc623P+lUpwPUFI6WMJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772985174; c=relaxed/simple;
	bh=iztXkvvNmNQdhNQSsA/4vatJC2HyDpC8TRCFa4DJN3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PICbwXKYIOMnv15d3jmM7+b24bzI7ON+x2oyB40gvaHYoKmo0p5Rs41MKlFD/NG+SLo1qYtLFrAiERcCgSJEF91ZUecX5W22KN5/zQCXjmDOBUUtZWLxebPIau3PJSa1kfmQ1GKzmDIJQQRI6k82w6qRmuHi+VFy2uyiHeGswc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9RrR6IB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9RrR6IB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-485392de558so1303225e9.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Mar 2026 08:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772985171; x=1773589971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3scYOcTQ+Y+qxr9kmZFv4RXNZ6Kx0W9gehp3gvejJjg=;
        b=M9RrR6IBXf5RFc2pdSZs0LH/uRChH1u5ownBmawqY1D6/2tKeulDCJPTqjLfwuNT2Y
         yJode5uJlUj4G3dXsYscG409bbXw1v1OkoZs06NwLaOOeBkNmaTOZrQ4mcRIozB637bC
         ML80m/PHzQafST63pHrwDNvJZs1U2VvmMcR6O+x+ZfupXTqcrDv8ZK1altokZfOz+Hag
         Dp6kET+M89jJLEP3qUvxdl9vhOXDOcNuukPPGbw+fev2EEe6eHcaTjbBT2X4wJJlWVtj
         /g8nUT/FuEUuGrwAyFvYF0O+rcdvoB+HtFVqMbEMEDVQK/ShhvA6M6PrzRK3ODh+yARq
         ChCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772985171; x=1773589971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3scYOcTQ+Y+qxr9kmZFv4RXNZ6Kx0W9gehp3gvejJjg=;
        b=Nq83ETiPIt8J6H6H2fCvpuf37X/d8GTZbFk/fuxQoJOvSm+6nF9WUB6wdL3VLudJZ/
         T1gktE8NmDc8RzyAtG6JqDaaXm8BoJJuqOew//oQEEmFQ4uPU17j9erUe4vdR461oNix
         tk/aXjqm+pDoXuNAFQYl0hiJSqUECJLwSfaNsM/m1VcLVuKBUlZuGfXFxLDwsQf0UQn+
         9sXykd2D7qb2a35w5a9sSUiwLvsFCzm0O8GOqn5CqFxp33fgIDP2XDArg5zliCps0udp
         0nZs0B2I0oUJBl5doByhmrabyPakN9YQnX83BZhjMzxf51udIRe8JN+9hna3nQu3CIbz
         xi7w==
X-Gm-Message-State: AOJu0YyPgDWooIITM+OYwc9w1xX3hcmmEMRXQn06mLeU7kRe6i/n3AL+
	9lXsaJ9n7FSr4z8MpfczPfTEUkVXs0jlnwrDnP+z7EtYDB3UyRyemwQfiPrjrJGn
X-Gm-Gg: ATEYQzyK4qyJanLbU812EW+pEeW04R4vUTZv47oleNzzu3/gZ7VWI1WjB4AX63wgYZG
	NSudIe+Ls0cDbWm1Snb1+BXok5SQLfitVjFXTSWhQnHW8I7zQPzQ3DKen7TJoLqSkYVqD5Agwjh
	v19Ny9zKdXDCjgR1M8SZvRIelGlZXS1QQMo7zyRZduXdfUWCq4N/TiKVTxvVD/P/JBl+hoc4PbW
	MbtRZLwbFSX5il7M9WwCTD2cbiRNyZxfXZTucnK+ktDsdX+ih7GK8Oc5rCFWh0zdfbJmjtNt5CI
	KjKn/UCZba8M9ExS+sizhFFNHzY6jIvJJkORyHI63pEhveEbeoxwApvyOhD3N9ySrTc1ZmhZJw5
	ZJDDdSzhzV8HyfM8P3u9jEAMxJRF2umOlwfdtWXC6PlDtJ9yEsPy1KOI8pf5CnEu9bmu9d5gP8D
	vijMErEJdFNquAzSO6qh2dkZUgLhEtwRdkorquuKs1
X-Received: by 2002:a05:600c:3596:b0:483:6f37:1b51 with SMTP id 5b1f17b1804b1-4852697955fmr148215895e9.23.1772985171286;
        Sun, 08 Mar 2026 08:52:51 -0700 (PDT)
Received: from localhost.localdomain ([102.164.100.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851fae00absm270323145e9.4.2026.03.08.08.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 08:52:50 -0700 (PDT)
From: David Dull <monderasdor@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	David Dull <monderasdor@gmail.com>
Subject: [PATCH v3] netfilter: guard option walkers against 1-byte tail reads
Date: Sun,  8 Mar 2026 17:52:11 +0200
Message-ID: <20260308155212.1437-1-monderasdor@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260307184553.1779-1-monderasdor@gmail.com>
References: <20260307184553.1779-1-monderasdor@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

When the last byte of options is a non-single-byte option kind, walkers=0D
that advance with i +=3D op[i + 1] ? : 1 can read op[i + 1] past the end=0D
of the option area.=0D
=0D
Handle single-byte options first, then check that a length byte is still=0D
available before reading op[i + 1] in xt_tcpudp and xt_dccp option=0D
walkers.=0D
=0D
Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,a=
rp}_tables")=0D
Cc: stable@vger.kernel.org=0D
Signed-off-by: David Dull <monderasdor@gmail.com>=0D
---=0D
 net/netfilter/xt_dccp.c   | 8 ++++++--=0D
 net/netfilter/xt_tcpudp.c | 8 ++++++--=0D
 2 files changed, 12 insertions(+), 4 deletions(-)=0D
=0D
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c=0D
index e5a13ecbe6..7f9e2d5c1b 100644=0D
--- a/net/netfilter/xt_dccp.c=0D
+++ b/net/netfilter/xt_dccp.c=0D
@@ -62,10 +62,14 @@ dccp_find_option(u_int8_t option,=0D
 			return true;=0D
 		}=0D
 =0D
-		if (op[i] < 2 || i =3D=3D optlen - 1)=0D
+		if (op[i] < 2) {=0D
 			i++;=0D
-		else=0D
+			continue;=0D
+		}=0D
+=0D
+		if (i + 1 >=3D optlen)=0D
+			break;=0D
+=0D
 			i +=3D op[i + 1] ? : 1;=0D
 	}=0D
 =0D
 	spin_unlock_bh(&dccp_buflock);=0D
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c=0D
index e8991130a3..4f29b1dd0f 100644=0D
--- a/net/netfilter/xt_tcpudp.c=0D
+++ b/net/netfilter/xt_tcpudp.c=0D
@@ -59,10 +59,14 @@ tcp_find_option(u_int8_t option,=0D
 =0D
 	for (i =3D 0; i < optlen; ) {=0D
 		if (op[i] =3D=3D option) return !invert;=0D
-		if (op[i] < 2 || i =3D=3D optlen - 1)=0D
+		if (op[i] < 2) {=0D
 			i++;=0D
-		else=0D
+			continue;=0D
+		}=0D
+=0D
+		if (i + 1 >=3D optlen)=0D
+			break;=0D
+=0D
 			i +=3D op[i + 1] ? : 1;=0D
 	}=0D
 =0D
 	return invert;=0D
-- =0D
2.43.0=
