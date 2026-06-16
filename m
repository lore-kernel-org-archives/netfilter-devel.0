Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813303D669D;
	Tue, 16 Jun 2026 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634657; cv=pass; b=Dx3cPbufDdG4MTxQ9CqgcflWIAKlWkoeORGotDAy8yoWUuz9484PMqmiAFWBzbqOPIVrPqagQcrXvDpm0fDdpEiQMEISqRH7LGz05jdhYG+EJ82aXcRu7MqO5A+k7HuqcAUBDLUfAc5wTmqb7RE2OiHgSSq9vPiIUWvnz3KrAso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634657; c=relaxed/simple;
	bh=W/6XCa+fFXmOkimzDBA0YsqyIXo2sHAUIPDcNMlOvD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cJi9fGtwJreyxWSapEiFkWMIocbDtMaP7ORpY9VxGakWHOzoacAkynNtI9aQevtexFttkDv+j1rxodNuHthh5WH5k9bV1eI4zsgZR19ooS/y4nvBctzd6haUgMAo5a8YbiAQrcDQoe2mOguTEXfWo3fsC5k/tH933l00HzeaSTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=NXqcxvYr; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="NXqcxvYr"
ARC-Seal: i=1; a=rsa-sha256; t=1781634624; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=ZRa8dECivJKxRZzk4ZHM672cB0Z5TjypvXML4ZeZ2LCxVGnG144rxrbfFoU6k9be/2c6pnHOIqF57LTfgQf9MiRXkRsmQpyQTzojgVb5U0zW79f+rSjyyeyeUTPsI8puLySVTEDmgcTM5nfAO6vPce7tkY03BQv1QxCQpxNGnfk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781634624; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=I0jxdcxyJJOT9ab9Aeljnu0Xb/76IESadUXOT1Hspsc=; 
	b=XWEhHEsnMQUQ7QQPrz03VGr7iZSuEvrbIImZDWN95GTjiT8vBiMRywKUod/E5RkzrjiyDtjcM5eXtLun5lnPrCRIyHV0kRgJunj4wKa4JJTrGavb1gvSBgz4e5FNl3gUhZ0JweRc3mNVtgPK61t3uRicSmdTyI8hoVdRiOMKoXc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781634624;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=I0jxdcxyJJOT9ab9Aeljnu0Xb/76IESadUXOT1Hspsc=;
	b=NXqcxvYr1L2/CpQQ9qOXItGMv6fqG3peR3quH5++7l+ja+CaCkQojIL5RLo3tZLn
	1VukCRWdY6nh12MAoXHWaqLFrPMzV0b/Do5UTN6ONuPs6/LvEUrV9WhAy82ALmrHsDN
	IqPh/ZWouEyxX+aZwMNlKb8Ka8N8fFhS/AdW97ac=
Received: by mx.zoho.eu with SMTPS id 1781634621560668.7632641520496;
	Tue, 16 Jun 2026 20:30:21 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next v3 0/4] netfilter: replace u_int*_t with kernel int types
Date: Tue, 16 Jun 2026 20:29:42 +0200
Message-ID: <20260616182948.96865-1-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi all! This is my first patch series of many, I hope :)
I'd like to start contributing by helping out with janitor work,
standardizing code and cleaning up.

This patch series replaces POSIX u_int8_t/u_int16_t with the preferred
kernel types u8/u16 across several netfilter files.

u_int*_t appears in many other files, but I wanted to keep this series
small, unless advised otherwise.

No functional changes.

Changes in v3:
- dropping changes to nf_log and xt_DSCP (need deeper understanding of the
  subsystem before converting these correctly)
- link to v2: https://lore.kernel.org/all/20260615133835.51273-1-carlos@carlosgrillet.me

Changes in v2:
- addresses sashiko comments https://sashiko.dev/#/patchset/32368
  - nf_sockopt: update function prototypes and struct definitions
  - nf_log: update the corresponding function declarations and the
    nf_logfn typedef
- link to v1: https://lore.kernel.org/all/20260612125146.75672-1-carlos@carlosgrillet.me

Carlos Grillet (4):
  netfilter: nf_nat_ftp: replace u_int16_t with u16
  netfilter: nf_nat_irc: replace u_int16_t with u16
  netfilter: nf_sockopt: replace u_int8_t with u8
  netfilter: xt_TCPOPTSTRIP: replace u_int8_t and u_int16_t with u8 and u16

 include/linux/netfilter.h      | 6 +++---
 net/netfilter/nf_nat_ftp.c     | 2 +-
 net/netfilter/nf_nat_irc.c     | 2 +-
 net/netfilter/nf_sockopt.c     | 8 ++++----
 net/netfilter/xt_TCPOPTSTRIP.c | 8 ++++----
 5 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.54.0

