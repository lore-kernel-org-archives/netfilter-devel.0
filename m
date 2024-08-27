Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31231C57A3;
	Tue, 27 Aug 2024 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770402; cv=none; b=u3bk7QxFc3tqzbbr7jx5c9dEdcGmG7fKdINHlPAxbsfcBrUdEIQ0w3HSacMYMIcdZcBHynco/NG3w00dDZWLGx4zvkBhw/yYW7N2F+3v1Qk/geclUlGWX/JQFuxoijSbDdKzVuP8FgoHfQgWb72dbqRLrjyDKlMYnYIlmhy4MYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770402; c=relaxed/simple;
	bh=NHDwsz0xtPHqFSQbOQ3vz0XTK+7kW/ZxjquzZZ/rOyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i464EmH/0XrzsA7TDf0cS+DO9S3leTm4jIXs4JU9uUTWVfmzkyt2EHDDCTlAjo3oLAfBteF8EiDgwcMgrTX4atCKDkBS8gpU2Rz+43HZGRythz4D9X7DsriTWBFo+t22C2sQ9nGJW7/cEA9XMdguzeR3Vr39a+Dy5Krf7VKE0bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a86e5e9ff05so119402366b.1;
        Tue, 27 Aug 2024 07:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724770399; x=1725375199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7U3K/hyiIatkLE7W/rIDb1QwHLRm5PtGb2NGHRGU1Q=;
        b=UMmQb7NsrbPNpuvYxU9xICOfvlStqm9E9ezAn1qThO+6/EypHVvluP319FeGyM0INR
         knS3yP36akNtABE5t+KAW1lVfpSRBvPiR6nLmjwTV5eqGftaRNHqZ6pIZi0QBquAAUvB
         IjhythFSPUw5nZumXWIU+X8hdE6IuuSKOpewxbWWGVRdt+rJUydw6ZIUQiTgunr5J+AP
         H4e4698OsU87USqOBm9VDFHjZ2eIkIfm4QE2bP2SZkVOy+wWGqrXjilj0nViTfIs09A2
         K5GjrhOXb2fJxawSMxGnzRb2Dpd0W3ZVDqzsnJBRTm8qRLps3KKWRlIXMEMgxQKRckjI
         3ycg==
X-Forwarded-Encrypted: i=1; AJvYcCUr6vFaLww3UcdD9aPtOZZLbztZX98Shb8Z284NCXRj9zrrpVJML3QXCRws6SSenlLUGUdnsWEGCtsIqWEGjEHP@vger.kernel.org, AJvYcCUtUQiYSbuYUl5Kx5V+IAZhfEyS5K1MMMJWZvm6cDWGsi25MNYj/CCoKmrsz4XzmkCCI5zdkW9zU2HKb5k=@vger.kernel.org, AJvYcCX+/W4on4p0SmUrfyxHyKhHSZ3QfeaaGGAUSh1/apJxY7/vCtMjvBak01xLa9NP8V2DqgTR0NS1@vger.kernel.org
X-Gm-Message-State: AOJu0YzZVH7RYfHe6VAgD30wivBL6ALH8UnYFmP0SjdhUDHWrykRZvGZ
	7O4qBjgS/Ba1ouSx03Q7eiwRqVAC55Br9K0X33LN0TDRwpd3gH1Z
X-Google-Smtp-Source: AGHT+IEcmGBKu9wpR2Z7xdlFgg0LT701kvwqVnrQ5BpD9P2y4GakD1p0SQvwQi53WacX8BdqIvLiKA==
X-Received: by 2002:a17:907:1ca4:b0:a7a:a138:dbc1 with SMTP id a640c23a62f3a-a86e39ce823mr215762666b.20.1724770398282;
        Tue, 27 Aug 2024 07:53:18 -0700 (PDT)
Received: from localhost (fwdproxy-lla-115.fbsv.net. [2a03:2880:30ff:73::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a86e549d00bsm119368266b.66.2024.08.27.07.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 07:53:17 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: rbc@meta.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY selectable
Date: Tue, 27 Aug 2024 07:52:39 -0700
Message-ID: <20240827145242.3094777-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
Kconfigs user selectable, avoiding creating an extra dependency by
enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.

Changelog:

v3:
 * Make sure that the generate from  tools/testing/selftests/net/config
 * look the same before and after. (Jakub)

v2:
 * Added the new configuration in the selftest configs (Jakub)
 * Added this simple cover letter
 * https://lore.kernel.org/all/20240823174855.3052334-1-leitao@debian.org/

v1:
 * https://lore.kernel.org/all/20240822175537.3626036-1-leitao@debian.org/

Breno Leitao (2):
  netfilter: Make IP_NF_IPTABLES_LEGACY selectable
  netfilter: Make IP6_NF_IPTABLES_LEGACY selectable

 net/ipv4/netfilter/Kconfig         | 19 +++++++++++--------
 net/ipv6/netfilter/Kconfig         | 22 ++++++++++++----------
 tools/testing/selftests/net/config | 13 +++++++++++++
 3 files changed, 36 insertions(+), 18 deletions(-)

-- 
2.43.5

