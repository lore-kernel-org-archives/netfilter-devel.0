Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DAF13958A;
	Tue, 16 Apr 2024 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295960; cv=none; b=nnSO793bUTT6roLAiKgDq5yMx9G/tPARMWGEzgI/yfIElCKNRt70bdkx3jaD/ErmHoQpGgwyKCvM0V9HWy/H+bt4tPrrO4Aq+7uRlAMP0eQLraFoCHYgrnR5gxCAzbC/hw2/q9Nr2QGVMT2Tq7944v4hM92UuIzmT70hg62iknc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295960; c=relaxed/simple;
	bh=Z5eKkhGzI61to4+9oCaEDLPzrRmsjhuoTlHtMcra+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZoUBoHyR84RPy9iKECmD3gRh5xBA8Tl7AqVXRzFPzXfPxMau1AJETAnuS/lP1fLChLs7vaSwx8zNvmUwpcvU+hh1Nju0axLL7dK2E8z9htynoug0bZDKuXy9tRzU7gFcrR/avfkzFJwAW3wxf2uErW0WAfg+tO1tIuZ/sZzXsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYmcb76X; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYmcb76X"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-69b9365e584so757286d6.1;
        Tue, 16 Apr 2024 12:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713295957; x=1713900757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Qtj+HJLcSA6Egxh9EBJGAXfVQ/F2/t2JKExwDP1lg0=;
        b=PYmcb76XS1M+O0TLsRXlmUYTvBDst+7s/39lLU8NlTAOYzFYYQ6s4fYIIk6H12K7y4
         J1yY97Gt85gJ4cmFhBXN/WMBfckgpJkR7jyQTtijR+9PTVAYZYCsCE3FvJkh365V0Mvq
         L1boBN0CNmfn95fMNlYl4a3ANifPX3aeN5nlj4tG+AFjWjJ59j46Cl8oj3X87D9/eEJS
         Jr17pQ2I1RTPF1UYZKyVc8x7iSVs+vxqCV6A9aOiH0dhK677O1o4fCKmjkpkLPRnLKiG
         F1wXVdcuN72Sx2vW69LqieY0bpv9k+aDYHssGxIN4c0oiYHPuxd+zhTJmAONP0vyuidR
         P6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713295957; x=1713900757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Qtj+HJLcSA6Egxh9EBJGAXfVQ/F2/t2JKExwDP1lg0=;
        b=sGYJVVrGM6hhIOM9kwdjXCxOyrn7iQDoek1S3hFXJUoAntcvGAqwLDOujEyTRdUE1q
         8eyreXmImcRljp7CkW7wpuIeeYSoppfiswPQAn3tACRP2cugawt+v8YDFYvpZaTKwxMd
         z4MgFgYZG7Scg+DrhsI2agZBacVr21sgoHY5BS2RMZFO9M5MiLM3q16ZpTV4Iq+njZK8
         zT5pGxJnfKeQC6DUvPxIp6ljmzdR6v0oNw1pINoV9HpP9xK8vDVrdEdu3RUHP4IbrWES
         aLzCYMWDtmvDrggwX3NuxXftN3OSrKQSOxP9d8WU6xw2qlu6GOEzpAxIbU/yTr/Gr909
         Lt+w==
X-Forwarded-Encrypted: i=1; AJvYcCXkkM5WExksrCUDv2FoP79EiERSLo3+ll6v8OcTI+EbosIAe1oC8cIwG+rs2hH/1pvrc3rojGQ9Zz8CBojZ0QdwehLg2W/olfGgWtGt+W7c
X-Gm-Message-State: AOJu0YynUXFR3A6+IygsJxuBwrkZYe9H62LDWi767KOScYBFU6ZE93ZC
	Pcwl2qo4o2CAAG4mWFHxrlMrQwyf8Zycxy34a3STERlMSPuHsTmQsRxQfrvW
X-Google-Smtp-Source: AGHT+IGqAj18aW9DCfJkvZoSFkJfO+HhD+vthgeMez6Swa84C8tCKBxfyOEtgkBzwwX7aF9hzohtsA==
X-Received: by 2002:ad4:4d11:0:b0:69b:5f59:7bc0 with SMTP id l17-20020ad44d11000000b0069b5f597bc0mr5194174qvl.16.1713295957177;
        Tue, 16 Apr 2024 12:32:37 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id p12-20020a0cfacc000000b0069b52026a19sm6901757qvo.25.2024.04.16.12.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 12:32:36 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 3/4] tools/net/ynl: Handle acks that use req_value
Date: Tue, 16 Apr 2024 20:32:14 +0100
Message-ID: <20240416193215.8259-4-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416193215.8259-1-donald.hunter@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nfnetlink family uses the directional op model but errors get
reported using the request value instead of the reply value.

Add a method get_op_by_value that falls back to returning the request op
for directional ops.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/nlspec.py | 12 ++++++++++++
 tools/net/ynl/lib/ynl.py    |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 6d08ab9e213f..04085bc6365e 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -567,6 +567,18 @@ class SpecFamily(SpecElement):
           return op
       return None
 
+    def get_op_by_value(self, value):
+        """
+        For a given operation value, look up operation spec. Search
+        by response value first then fall back to request value. This
+        is required for handling failure cases.
+        """
+        if value in self.rsp_by_value:
+            return self.rsp_by_value[value]
+        if self.msg_id_model == 'directional' and value in self.req_by_value:
+            return self.req_by_value[value]
+        return None
+
     def resolve(self):
         self.resolve_up(super())
 
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index a45e53ab0dd9..eb6c5475fb48 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -390,7 +390,7 @@ class NetlinkProtocol:
         msg = self._decode(nl_msg)
         fixed_header_size = 0
         if ynl:
-            op = ynl.rsp_by_value[msg.cmd()]
+            op = ynl.get_op_by_value(msg.cmd())
             fixed_header_size = ynl._struct_size(op.fixed_header)
         msg.raw_attrs = NlAttrs(msg.raw, fixed_header_size)
         return msg
-- 
2.44.0

