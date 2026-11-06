Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.25.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992752;
	b=2m6CVxcRSGjbehwSULa4GO79so622faNyn518vSlJePqHdGk33Wqf/VJmWz8LRk4nBvM
	 gvS+dEymqOBdwZRxSLFlhY4CqBCWNOGUNqBnsRPeG3olwrT6EZ5vqXJf2el93fiolH4xI
	 H4GbCPkhfRh5PoJGon/MOmi1GPfUylBVVAZFKOHy5H6hRujVpm2AjT2TgHn8+Y7tBzcu4
	 bpalAqjOOruGxWS9RfFU6PtYmIfVRwFvtosyz1rNr9BepT8JTmkIZyEFWoYhsUKu0cJuC
	 opEUSdy/RS4dduoR7uH5sQi2lbYqjDCmUL77aYSDvzWLYmjEjowFbFkR55SHwv+wkhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992752;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Infomaniak-Routing;
	bh=j4X4UcJrCKMHbetOFASwsBfb0nlhEvLHQLADZ6u5e1g=;
	b=NHicAtJedlOnie0baq6dZL4jdHng92OcIglN4sxI7Khb7l6xleFdNTwlzxwxMBQzlALn
	 QZQ6swGaUDA5tpY7KilTrxHgR02orgmjhdq4aP/Otw2ZMqbk9JMQ5W9P26D28SKpHiyBK
	 4zgF03rUJbwtt1qkw0an81Z2tpcH+AVYks/zvlJm47fEbVSk1N2EzVtDpofWxe57IR0ah
	 UNAjimip71Lt5nl2QTsHqqm5q62Srw6wwu6YSWwZV7cr+2oz/NbTahaCCImnYcMsMIksj
	 7V/VroljzlR4Lbo0TELfC3qa0RbbxGbGrOrHAC83/Z0UMoQ1QAL0QHUI7dCt1akX+iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=DisP61kH;
	arc=none smtp.remote-ip=185.125.25.15
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [185.125.25.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE834606A32C
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 19:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE834606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=DisP61kH
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jLprR0DgPzRnC;
	Fri,  6 Nov 2026 20:19:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1793992742;
	bh=j4X4UcJrCKMHbetOFASwsBfb0nlhEvLHQLADZ6u5e1g=;
	h=From:To:Cc:Subject:Date:From;
	b=DisP61kHZ5By+H0cI4pwDrk4Fb4VDw/4MhJHiR+X+FBvVLFx4q44Al8lUOg/OCH9f
	 BhfFUEEsbO7evV32oFPi2SAGncWObByv7OnD9IE/o7ML/Qej3d6bwBGQr8FBiv5jBI
	 fkEXayQ/MEWBlMy7qsaqRlJufs6rERNGHEe5DFFgPlEft9Eq66Ifu1sp5iPw+yVif2
	 pxgMErje4+LyfgrYGILqurvZInPt0D0SnybPAOsZ4fN6S2PI9yB6sjwPqLT2QiQFnQ
	 +ytuQEh9IvXPFyuSC6StNlTrPIMrAAY8OT/u8Ffeubc9/tEfLhw7ZK9bHWHTthhl4A
	 vL1gTSQSClxnQ==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jLprQ0hJdzRsv;
	Fri,  6 Nov 2026 20:19:02 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl 0/5] libmnl: fix memory safety issues found by static analysis
Date: Fri,  6 Nov 2026 20:18:35 +0100
Message-ID: <20261106191841.1645-1-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
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
X-Infomaniak-Routing: alpha

Hi,

This series fixes five bugs found while analysing libmnl with Frama-C
(Eva, WP and E-ACSL-instrumented fuzzing). Each one was then confirmed
on current master with a small standalone program under ASan/UBSan.

None of them can be triggered by netlink data received from the kernel
through the usual parsing path. They all need a caller that uses the
API in a less common, but valid or near-valid, way, so I am sending
them as ordinary fixes.

Patch 1 is the most relevant one. When the message that overflowed a
batch is larger than the messages already in it, mnl_nlmsg_batch_reset()
memcpy()s it onto an overlapping range and then reads nlmsg_len back
from the overwritten location. With limit = 100, a 20-byte message
followed by a 92-byte one leaves mnl_nlmsg_batch_size() returning
0x97969594 on glibc/x86-64, and the next mnl_nlmsg_batch_next() uses
b->buf + 0x97969594.

Patches 2 and 3 fix out-of-bounds accesses on unusual input:
- The *_check() builders compare the unaligned nlmsg_len against
  buflen while the attribute is written at MNL_ALIGN(nlmsg_len), so
  they can write up to 3 bytes past the buffer.
- mnl_attr_get_payload_len() wraps for nla_len < 4, which makes
  mnl_attr_parse_nested() read past the end of the nest.

Patches 4 and 5 are minor:
- mnl_nlmsg_fprintf() can read up to 3 bytes past an unaligned message.
- mnl_cb_error() can compute -INT_MIN.

I can send the reproducers if they are useful.

Thanks,
Florian

Florian Stosse (5):
  nlmsg: fix overlapping copy in mnl_nlmsg_batch_reset()
  attr: account for alignment padding in the *_check() builders
  attr: do not wrap mnl_attr_get_payload_len() for nla_len < 4
  nlmsg: do not read past nlmsg_len in mnl_nlmsg_fprintf()
  callback: avoid signed overflow on INT_MIN error code

 src/attr.c     | 7 +++++--
 src/callback.c | 5 ++++-
 src/nlmsg.c    | 8 +++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

-- 
2.56.0.windows.4

