Received: from mail-ej2-f1.google.com (mail-ej2-f1.google.com [74.125.228.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B742AFBC
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673549; cv=none; b=sibVMElB3vsK1c3e9f6tPZQ51I47N1aHs+UyNI9RRGCYRb/bN8Dld7+3vb1373Ntyl5+6q6xZNlbn41QX+QtDkEt/3lp4i7ZmIyGwawo94QFh9dr08Y4op2Fcn68bmqFG5PfFii7qsrDdvMrRowqS/qhrlZc+Oy7RXDRTKVm17s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673549; c=relaxed/simple;
	bh=RRut4CcXzZ33X43C9H5lQOu9ePxUARCVaLziJt3a6PM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ap087a5NbO2IbJQBFPdxfkYIa8sHx+eLzzGoWJsv7smGv5UyLtMi5cRBC1v6FiQDxax4jFpGEP+RfvCRrLs+j2XW73OkOpaO6ol2pvlspMqSqA1VqTLhZFJC4+C/AL2mYjsUJnR1xYIeBboZm1BcVLyAcpnGJf3EZnliRO3kx0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f1.google.com with SMTP id a640c23a62f3a-c15e0279316so221167866b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 08:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787673546; x=1788278346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wr1rmaQc3zAX/KiOiWAbKtWPn8dgUIfKo9r4PXcz4Iw=;
        b=g1Ly/sTih9REa/As9K64r4oxjoMvp8lxDrF+H78ViYSAPputMUiALPxMQa7fsLHZ9E
         +09qEv5rHjU2k6sYW/nMROR2qQai5IjSYb8zIZrCvDAcTd7S15LK9c+15prgZP4oKQAr
         Ba8biGznmJX+Niip6oTg3BE3waZIxTIdklNwnluM2k2l30lEeTmDaVegl4+F/T5Ljq3/
         EYvl1JGz/HI3Me459qppQR7SIXMK7rl+b0YWrWM5ky+gSCKrKfEcwpE15ZabslYnI3xf
         jOmTgjO10sdDko12qnTkot0Da0ryVTcWhUEqm/pwgi2c3YOtke+peOz1MpGV/l1DEJYb
         Hcow==
X-Forwarded-Encrypted: i=1; AHgh+RpjLBAPh59HwCATy/4VfrkwfQhkf7Tx0bk0l2h8i/1xFDsWGX55jyG2I/ypI/iVtahi+fcZm2yyRtKyXczSZJA=@vger.kernel.org
X-Gm-Message-State: AFuF++lrhTzZDHglUck0TVoeGdMTW6Xo6h60JNcKUB3TvKPmJlo08FsC
	3/5w21K3RJLFcR0PEq84yv2p8q5CctAV3srgqZSD4G4WlHb5G84WcppK
X-Gm-Gg: AR+sD13wPaa4EWKq8j8uUv3Cs9+ce4MwZ/sYqUA8PbNbx63OWK1VHP94hKeNrk73qck
	w6e2Rre3aN+BdU+nvcC1lfYELXy6uNBOywXi/Yw7v8JrageKZkWftjfC8wKqUJhHFMBWDVDs19C
	gLpTZw/zDYbMGktEcvDsd8XhybPhgJrbz054boAofk+jIIccs1QKwJM0NxiXZsidtETfiGc2Q5r
	aLgK2ZRfQ96kuOVHqQdQLmXlHTrVx/l5tj+JX5+2DhcUg3Dlb9afo461+gHsWvc08q3u7gcV6Cj
	ICEploWvaylp84ywQl6jaGn44H+UV92CnXF9QhN53amKxFtaLJ9+fXasOntlcSUJrs1EweMggdm
	AhdLec1ej96YpDHz6M2pXFb+5mXv0TVKoo70RkDZ6/35Fv+oCpXLf3GqhBsN7AVkrYSTfhm6jiy
	OGabTTJycPhCe5rZVCT9ux+zjBbYVGAT51IbGjJLqL8Ra19nH3BMJdtE/N9JcqR/IP//+P5JwY/
	vPMfAsYp46eeaHdFi/q
X-Received: by 2002:a17:906:f588:b0:c24:d430:3929 with SMTP id a640c23a62f3a-c24e58cfc2amr923308066b.1.1787673545645;
        Tue, 25 Aug 2026 08:59:05 -0700 (PDT)
Received: from im-t490s.redhat.com (89-24-33-32.nat.epc.tmcz.cz. [89.24.33.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a88ac7fsm23088866b.30.2026.08.25.08.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:59:05 -0700 (PDT)
From: Ilya Maximets <i.maximets@ovn.org>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Ilya Maximets <i.maximets@ovn.org>,
	stable@vger.kernel.org
Subject: [PATCH net] netlink: specs: fix the conntrack filter type
Date: Tue, 25 Aug 2026 17:58:00 +0200
Message-ID: <20260825155832.3685714-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CTA_FILTER doesn't contain nested tuple attributes, instead it
contains bit masks that specify which tuple attributes to filter on.
The values for filtering are taken from the top-level CTA_TUPLE_ORIG
and CTA_TUPLE_REPLY.

The bits themselves somehow are not in the public headers, so not
defining them in the spec either for now.  Once they are public in
uAPI, they can be added here with enum-as-flags.

Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 Documentation/netlink/specs/conntrack.yaml | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index db7cddcda50a..46f1ba880745 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -360,6 +360,17 @@ attribute-sets:
         name: tsoff
         type: u32
         byte-order: big-endian
+  -
+    name: filter-attrs
+    attributes:
+      -
+        name: orig-flags
+        type: u32
+        doc: bitmask of tuple fields to filter on, original direction
+      -
+        name: reply-flags
+        type: u32
+        doc: bitmask of tuple fields to filter on, reply direction
   -
     name: conntrack-attrs
     attributes:
@@ -466,7 +477,7 @@ attribute-sets:
       -
         name: filter
         type: nest
-        nested-attributes: tuple-attrs
+        nested-attributes: filter-attrs
       -
         name: status-mask
         type: u32
-- 
2.55.0

