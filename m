Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C90C143896
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715858813; cv=none; b=Ehm90vY1mH4ZUCr3JL/6S5/gP5bDva4puywE2Bf5zUEegG3saUw/5gT9CO1xDFG//5OcQIXYbSGDtcpA41dyh3W2zfJeP98jgYXEXriwSajSR7QPSMbr6A32Q3RF+PTEthMT3Yd9pm15UoOUIFTnL3p0FNZbwUJkA+K487QTHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715858813; c=relaxed/simple;
	bh=gD7wgv7uHJaAoDg5+pnH5KPpjLAoRcPGMjlAYZehQSs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=g7cEMeKt1XYqlW/I0CuNygr1yqm83dv+hYjCWqMB1VTeU7mLWZ/NGBaMuetmDL+a0FnqeVO0iCRqOeG6RDeai4x3bugqz9YS3J+MEB9y5ggbG8v7LZBqOC+YLfh4T++D9/ZPHO54ZAm8rkNbRXgCinBU+DhdhWPN4NF6/W6Slqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/3] vlan support updates
Date: Thu, 16 May 2024 13:26:36 +0200
Message-Id: <20240516112639.141425-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains new vlan tests and one bugfix.

While working on the kernel fixes for nft_payload vlan mangling I found
one issue with vlan matching regarding bogus protocol conflicts.

Pablo Neira Ayuso (3):
  evaluate: bogus protocol conflicts in vlan with implicit dependencies
  tests: shell: add vlan double tagging match simple test case
  tests: shell: add vlan mangling test case

 src/evaluate.c                                | 69 ++++++++++++++---
 .../packetpath/dumps/vlan_qinq.nodump         |  0
 .../shell/testcases/packetpath/vlan_mangling  | 75 +++++++++++++++++++
 tests/shell/testcases/packetpath/vlan_qinq    | 52 +++++++++++++
 4 files changed, 184 insertions(+), 12 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/vlan_qinq.nodump
 create mode 100755 tests/shell/testcases/packetpath/vlan_mangling
 create mode 100755 tests/shell/testcases/packetpath/vlan_qinq

-- 
2.30.2

