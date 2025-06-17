Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1420028BAAD;
	Tue, 17 Jun 2025 06:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143535; cv=none; b=ADnij38RBM/XnEg7voKwLjiYFIeYwbial7zk9q9aq5j0UBr8hhhnsdy+Bs3iWvx80F0FpoSUwdKWi8ICaaVlNkg4mmwnoaUA1wQ/NM6RZw1pJ7yQ8ehEOgNXS2EHhNhctii0nbI87DJfm10ryfljyI+rChhkCg2f61ShEds2i30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143535; c=relaxed/simple;
	bh=NyldArvQ1w/4Y84MUaUrw2GtMMsFi72AmBHahegFWGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QSR7H3CM52DohLw0WXt1fdc5LRgvGole+Q8nL1R1+1mDUjyLljL3eauLBtIwqpGk6ImXBj11njlEoGZu+2M0Lpehwfr3bSs8dUrhBzALrt5u43+fgvXNhxoR68TIwZvzmP1kMorp1sYLlnKS+FKVR6WrdgjUDaXiJFtf50tLY+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aKQSJBsp; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKQSJBsp"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso9376123a12.1;
        Mon, 16 Jun 2025 23:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143532; x=1750748332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEHkovM/ftOTKmDVv8tlHJdRjSXgOoZevlav+wL3M/0=;
        b=aKQSJBspKNdWRnlBW2k+SBjJKKBLZmj126Ruyqy+vPiRpK6hlLuldTBhdEwOh044sp
         KTGR6opZHQsv+irs8TDMGINbqQ9Q2k+s4bf/hGAPrHLTvAj3AaGXOUZgxgK0VG9+j43n
         VpiURRQmha9amm00PoZE427J6/tukUrAkQel2Lqr79JYPIt8ip2MK1nQiO7buldoqAP0
         dYo5ze0uzM4OctyLWzpsGHb0hZyNRvEH+2kqWR9kT3RUCnMvfkU28Mcwf0mrXdI6wIpP
         TJLlS+mQ7O+0EtsnCfLWSkwWt5tXuh4mhcbqoqVdlFhWkcdl7sFOJT1hwbZwlS+gqxMR
         aALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143532; x=1750748332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZEHkovM/ftOTKmDVv8tlHJdRjSXgOoZevlav+wL3M/0=;
        b=Zqgpi5teI9uXO6GTP+JzOBzxU4QsLPnkSLVP4SykuSW82H4zo7JdlSgd1MBs0OAiXz
         te7mydmXEjiQ5DW0KK7sKGeOayzuZHc9sLM8GFFhdqy5NzAEMniBRNPYCkeskGYMWWlv
         yIDt3wvwhzhxbL9p+6QOdvCdCI4Wcc4ghEVbhi7BrDLInp6kkfDAKwmIBy+k2igZQjk/
         1gXkiN5DUeW7w9lV86DLyvfFHsYLmu9gAvbxfwp9ITmdXcUpB6tr0xxM1HW8RMDBSK5r
         IdYLR/WPzErQc85Wo7BssdTcjfjPQfwhQ0/CD0IGZJtvtswm8B3skskytvqqPLjc3iUi
         PGpw==
X-Forwarded-Encrypted: i=1; AJvYcCV3tTKXRIdIA6zUb/Aqpe2jUiTkDDokjT0s8R7COeDO/4NIyH6EHwBaunSeaXHpmaQ3k6s5D6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwARFvSVeNQY+nC/YzEaiZDtTLP/W55Sloz1+WQPbS72v/dDY0V
	EOFLkrE3+ryqnz63AbnArdro5Y5GLJJGTl5c0G17+sjECem4O75RbJVC
X-Gm-Gg: ASbGncuLi6K9uv9mYkHVo0pZ/pWXC8YBKDbAj33wkXA2l6/Czf9WQqcJ44WY0J69czg
	nl0quPlnF2zLJIoB9dvXfqJWFRxZqfTSw4LeMyH8fyOrx7Y6w32Ii/cmMLiuZFF3e9gRbUlOeLz
	6zjGgvy0NnKL7A7R030V+fWZl47NN44oi2VciT6FUY26kn9ajbxiXtddqTspHN2YRB0MlgY8wKU
	3mWYKekfwm/U5cb+pLKsyc4xTN6RH+E2Va+cfssgZzAkRv29x5VTZ0rE8NI5Y6Q82LYwXjw/2vC
	ypxw2a1ijE/hcrShdB59ZiczwKKoceqxZflos2jgz1T8x0MKJ3O4WsEN1ovW4NDG1/YuP4G2n2L
	2gDdDhAuOWT+4oGQNQ5rTUN/PHWCz0KboxAoe73c4/b8BZh+I9l+lPdEomulBdhwf/dKdwLfQo+
	gRDfgA
X-Google-Smtp-Source: AGHT+IEkEroXt6hnnQAHHBHds3G+bUNLpqeXOk2KWlfIM9C4ys+anUXEcA/XK2csXAWbF2ucdi7ILg==
X-Received: by 2002:a17:907:868a:b0:ad8:932e:77ba with SMTP id a640c23a62f3a-adfad4181e5mr1163989366b.38.1750143531293;
        Mon, 16 Jun 2025 23:58:51 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec81be674sm811109566b.53.2025.06.16.23.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 23:58:50 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 0/2] conntrack: bridge: add double vlan, pppoe and pppoe-in-q
Date: Tue, 17 Jun 2025 08:58:33 +0200
Message-ID: <20250617065835.23428-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack bridge only tracks untagged and 802.1q.

To make the bridge-fastpath experience more similar to the
forward-fastpath experience, add double vlan, pppoe and pppoe-in-q
tagged packets to bridge conntrack and to bridge filter chain.

Changes in v12:

- Only allow tracking this traffic when a conntrack zone is set.
- nf_ct_bridge_pre(): skb pull/push without touching the checksum,
   because the pull is always restored with push.
- nft_do_chain_bridge(): handle the extra header similar to
   nf_ct_bridge_pre(), using pull/push.

Changes in v11:

- nft_do_chain_bridge(): Proper readout of encapsulated proto.
- nft_do_chain_bridge(): Use skb_set_network_header() instead of thoff.
- removed test script, it is now in separate patch.

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (2):
  netfilter: bridge: Add conntrack double vlan and pppoe
  netfilter: nft_chain_filter: Add bridge double vlan and pppoe

 net/bridge/netfilter/nf_conntrack_bridge.c | 83 ++++++++++++++++++----
 net/netfilter/nft_chain_filter.c           | 55 +++++++++++++-
 2 files changed, 125 insertions(+), 13 deletions(-)

-- 
2.47.1

