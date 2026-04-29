Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6874538CFF1
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 17:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777485377; cv=none; b=egAkwHJ2VDnRa7LMz6w/xY76fCtuPOnJy+kUPaQRHHLhNYBc0lnRfH9nvyRPIiFt4EHz74p9TInoQmQPwW+eNOo6GE4A4uHnlp/QRNcMoNtJWXSU7zQRUD2gIjzf3btcNgjV1R6QGbGU4FosMQuhrNyj938hxP80YMRKGNTjCmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777485377; c=relaxed/simple;
	bh=3OxTu4QNmh4FcfaWOckhLbkPnokTjOz1m2MKBETIPtI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DoI9P9hoV+lk8JV0RUlhi++C3q55shYLihpNgBdBMgIriopzEPMkE39SzNllwxzJM+hcpq03EbSwn8cl8JpVdIR3KVEKVFdbIZbbDefqHdbx+kDf+F0M4kit1MfcQgUNujyLGrZLVHOYaW1+1f8QgO5HZwbDzDveoBzmXW9Pg30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUoc0w6z; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUoc0w6z"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43fe608cb92so48063f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 10:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777485375; x=1778090175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r4NsrOL1q9Am89S8Z+OaW8+HqXPWLvbAymgwFLwuQBI=;
        b=TUoc0w6z/793eup5Y2+Wx9TN1zDZbPFz7ps9hUwk1FFnuKRsVcFPeL+2Gq8TFj89xb
         7Skqkqp11WXWfyvxwc5pt52RHGC0dZLWcwch9vNGyG4875Z+B/wyt9li1PAtEMgabhX2
         NAZURJLcsimuTEDpkjqf4u+CE231mnvJGzJBVSK6Lg9KcJck9Il4jsOXaFuZ9LInqSCe
         zJWqpPTf6ZIbfuCglXtkTCD2xaLMo3D+gOFzvPhMhx6XwGIJjDlNbJDFyu4yG1fGYpm1
         /AUJxiXGWdnk2TS1xCTzSN9l5Lk0i9gSlOZbQHCgZzLJ6292xcU5CEItS1RBXWvh3iwc
         HJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777485375; x=1778090175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4NsrOL1q9Am89S8Z+OaW8+HqXPWLvbAymgwFLwuQBI=;
        b=DhArQ+ZicPo4i9xZ2QxQqkCG4Vb/LerV1ov+7mV4l8a/c7IFoFADPd2EwY/owidv4A
         /NUuH0HMPM4enI+9QTbjhjxFmT6KfaC8VePFZPrDvxoB9cRhwHGa9no5/rOfhOGqFm/q
         6Aki8M1J16vs1fsQB7ZnGfCvlXldV0D0wsTy/KoF1lL1EVgIohB9F3LeTnAnNBiqbLTj
         r89rNTsaoi51Y2Q9mdznUp3dSqJthUBFagTE1u153L4/E71wdu3uScL0gI1hH7cltjvV
         aLeyXzPXMYQ+A1190AdQlbwqFTriGzFdo97ZSHhdC2LxY5xjD2weANzyH/PIu70wOzgs
         2yiQ==
X-Forwarded-Encrypted: i=1; AFNElJ8yY+j3SyAwqAcndlRIG+/X0nF711IwwmUpSRtDNVIhyLbBNcfdWbGBaz8tf5ttrVENOeHIo7WBWLnMqLsjYh8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf/DFqp8vrOKwPVEYFyCy42JcJOV3jJ9Rkw/K8MPaHWTB8A+X/
	kwCKMcQg2IkAN64JeH3+F95g6Xse3DEkmNo902NHWU+yIla4Kw9qgDU=
X-Gm-Gg: AeBDieubqcsy8Dbpp/rnmpRlmGkrIwL2zOz27Mt6Ztt3JBPYlULBAc4y6+dysYMNhth
	5BW09xhhJl0+vSds4sPjxusHYVR5DoRETnqG0Lujg6VXtzFmQA5Sa9VYPOwYkIhXTvL7jPD9ssA
	kg6NPRW+5JensYZwIAv81vah/aTvQTddSax+TMd2I4Ip6flh0TZjE5C0yepyvPvVIGgzgTHc0nG
	ErRIgg2peMw2+ob3APyLT9G8NJUPURgeg1USX9ryXoLJEZ6+M0WkiyfDxKnHRCVUfUxDoN5tkz4
	GVwEGn7uoQFA1l7Bni+5qXHNtUi9L9WY3Gl9ZHQMZu9qVqD8dBBYktlv1PPGEchDGEYOjRWc5cP
	VmEEPcNkqRS6KsGwtJSJbPmVCG/1LZbqiIvBobk364PjAc+glaz3d1pDerM1nuOdugM6GbLMCck
	sjRt4=
X-Received: by 2002:a05:6000:2305:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-4464a1682b5mr16117702f8f.42.1777485374554;
        Wed, 29 Apr 2026 10:56:14 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b3d48517sm6183750f8f.5.2026.04.29.10.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 10:56:13 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH 0/2] netfilter: fix NULL ops race in iptable lazy init
Date: Wed, 29 Apr 2026 17:56:10 +0000
Message-ID: <20260429175613.1459342-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

ipt_register_table() and ip6t_register_table() call xt_register_table()
which adds the new table to the per-netns list, making it visible to
other code paths.  Only afterwards do they allocate the per-net copy of
hook ops via kmemdup_array().  This leaves a window where the table is
findable via xt_find_table() but has ops=NULL.

If cleanup_net runs during this window (racing namespace teardown against
lazy table init), ipt_unregister_table_pre_exit() /
ip6t_unregister_table_pre_exit() finds the table and passes the NULL ops
pointer to nf_unregister_net_hooks(), causing a general protection fault.

Fix both ip_tables.c and ip6_tables.c by moving the ops allocation
before xt_register_table(), so the table is never in the list with a
NULL ops pointer.

Tristan Madani (2):
  netfilter: ip_tables: allocate hook ops before making table visible
  netfilter: ip6_tables: allocate hook ops before making table visible

 net/ipv4/netfilter/ip_tables.c  | 31 ++++++++++++++++---------------
 net/ipv6/netfilter/ip6_tables.c | 28 ++++++++++++++++------------
 2 files changed, 32 insertions(+), 27 deletions(-)

-- 
2.47.3
