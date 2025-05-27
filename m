Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD69E2DCBF0
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375724; cv=none; b=tnJgruVkjZ9PxPWjRCGP3Hp/r5w3Ice5uMTgfG2aAgpca+0vezg9ILyakuww+MBZtlYaYFTJdkJSGThrjyH39nZISKQv3SsDU9239Bkz0hvtrFVTcsSnzJTTdCcc3YfPInsHwEL/nHQVxdcwIzVCbvZkX+gfWyXLJWRMm8Mj8ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375724; c=relaxed/simple;
	bh=C4nhPTbZAvY233fYUWxxuugJ/HiJdZE2jZAkP7OVezg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/uzMQPYJiJ2w9fsO5i/7zvU6fpXaSljw0dG+1ZV/HOqB7xenyEUBrhV04gmro+CLd0jJ/7cFZPktKIEnfRmlVz/3+ZxEAoKUcLIVNF2/siCFNQGHW81Vp2PCt2K9pKLpAAypkI+GxhZAfqLJStiG9YQzt43NyMmlEoZWxqpMFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=P+RG6mse; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tolEKu+w; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v6LJTcVl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=uzir030y; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="P+RG6mse";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tolEKu+w";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v6LJTcVl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uzir030y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D697A1F399;
	Tue, 27 May 2025 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=u+1CZKtFzfwtzap1RfRgjDLIxFm2pl7j2g8jifq4E8A=;
	b=P+RG6mseAShJJUD6dGSOBFyttz5LETSIatdooksUuKwrm/eUPmAqL+Rh0+OlJn8VaP2Ks3
	m8/fbDg8pH+11SFAS2WXNDy4B7n+sAQ2DNCPZinMy0UepCDRfwV9rcKjklTeWD3DhiZzHd
	CuDg8X/mvtWd47E4yn7xQxCjiwZbrUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375721;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=u+1CZKtFzfwtzap1RfRgjDLIxFm2pl7j2g8jifq4E8A=;
	b=tolEKu+wvuCZYYyqlthyx768e6pNS5vt688uLX//XJAaKYm9Q5ZSrbzpiPdzql5AtNMbL/
	2eQF4iXkInv9gIAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=u+1CZKtFzfwtzap1RfRgjDLIxFm2pl7j2g8jifq4E8A=;
	b=v6LJTcVlgra7L/1YOfMX2DBfZg5xVb5Ah5kU0cCSuLF7+Mr9zmCRW3V+2/WoFB6TltWEns
	ZOvRD809V9axI7dm4YfA2vvJIBIuBe3wpLY6lvsU++drczhhLAAfKm/yD8NtFzrGnFtjd3
	SUAvsqsH1Q5H7nlQ0odzXSIfs8AEvXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=u+1CZKtFzfwtzap1RfRgjDLIxFm2pl7j2g8jifq4E8A=;
	b=uzir030yY5pyBkZPXEZjsqAu/Uf1/Hcj9ny61kpV+3jbKsfwLLd1JgYUoUXpJJShB58+Ly
	4bFDUm+ZHFPysaAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AFBB136E0;
	Tue, 27 May 2025 19:55:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B/Y3HqgYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:20 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 0/7 nft] Add nftables tunnel expr, stmt and object support 
Date: Tue, 27 May 2025 21:54:37 +0200
Message-ID: <cover.1748374810.git.fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.28 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.18)[-0.876];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.28
X-Spam-Level: 

This patch series add nftables tunnel expression, statement and object
support. The implementation was splitted in multiple patches to ease the
review process. All the tests are passing and no memory leaks were
detected with valgrind enabled.

Please notice this series requires the following patches:

* libnftnl:
  - https://lore.kernel.org/netfilter-devel/20250527193420.9860-1-fmancera@suse.de/T/#t

* Linux kernel (already applied on net-next):
  - https://lore.kernel.org/netfilter-devel/20250521094108.23690-1-fmancera@suse.de/T/#u

Fernando Fernandez Mancera (4):
  tunnel: add vxlan support
  tunnel: add geneve support
  tunnel: add tunnel object and statement json support
  tests: add tunnel shell and python tests

Pablo Neira Ayuso (3):
  src: add tunnel template support
  tunnel: add erspan support
  src: add tunnel statement and expression support

 Makefile.am                                   |   2 +
 include/expression.h                          |   6 +
 include/json.h                                |   1 +
 include/parser.h                              |   1 +
 include/rule.h                                |  49 ++++
 include/tunnel.h                              |  37 +++
 src/cache.c                                   |   2 +
 src/evaluate.c                                |  30 +++
 src/expression.c                              |   1 +
 src/json.c                                    |  99 +++++++-
 src/mnl.c                                     |  77 ++++++
 src/netlink.c                                 | 121 +++++++++
 src/netlink_delinearize.c                     |  17 ++
 src/netlink_linearize.c                       |  14 ++
 src/parser_bison.y                            | 236 +++++++++++++++++-
 src/parser_json.c                             | 190 ++++++++++++++
 src/rule.c                                    | 178 ++++++++++++-
 src/scanner.l                                 |  24 +-
 src/statement.c                               |   1 +
 src/tunnel.c                                  |  94 +++++++
 tests/py/netdev/tunnel.t                      |   7 +
 tests/py/netdev/tunnel.t.json                 |  45 ++++
 tests/py/netdev/tunnel.t.json.payload         |  12 +
 tests/py/netdev/tunnel.t.payload              |  12 +
 tests/shell/features/tunnel.nft               |  17 ++
 tests/shell/testcases/sets/0075tunnel_0       |  75 ++++++
 .../sets/dumps/0075tunnel_0.json-nft          | 171 +++++++++++++
 .../testcases/sets/dumps/0075tunnel_0.nft     |  63 +++++
 28 files changed, 1568 insertions(+), 14 deletions(-)
 create mode 100644 include/tunnel.h
 create mode 100644 src/tunnel.c
 create mode 100644 tests/py/netdev/tunnel.t
 create mode 100644 tests/py/netdev/tunnel.t.json
 create mode 100644 tests/py/netdev/tunnel.t.json.payload
 create mode 100644 tests/py/netdev/tunnel.t.payload
 create mode 100644 tests/shell/features/tunnel.nft
 create mode 100755 tests/shell/testcases/sets/0075tunnel_0
 create mode 100644 tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/0075tunnel_0.nft

-- 
2.49.0

