Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3692BDDB1
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717509958; cv=none; b=PVUEPvy9fjbNjkCAOhkiWc/vCt/T8BvMR8Zf5dX30h480OO/ojkkLUbczo2FxWL/pe5ox69uUen8vqNRYNIt1wPSZoTyFbZVXPm4hwbKS5Yn9I/rJwi5i4OHtBKumn+bePKFm8Asj/csRkPftlLVLkLcWWwr0ghYY8bb2Ao0+lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717509958; c=relaxed/simple;
	bh=I7fEVAC8LXZp2HwKB85/nqd/fjdI50OC9AfB1trNp08=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WtxoPRiLGwpFemFBypMNjFjAgJA+wPEcfoIqEJYnoVV2q97gGBI9ZINWAVsJA4/JWXlazdLsgcMNWTH++lBLg/AXx6DaAt0hY4rL0H5QZeSnFpnyIwWIC7IyG9nUuFLdnoZOnstGBwZrN4iQvbeTO40+bhva7fu0b1ycaXijlis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=lUnAya7x; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="lUnAya7x"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 9A013CC010D;
	Tue,  4 Jun 2024 15:58:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1717509483;
	 x=1719323884; bh=42BgimXdLIn0p+4/F8zZi1MOLBctj/+meznwdOng7Jk=; b=
	lUnAya7xR1c7qReBZAltytYJJSmuHlwPRG8SyTTNLgiB0eQUr7hEYqCdc/nyvfN6
	7AiOksM1K1GXDa9RE5hJcIOFJ5boozlzl9PIx1db2R/73jofsm9a/e/Q4wB7+Lpr
	/NdqygdtM+Dsp92LunHB+IhStrCj1z+fg0bjZphpz0Y=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue,  4 Jun 2024 15:58:03 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id A5510CC010B;
	Tue,  4 Jun 2024 15:58:03 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 9E9AE34316B; Tue,  4 Jun 2024 15:58:03 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Lion Ackermann <nnamrec@gmail.com>
Subject: [PATCH 0/1] ipset patch for nf tree
Date: Tue,  4 Jun 2024 15:58:02 +0200
Message-Id: <20240604135803.2462674-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Please apply the next patch against your nf tree so that it'll get=20
applied to older stable branches too. (The patch depends on another one.)

- Lion Ackermann reported that there's a race condition between namespace=
 cleanup
  and the garbage collection of the list:set type. The patch resolves the=
 issue
  with other minor issues as well.

Best regards,
Jozsef

The following changes since commit ece92825a1fa31cf704a5898fd599daab5cb65=
73:

  netfilter: nft_fib: allow from forward/input without iif selector (2024=
-05-23 17:56:31 +0200)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 9bb49a1f0354a2e

for you to fetch changes up to 9bb49a1f0354a2ed2854af40d7051188b9b85837:

  netfilter: ipset: Fix race between namespace cleanup and gc in the list=
:set type (2024-06-04 09:23:46 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix race between namespace cleanup and gc in the =
list:set type

 net/netfilter/ipset/ip_set_core.c     | 81 ++++++++++++++++++++---------=
------
 net/netfilter/ipset/ip_set_list_set.c | 30 ++++++-------
 2 files changed, 60 insertions(+), 51 deletions(-)
