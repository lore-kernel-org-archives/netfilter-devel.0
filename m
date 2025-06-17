Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5D1E48A;
	Tue, 17 Jun 2025 07:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143624; cv=none; b=KEI8ngdX+YGPO2Rez/qBY0V1ADcBL7gz9AEPT7KVXiGEtUbjylSckFLp6cN9YyB4i50p4z4ykYeKxJJgGgzGZQb4g9vu/4IZXclTwDoSfVBbMWFsLvJJC3/2tAGb74oc4XQuw/+uv134RB8zIC3rKYmAfsDpIQtNlAMkAH7QJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143624; c=relaxed/simple;
	bh=v2J0+NrjK93YIJ9wwP6/s06ATKMp3SAV2YiOdhemPvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBc+IKg9qvvC0giUtkjtvgi7uD9swHf02U0iTkIwomUjat1ScYLnlEoyL3HWmYuV4bZyB4WW+NYU4kb1uoa3fOHbubF6qX9KfptL5vpMQn2SGl+qhQHttu96+YKeF4fY+hy+JdeA+u7egqgOE3PitOkRz7xBCj7yWhfAFaNvAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=elUM3sVg; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elUM3sVg"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-607cf70b00aso10758570a12.2;
        Tue, 17 Jun 2025 00:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143621; x=1750748421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j7d/z2doUSKns09gdnvRl9do/pbJm4slCcR4doQbLpw=;
        b=elUM3sVgRcHV2iPKEd536ohSIXZPq56E27+HXF4jeFkIurmxraT75Dtkql3slH+vJy
         JPeaozXQeeQ47Ck6kN97IlRAU30AfrLsP04CxsAy4lApFHBMs2rh3p+g7sco8vmfS9Xd
         MMOf8ysGk0LJ9iAL3u2YmWQBPRuygADc8fawonXu+XTOqWs7AQGY2t2y7CsDbmkdQpDt
         OgWBgaUF+hBqX3pO/WuqD9N7oPkO0x7+2KQvR/dbTGhX/i7iroenDePe4F5db4nyZfqb
         h9BI0l5xsbZaWV5Ig+bhPEhNlccZrhDPSZdKhUVo8AcMM5Oc6Q94lKh1SQVYR9r4b9jQ
         xS1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143621; x=1750748421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7d/z2doUSKns09gdnvRl9do/pbJm4slCcR4doQbLpw=;
        b=NNje24kXRX/PVAxYgqNOxqyoOoaB5H7IJjT7xNwkNrB0Lt0HZuroOdZAFeyBpMYII7
         OenryfmS8L00iq8YV1jeavKm3el3GmsW/xZ0627JbSUfYxBs1VMFjZ30HO6R+mPpi0j8
         U8Q3IV0vl1EPHqQJaxipr9yjA1sd4239Bf1Tg4Hj9C7kD7lRUzyUovv0mB5jAtp7u+lo
         Vv3dLSbnOJon2AHPoaJTNGnNqrRExJD4/ek9JUf9Lor3JQJizlVT7mFHs843u9J+zNsD
         yfpQLOpES6iiPqHIcTmVcYNtia+LMI8HrqwujufWBlYUKpNiPRuYm5uqRMuwNh2zfnEs
         HGzA==
X-Forwarded-Encrypted: i=1; AJvYcCUhx+v8NEHxgInw02zxsVtB/Wqy38r/uhoLzx97ZBTyP/d42wDYNFUgu4qsQ1TwtfS25p7eQ2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfRpVz9cCJNQ18UwxbshQgZd43qR8iuX2qbR4g8M9fPEl0lz0c
	DD1K67QeuCqaCYUAE3yZxWl/EfQUBRo5l2o2yVlD4IK6+R8/qO1LG1Rj
X-Gm-Gg: ASbGnct8nQIIHM096iUi2bxt8J8QcqG/bXMRj71XE0wD9RiOrI7+W5HWWKi+hr0rV/P
	11yRCFpF32zUQ0SHo0Kq8cnDdbzfyGj0+0dbHxIOPdUetk0JbBbVeeLXQaOBx/jEapAT3nYgBKk
	zXzQRMNGr9MIxapBtYCOLPm+CLwuJNNlqwlXxJS8zqpSgWJ+9pWIQUAuiD4PKZbaqNShVVHz6AN
	TIKmbA0+NHdWa1weehHRjMkhKFleoe8vKj+ine1kZJrdPIlZ1KbuervbLmH9/BTuAykh86liCu5
	ba/vRseY1HaRJ3MSle/ltSpCvSd3cXJJ6q7Pk55BSramK9/Ji4z5l3X/ZoRJDNeUJE8zfdbGMnh
	NVeLBEha+UGbVHc9Whtdj0kqJ6DvEuARq7/zMmIrikv1fZ9tbW0XEM+IDc93DEIEkTDmAO6XhEX
	O+vOW1
X-Google-Smtp-Source: AGHT+IExd5+F93EDxNYTFDSUQp+G3F25AgucBy7BLOo9LJMjzHEaz4Xw9YcVsqcNiBE9sK+dUfyZ4A==
X-Received: by 2002:a17:907:2d29:b0:add:fa4e:8a7a with SMTP id a640c23a62f3a-adfad53aadcmr1019158566b.34.1750143621029;
        Tue, 17 Jun 2025 00:00:21 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8158d4dsm800843066b.28.2025.06.17.00.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 00:00:20 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v3 nf-next 0/3] flow offload teardown when layer 2 roaming
Date: Tue, 17 Jun 2025 09:00:04 +0200
Message-ID: <20250617070007.23812-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch-set can be reviewed separately from my submissions concerning
the bridge-fastpath.

In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
used to create the tuple. In case of roaming at layer 2 level, for example
802.11r, the destination device is changed in the fdb. The destination
device of a direct transmitting tuple is no longer valid and traffic is
send to the wrong destination. Also the hardware offloaded fastpath is not
valid anymore.

This flowentry needs to be torn down asap. Also make sure that the flow
entry is not being used, when marked for teardown.

Changes in v3:
- static nf_flow_table_switchdev_nb.

Changes in v2:
- Unchanged, only tags RFC net-next to PATCH nf-next.

Eric Woudstra (3):
  netfilter: flow: Add bridge_vid member
  netfilter: nf_flow_table_core: teardown direct xmit when destination
    changed
  netfilter: nf_flow_table_ip: don't follow fastpath when marked
    teardown

 include/net/netfilter/nf_flow_table.h |  2 +
 net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      |  6 +++
 net/netfilter/nft_flow_offload.c      |  3 ++
 4 files changed, 77 insertions(+)

-- 
2.47.1

