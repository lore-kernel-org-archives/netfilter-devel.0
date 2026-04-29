Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E49399001
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 23:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504755; cv=none; b=cbVubn9IYlIZolWJenXLMKTuSgH7Qt18BzviFlkoHiSGF0d5D2lI07fuEiPZHJhlcgkppsbs7ILRpVHsxvtNAdedUvLczNOUH+G35yJiYxr/pmpjqWHuI5ucvuCzlBEg7n3C07BBKJEfvmkXe5Urc63iVsFrZcTktxZtcy/xJDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504755; c=relaxed/simple;
	bh=vnf9u5bZr2Jh4vHEhpzns0hJLI6h1CacL4VAyx/kSbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J/mXdQQGk+EP4Ll7ZWGke1TVdZr3VJLUyd/5BjZLMgywbWhMx9yJN7xY6rnXvXfe1k+6jY2OznJD5nXatpXYB514EIbNcMDqzeBeO471arq+8yD+nkOFWMLnPqA8Sdkmc/RuIrhjLyZkMDBf7sAxaJj/cIyOrF5tTrxUG6kMipg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hnc4IVGS; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hnc4IVGS"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d43e09de5so146046f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 16:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777504753; x=1778109553; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xg4uL55KM0rpFJAt2ymSaCICrZWf1oCpfyBNCgcrMb4=;
        b=Hnc4IVGS5eyTt3dBGI3jm2Yi6bpyGq2/IUGR094lMMJWJAtbIgU/AOcylkkxkIsEvz
         Dfss/BJgqLchl9JUobzRcrZ/hzevpBuKHvo5Qtt5BL6Ha9wZgK6iZh7huH5HQ4QizekW
         6wfl2WkpR6hreV1/2kHsZxbrwaQpi3TphNw/dgR716Vz06x0TF0VfHIlMWs/DGvGw61G
         UVLQu2Ahx/yphAhkflW72+qQdlyef0tjbrqq7B1RqzWv7rd67inn/DiHm6cEy/oKnvQ4
         iq1GElBXS9UIav1DK2Cj5W0W71i6HVJEfPDJDJbt1OgXhDcI+GaXZdwJf7DKa1WHB27R
         TtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777504753; x=1778109553;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xg4uL55KM0rpFJAt2ymSaCICrZWf1oCpfyBNCgcrMb4=;
        b=dK83S+GBNMBIv//DO1hjpBBB3pWzkMbG7sJ900/IcXB5SfxGcl+cn4unKrQe5ewDA0
         jfA17M6RHJxplj+5dE+QbGo1XtC7wYLdqE4jfH1qzDB/7Zkl2ktnoixfRMesjruU3WeI
         L9S0qJxXHw3w0tal6O5AXhlBH4zM9z15F7HoxZRAZHkbSKOXXjCPiTfbqG8iTip894mn
         RP2DVDlPZ3cD53KxAv4L3fPOXPY4EQ99v5wgMgw4PtmtOC4ZwQqFPFcU/2QqXETsMRvw
         E3MPn6JSeCNO1y24FOBkiVt8CakK93ZZ5Qu7gskQ0AYNVBfsHxVVbLQb9hz3UqIwlmUa
         kFPA==
X-Forwarded-Encrypted: i=1; AFNElJ8O5VpiiRiVm5+ILVzgq9fqs6kq9sXkXzN6FTkcm+vQbTTFSVTTg2lIb3uxZj2eJ3reG6vdK3wEE0kR7yvlswg=@vger.kernel.org
X-Gm-Message-State: AOJu0YySap7K1KVo7lTvuX0JbeQgTa8dEDChVZx+F0HF+pEnrL5eEogr
	XaFZhj/O5fMI86koSOYRT4EgMZTtu8S5w7eouiSg9JFw/dPpEZFQ3mM=
X-Gm-Gg: AeBDies2biooxS6lwX+060LKNFIZkwqBhojPmtL9GMt1OyhlAtV4l20/W0OOtg3XZTJ
	51fwTZJq9WuxRcnHLGoL9M/vFe8cgk/H0VruyqdssGEO+PlBlz1CM2edQC9G++Bmd6oeb5ONagQ
	cOEjy4JDVCmQEj+24wavj0XnNcixUQGMAiwnJ2cFIrBpTiK0+WsLgaY7SrWIPbcfWwyB7qfv22O
	v5yAVg5ug6DEYf0fPzaybSmC8Rz5rYjxKznNa/Pg8j2p6edErttaZrsr47EiMxS17/7Oxw52pvZ
	f4dfH8hoiW8cFys7Q8BMtB08IhXR9y2q1ApM2FdMIgjyMcxD6XYtVUJA/3oA+Krb2GS1cgzKKc3
	inwfuu0Ux5PUIqrUWO+qT8D+PqS6tcSsfKpKobZA0x+uVs0HkisERIaFDTBDUPYDHX+2Fl5y7Ca
	TQkHXwfC3vJBVZyg==
X-Received: by 2002:a05:6000:611:b0:43e:a81d:c475 with SMTP id ffacd0b85a97d-4493cf2d583mr611329f8f.6.1777504752636;
        Wed, 29 Apr 2026 16:19:12 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b3d48517sm7502180f8f.5.2026.04.29.16.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 16:19:12 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] netfilter: ip6_tables: guard
 ip6t_unregister_table_pre_exit against NULL ops
Date: Wed, 29 Apr 2026 23:19:11 -0000
Message-ID: <177750475157.3021974.6858117535916205046@talencesecurity.com>
In-Reply-To: <177750472539.3004201.15967003942391945312@talencesecurity.com>
References: <20260429175613.1459342-1-tristmd@gmail.com>
 <177750472539.3004201.15967003942391945312@talencesecurity.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Same race as the ipv4 counterpart: ip6t_register_table() adds the
table to the per-netns list before assigning new_table->ops.
cleanup_net can find the table with a NULL ops pointer and crash in
nf_unregister_net_hooks().

Guard against this by checking table->ops before the call.

Fixes: ee177a54413a ("netfilter: ip6_tables: Use xt_register_table()")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index XXXXXXX..XXXXXXX 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1804,7 +1804,7 @@ void ip6t_unregister_table_pre_exit(struct net *net, co=
nst char *name)
 {
 	struct xt_table *table =3D xt_find_table(net, NFPROTO_IPV6, name);

-	if (table)
+	if (table && table->ops)
 		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }

