Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8051B15D5B8;
	Thu, 18 Apr 2024 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437267; cv=none; b=sHpza0CmQtGSCcQKpTWTGVHc2DbyCEtOz+O0o5nvZec7bleIOlAtNdBIFPUiGeXJtc+juSLKWjcF2TCeGmFYtIFRJK7Z3MCFUCKkxb+a7rymEqvhqwx+zN9ASyun2DeSOHBFHECjePfX3KdZI7iCcCK211BByCKu/jx1OcOWTpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437267; c=relaxed/simple;
	bh=KASG7MlyEYBVBUq+JUUmSrE46VQv0mTSRSG+zMLq/2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyVL/RmdtAWeMq1jPkUjdN5oX4btQovIYxu+Y4jCH7LwO2MhXkiWm204MrDXWYthFrJLDdhWRBEJ4znOT0zV0qr7NWOZ1/lu8SDLPnn/YiF235gm7kePAUCn0h3Vr44QEegal7Um0MKMkcmDGiWMJy53i4InjWUcIk26kuib7Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O5Wfg6JT; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O5Wfg6JT"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-418dcaa77d5so5660805e9.2;
        Thu, 18 Apr 2024 03:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713437263; x=1714042063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9c50NDgHOO2h6To/Dhb/ujKUts2TVbWE/u1S4oDmvY=;
        b=O5Wfg6JTAvt5GVFPasz//nQue3P35bPYr9Xln0ISBGgdB69jBh45V5fEJR4CLC2Ik0
         te5XPUy5JnJdqRmUviIOX5pM039QHZA1REZXtmroUeolyipdVRj+j1eR0Uqe2rvr4+lo
         L+u53xZ48Cm6ET1RaDuwi4gN4lE0w6Ko5dYg8VBwpebBOEWmNg/3dB0NuREFD94Joqik
         K2VZy6EQPW4LcP1phRxF8K/2zHAQPQbzkiv8P/9ni6Obol25XOQPvoUWI6/Ex5XD2310
         Gk2f2R5ZojNpE36j1bP7X8BtrcgpOyMAL8xRlx/uatsZOo59ocgXpWah0IiEhnAXPRFQ
         k+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713437263; x=1714042063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q9c50NDgHOO2h6To/Dhb/ujKUts2TVbWE/u1S4oDmvY=;
        b=qnZ0w3INHLmNt52T/v+GC43SolrYmLlzemBQSi1nFRXn4OHr/zjPm/Q2Q7VeYZLVY+
         kL6WCKbUiAxVPVrhL0IQdch2zdAdDRwHyvaVT6q/1AqWLITgvWNGr1mHpw4EMewbTi97
         T+tBmwB5E5jMuUXFo8WdQ4URPa2eXf/siyKX/cZvKotMHV+9MAjbeD7MKKVl2WycGqeH
         LAR1RW+tW750DVFzBV/oIy/FOsBIpzGclQQxObAUeDSuVdzeE9OzOWQSF7toLpB9eav6
         roGEhgTAm4iTKVYgfOxHNqhmXDTZu4fbpcXKVl818NF8ayzUrBKRj2jaJBRjifPAk8UR
         azhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuAw2nor88wjO7zjhokhFe6BbDdFzQ6kaUmGeib9tUczm7YSmdy0VxXTN9UALKb7VbdqSyCMu1Af5vlzqYgb4BqdgR9pVbfPaRxBRRM4VL
X-Gm-Message-State: AOJu0Yy3nwn+0rBC4cvyi4HgOkHVAVf0Frkm4vQCw5T9ToUbka2Cbjzi
	7woxpiLpeEs8+LCXrGwbValBSyfy7oPsq+RcUhgHC5MllYnenxwyEtJQR027
X-Google-Smtp-Source: AGHT+IEUKdRPtqA5InQgBK0o9XEFAX61NzXtqv/dEv9ZKYXMb4NAD6FPbZKviQFdKjZPp5v9Nu8s2w==
X-Received: by 2002:a05:600c:314e:b0:418:e561:db8e with SMTP id h14-20020a05600c314e00b00418e561db8emr1026580wmo.0.1713437263419;
        Thu, 18 Apr 2024 03:47:43 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:702a:9979:dc91:f8d0])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b00417ee886977sm6135807wmq.4.2024.04.18.03.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 03:47:42 -0700 (PDT)
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
Subject: [PATCH net-next v4 2/4] tools/net/ynl: Fix extack decoding for directional ops
Date: Thu, 18 Apr 2024 11:47:35 +0100
Message-ID: <20240418104737.77914-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240418104737.77914-1-donald.hunter@gmail.com>
References: <20240418104737.77914-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NetlinkProtocol.decode() was looking up ops by response value which breaks
when it is used for extack decoding of directional ops. Instead, pass
the op to decode().

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index a67f7b6fef92..a3ec7a56180a 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -386,12 +386,9 @@ class NetlinkProtocol:
     def _decode(self, nl_msg):
         return nl_msg
 
-    def decode(self, ynl, nl_msg):
+    def decode(self, ynl, nl_msg, op):
         msg = self._decode(nl_msg)
-        fixed_header_size = 0
-        if ynl:
-            op = ynl.rsp_by_value[msg.cmd()]
-            fixed_header_size = ynl._struct_size(op.fixed_header)
+        fixed_header_size = ynl._struct_size(op.fixed_header)
         msg.raw_attrs = NlAttrs(msg.raw, fixed_header_size)
         return msg
 
@@ -797,7 +794,7 @@ class YnlFamily(SpecFamily):
         if 'bad-attr-offs' not in extack:
             return
 
-        msg = self.nlproto.decode(self, NlMsg(request, 0, op.attr_set))
+        msg = self.nlproto.decode(self, NlMsg(request, 0, op.attr_set), op)
         offset = self.nlproto.msghdr_size() + self._struct_size(op.fixed_header)
         path = self._decode_extack_path(msg.raw_attrs, op.attr_set, offset,
                                         extack['bad-attr-offs'])
@@ -922,7 +919,8 @@ class YnlFamily(SpecFamily):
                     print("Netlink done while checking for ntf!?")
                     continue
 
-                decoded = self.nlproto.decode(self, nl_msg)
+                op = self.rsp_by_value[nl_msg.cmd()]
+                decoded = self.nlproto.decode(self, nl_msg, op)
                 if decoded.cmd() not in self.async_msg_ids:
                     print("Unexpected msg id done while checking for ntf", decoded)
                     continue
@@ -979,7 +977,7 @@ class YnlFamily(SpecFamily):
                     done = True
                     break
 
-                decoded = self.nlproto.decode(self, nl_msg)
+                decoded = self.nlproto.decode(self, nl_msg, op)
 
                 # Check if this is a reply to our request
                 if nl_msg.nl_seq != req_seq or decoded.cmd() != op.rsp_value:
-- 
2.44.0

