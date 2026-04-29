Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1383822BA
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 23:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504748; cv=none; b=W9UouwYe4DAxdUNg5L36huz4oPfjU7zMb/+26SSgjiOXstVVQhZk9oyPjN67tie5JdcoDqLogaxqujvr+6dMQ0PtLYajRFAXX/VfZY0O4Gq00tN3KLkczU1OqovroJARDdBarCOgEEhhyOa5SUOcgQmuHMepF5imJrg3j6Tno2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504748; c=relaxed/simple;
	bh=igdzl3lWughU8xzCp/zAPhHTuBkDvNwNGNOG2lHylPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aYy35Y4FCXzqiwciYIcKsGCVfdKulrKXA0AzwmZhnz60ecOWFQzzktUDYTw+x4BAtqvYS8J1RNg8aVzgcHxontYFV1q6H8mFOEeifGQkeMpVc1MlwwIbGyqgrHKl4flR+gZ/y9MFTttPIngLc6avdcVBm8iJ4Ayb6q20Atg1sBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlQrKjdb; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlQrKjdb"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so4886445e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 16:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777504745; x=1778109545; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hd/6unjwJeqPaRYpTI3Uva7eVyvTUW4co6d4pCO9ZrM=;
        b=MlQrKjdbqLfhRHKSUETNy+dcsdvcLMGFE0mwUK3+0EMp/UBUPtEL3nudeiuHYW1Dyr
         YZN0kOfRJ4VzM3LfXvty4/7DVSh8zHeyCL+rJbfOg5sIftW0k0/PWEHyWPs+3nl3vMaK
         NazR9A/jzHU4FpdZqKK1CDtVljCSIwAwYvj7LP7e1et2f+/No7cgJ3yub+930TYBjDMh
         oUub5Jk1lGvP2LUCGmITdNChvQ4UGu0Xnen/QE5sTFBfwbH844nsWUpJzkQ6FA7FdHvK
         fRvJTjcUpV8IMecTEKxEY4AbQmOBjMR6lTCo3sPBvfLbCXBhe8E+1MitrUss1kSOjbQj
         MAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777504745; x=1778109545;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hd/6unjwJeqPaRYpTI3Uva7eVyvTUW4co6d4pCO9ZrM=;
        b=M8Ik0Clt3II4mxSu0Tyd/7v/Ifgg4GKExGs9Jhjp/xNP2sxtaVfRhd2Wwy815pEpW4
         I3CTRJ5itPkNTCJJTx3lTdxEzcOYVqIcmly7B9b9s+inrYZ5eV1AkWw+rLzY5fXaJshG
         S0269hLC7bOdS0ekn2PjfbQHmy7CdVMiLomlLPnSEVerDXKFyOaOVA6szVTqRbJHl7AW
         e8kFMdvt4tatdPy6fTOthdNEPfyXEL0rQHMZt0B5j3DcYR3nzCfBAzXU7DB62r+WtEkJ
         etdtzuUEmmdr1SbVun/+IvjAt9577ZLH29XwtaO5tHw6r4IGfFAiqYyBuip7nuLKps1A
         gnlA==
X-Forwarded-Encrypted: i=1; AFNElJ8imksrpdrQvTzHC55GDQoPvJHGx+a49jXY+Ng4Pk+MSYUEHmb19eo5Ck4Un3M0g2f1CL2sZdzpk9MevAHHXa0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh3BLyEKLgZNh3eQw+NkLr6fYWes/pBfiM/38CUMeo0vR7Utgx
	mVSNaDWgepTWAqzXaigcP2JenPmxiP/7V0/S7SdCcFn0FZ6bevQEeiw=
X-Gm-Gg: AeBDieuktA8e47KBlOJ3y0oaVaY85dhIEeFi6I4DoxWV87o1Ot3JpoG6J/BUbvnchd7
	VKsIGn5P47gVv+Plo1rIZdmdPTRE8gQekdB31NZj3KYks/XvL5FYP1uLeKJ4hbDVIKEFH6mLSos
	x7GZgRu2Zu2Huj1oYuWcRXyM2GH6zXbV4/z1FOU9NMQS0sj3teMtl9WsbaXu8UvtULjGtJ0iDvy
	VppbnafmEf2Ho4fn4uRFMwFx+SkLF+chPmbKaFbJqSlj2ptfJhQ2k24WaTg83FJ94//sen9aLNg
	rpH97/oRKVEs6YHnEdUwTRu13qrk0aU1GxpgYfUep7wR62sLre/vp/1Xn/5RiF8RZB/3KzhSREw
	eC6ob6SJR8g1/BTNhk6Rf8lZ/TRj3g31T2WtIDmNUe0MTMfVDx/cFmqw6vIzCHcuus4G//uSHQN
	YYZgoVpHomN5+73QFRFrP8ezsF
X-Received: by 2002:a05:600c:c4b7:b0:489:1fa4:50c6 with SMTP id 5b1f17b1804b1-48a8447b30bmr8849785e9.20.1777504745521;
        Wed, 29 Apr 2026 16:19:05 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a82307f7csm21201605e9.12.2026.04.29.16.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 16:19:03 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] netfilter: ip_tables: guard
 ipt_unregister_table_pre_exit against NULL ops
Date: Wed, 29 Apr 2026 23:19:03 -0000
Message-ID: <177750474339.3016150.13196470704394042910@talencesecurity.com>
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

ipt_register_table() adds the table to the per-netns list via
xt_register_table() before assigning the per-net ops copy to
new_table->ops.  If cleanup_net runs during this window,
ipt_unregister_table_pre_exit() finds the table via xt_find_table()
and passes the NULL ops pointer to nf_unregister_net_hooks(), causing
a general protection fault.

Guard against this by checking table->ops before calling
nf_unregister_net_hooks().  If ops is NULL the table is still being
set up; the register path will either complete and register the hooks
normally, or fail and clean up via __ipt_unregister_table().

Fixes: ae689334225f ("netfilter: xtables: Bring back xt_register_table()")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/ipv4/netfilter/ip_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index XXXXXXX..XXXXXXX 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1795,7 +1795,7 @@ void ipt_unregister_table_pre_exit(struct net *net, con=
st char *name)
 {
 	struct xt_table *table =3D xt_find_table(net, NFPROTO_IPV4, name);

-	if (table)
+	if (table && table->ops)
 		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
 }

