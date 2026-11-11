Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794416516;
	b=CguKV9H8/BGUuqZ2MIQal/vYHNF8uALDMRItAO0WKap11U4rfvVKKs2NEkLUzVQFI4QN
	 xkSHEiKk5x6OxO+XhsEq2lJ3yQkgOL34JO3bEg734bKbe6BgguwkOtn0bYfL0qq4gKcD8
	 cYSK9AxBmwehN1Cs9+LXl8LkBNK8BlcpC6dbg/rXh416N+oOi0YNnV09S+tkqeGJBIPZj
	 wICnLKZCfONIyNaUufGeGcbIfHrkWpDXDVc46U25W+y5Cz76Z1qkBHB+DpNaOJTtVRLFX
	 pAhH0qOOSWIGeA9P4AJ4GyJYNVcO76hM6qf5ujke+JK/AZhGQwYjC7FLltxOy9fLZEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416516;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=JujlNMN/dQ1wqtVfmIlI0r3PS3pK4QKFo2RP20NXSPI=;
	b=NWh3nYWyaTRpr18QiTYIcUJjvItPZhBP65ceUk10AhBppOohHQrWV74Slnd2b86RQUIE
	 5VfloEsIrJGTaV1xZ2mwIVfbzSKWMGYbnlAOcN0abIir61d7A4fv5es0hzx7V6oM9zJ61
	 7OLpMwnZdb4tghze3v6RWsyKmZz2Id/km/Muc5kYq4K2C6XRuI24ew8YDcNTZ7H4T8siq
	 qiXPDNxdD1px5q7FQg04vEdgVT+XKwOlCSpasN8l/JpOk2MAFoORYzvPBnGpkiS3JS2rI
	 O0xg4KUuv9zPwzL91Agt+h4Zn9ZVoQIMI7ha3GPxAjgpNXm8uriH19rHNLhaPyKfpew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=FWhqu6p0;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CC8606A32E
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 17:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65CC8606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=FWhqu6p0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JujlNMN/dQ1wqtVfmIlI0r3PS3pK4QKFo2RP20NXSPI=; b=FWhqu6p0PWqQLElbHHHH0Pqg0n
	6lOFIUPhYWW7CQYMaUC5V7RtdPL/m206BUcdzV44ijUa+cv/0bccti93cvw4Ud9DsvqjVXBfRDT5U
	oqtKcDJT8YKdvNuXZDVwzvau7W5VDP3/80rDufKkfUv71cc/GaYskxY/WMHQkEyfBGn74WHq/v2Xv
	+cOLFc38oYt676NxOytybMVlyO+09xKFnPoonakASFfaSQHC1cBpsDQLlC+S6/XMzHQOJUt77Uqup
	K7OS5ULp71H26lvS8LvLQVAqknNUjG++BDNda//EsLo6u827EBKkeq+yPJ1Xwbr+87xBS5ciwLGWj
	e0z0gAAg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRBhq-000000006ym-0X3P;
	Wed, 11 Nov 2026 18:01:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/3] Fix two leaks in error path, one extra
Date: Wed, 11 Nov 2026 18:01:44 +0100
Message-ID: <20261111170147.47501-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first two patches fix for a recent Coverity tool scan. The last one
is unrelated and not worth sending on its own, but matches the other
two's severity.

Phil Sutter (3):
  parser_json: Avoid storage leak in json_parse_set_expr error path
  netlink: Avoid storage leak in tunnel_parse_opt_cb error path
  bison: Drop pointless NULL-check

 src/netlink.c      |  4 +++-
 src/parser_bison.y |  6 ++----
 src/parser_json.c  | 15 ++++++++-------
 3 files changed, 13 insertions(+), 12 deletions(-)

-- 
2.54.0

