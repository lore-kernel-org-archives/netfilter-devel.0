Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1346D48C8B9
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 22:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787781899; cv=none; b=lGBe2WqjG+OY99G3qhDPtNezzD8o6A0kaaDrChf/c/4dqZaVkFmx7kq8xy2Pk8H03SXYTej8HBQIsn83kvVmIQ98BzNV+6Z8nJR0xQAuk/xjQs1E2hD523hEFbBIe4N5LxLn/0Ku9XvCxBJEznsd9aVvsuKfcuXNWsyAWSDxwYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787781899; c=relaxed/simple;
	bh=FF5GpjGANX5AK5OcRxrqub1zd1QKVWSW0xCxSxzcrm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frOXfyq3uVbYfo0LhJPgmYg7zLhx9LU8eTvd92rt7xQhsZCDTMvcbLHap2BJYODx49og6Os0BVuvXts1xUWTGjRiJWL1uDtBM3+c0zrKZ7kYed0pt7frEDgeagkym9uWOeGkO688MChZhFUh8z+ngAyV8bFgNNe7fGs6tdAVG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-4784b41f3aeso217388f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 15:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787781896; x=1788386696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OXH0qC5tsPyVyIeDeRYkK9RuneuxwblawRlIIgMj1Cw=;
        b=PbMXmHeZNom2ul8HErT2F7ULYPkhMPICYlGPfQTpgRV33ECdm/eqB1QT8MiYCLXj22
         bil6MWq2dokp5ZnY6ETv2E/J7G1DRR+cnMt+ukd64H0bXQ8jyokV60REANEuJlczmFBR
         NERA59kc1/Xpe6abQgVuZIzjQEntRkEPSETXxEtOF7c7CjRUG5a3glsftL4LXb6fiweY
         nobplYWYdZw9dbYyzYP2/AUZ4KokVw9euNVw9ni6uFPTCjQwIG3qY9YQ9LJHMKOsGqDZ
         w2xYIH6ZXUe8wYW41tMKDDw60J2F3h4GPp1isdiyZMmRestPWg/2WF0ASRmCUdp8HLXZ
         MT1g==
X-Forwarded-Encrypted: i=1; AHgh+RppoGG2evBNMmkiHsNmT+0VeuAxFvRbJeOeZkDuOQHc9tC7wlH2oJKfVWvnqluzSnbXf7WJ8W+U+20sGfqA0PY=@vger.kernel.org
X-Gm-Message-State: AFuF++kt383+Kc+LbjKiBTZs7vttOEHsEr4xr5TxhjltOpVncelx/QFU
	TSfv91mevvARbTSJJbB8GtyDq0Rbs+rjnWmXjCAjAlronF52AszRIi6g
X-Gm-Gg: AR+sD10mhgqkkplJ7CTwtJrFb6oQzILKB1KsQICltxf+BQWYv6H1eWMolQFKhd6iZ/u
	BL697G2jGLu2cVabZuYcyL4UznomkJ4Hye1KqCOUNG/UmXC73OIFZIYsJmaMvhbMHc94FU1dRRD
	QzYOFookLDkLMImj6ZTuwapqz9g7EaHxL40QmCVxCVe1lXdHHMZXYHj1hau0w1EZ0gWQQsOvK++
	i2Y4rL1YzSy5c8sU/tAmroqojxJOvHgm24Pd/6pOuIKmbwPBvMZBhC0j2HmesO4yvKnHJ6I4mz1
	tDxGCywKVcSINdrw1m7pyD9wwfttS6vE2Jz5EKxXSImEj+2O2xPSweleew7RWSLlufCxlvG+dqe
	dcywPD2qgkK0y6gWE8Rzg6rfe1hqbI518g/pNOpHD/ODF9XuEo2MgnQrCrOhoqIrmlDHPNh7TEK
	z+3a+ZtKTl/kovg/jRXxGlpKFdMxRth4E/OVStrULIBX5RBJfXsNDg2Y8BbqX4MmFpLQupCN0b4
	mj3YqXjYh1Hq4QDAA==
X-Received: by 2002:a5d:64c2:0:b0:482:e10e:58df with SMTP id ffacd0b85a97d-482e26d51e8mr11792199f8f.21.1787781896114;
        Wed, 26 Aug 2026 15:04:56 -0700 (PDT)
Received: from im-t490s.redhat.com (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e27a9f0esm4446370f8f.10.2026.08.26.15.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 15:04:55 -0700 (PDT)
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
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Ilya Maximets <i.maximets@ovn.org>,
	stable@vger.kernel.org
Subject: [PATCH net v2 1/2] netlink: specs: fix the conntrack filter type
Date: Thu, 27 Aug 2026 00:01:11 +0200
Message-ID: <20260826220444.4054714-2-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826220444.4054714-1-i.maximets@ovn.org>
References: <20260826220444.4054714-1-i.maximets@ovn.org>
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
and CTA_TUPLE_REPLY, which are also missing in the attribute list
for the dump request.

The bits themselves somehow are not in the public headers, so not
defining them in the spec either for now.  Once they are public in
uAPI, they can be added here with enum-as-flags.

Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 Documentation/netlink/specs/conntrack.yaml | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index db7cddcda50a..6ba28cb1c2ab 100644
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
@@ -591,6 +602,8 @@ operations:
         request:
           value: 0x101
           attributes:
+            - tuple-orig
+            - tuple-reply
             - mark
             - filter
             - status
-- 
2.55.0

