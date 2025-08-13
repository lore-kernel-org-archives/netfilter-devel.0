Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8775D2EBBBC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094315; cv=none; b=R6gwDCyaz5c/vT/vZwrjZykEk4wLiNwMaXhFu0SKexBhIo5yDHRoRHQwUPSpMoEkvSmvia44rvCU1wF+jttmMoujG6OFxogQu8wAhhjWvQfGOFcLOzH9cAfUqkr/ak9EKpWD00vysV6tMzjQtsU4NLVKL2BzEdPON70LMQPSLAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094315; c=relaxed/simple;
	bh=b2XJpp7MWduixvUb5hTEAn3hlim4LCk61V3QXb/kkmY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=ikrplIWLJ7yHseyFpo8vPvv3LUHhrNSpOLHaR3HcwYe1h9Jd0f/VSDMJp+rXZbV6VlRYuKgZ/ALxPFZeqzOO03noDv2WeMbxJ64P4Ci5BxQVGOE9vU9wK0pb1R0AvMtoBTgCY+QYEwUXev/RPZ3NZhq0sHQnIVMmBX745nDPQ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ou8+s3zR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ou8+s3zR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ou8+s3zR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ou8+s3zR"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D3286606FA; Wed, 13 Aug 2025 16:11:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094309;
	bh=TAeOY02v8QX76t8skQLgYntoQE//CgcmyfvspdOjn7Q=;
	h=From:To:Subject:Date:From;
	b=ou8+s3zROZ088tMhqNqqwX+xr7cY/EvB4dGZxeCL5/SvO0qc8T9a8rr0vlEA2KNIB
	 rZ0M7vbK5SR/cij26+F4hnUQ0O4jeUMwmCiGk7EVcMsB/YqanOGibAbwDGFX+7hwQR
	 35JigFlSxKrl4Qnd9xE/CFyEFdUVORjTUK5Q/KSMvR58hSMA7sIHFZ7pfL5abL969K
	 phaD2nMq3IGlm+cYTaRg//Irktkw6oAoVuPJ+SE7OFOcm9xoLpCkQmcCSW5CmVLJ6T
	 Bnm0xtivS1rKfqpTZQuvdKuElE1+Rm9VJTWhxAt6o36TL1Fc03sNHUwKyJbroD8FMN
	 /t9AFfeI301HA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 76ED7606F1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094309;
	bh=TAeOY02v8QX76t8skQLgYntoQE//CgcmyfvspdOjn7Q=;
	h=From:To:Subject:Date:From;
	b=ou8+s3zROZ088tMhqNqqwX+xr7cY/EvB4dGZxeCL5/SvO0qc8T9a8rr0vlEA2KNIB
	 rZ0M7vbK5SR/cij26+F4hnUQ0O4jeUMwmCiGk7EVcMsB/YqanOGibAbwDGFX+7hwQR
	 35JigFlSxKrl4Qnd9xE/CFyEFdUVORjTUK5Q/KSMvR58hSMA7sIHFZ7pfL5abL969K
	 phaD2nMq3IGlm+cYTaRg//Irktkw6oAoVuPJ+SE7OFOcm9xoLpCkQmcCSW5CmVLJ6T
	 Bnm0xtivS1rKfqpTZQuvdKuElE1+Rm9VJTWhxAt6o36TL1Fc03sNHUwKyJbroD8FMN
	 /t9AFfeI301HA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 00/12] replace compound_expr_*() by type safe function
Date: Wed, 13 Aug 2025 16:11:32 +0200
Message-Id: <20250813141144.333784-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is a series to replace (and remove) the existing compound_expr_*()
helper functions which is common to set, list and concat expressions
by expression type safe variants that validate the expression type.

No rush to apply this, there is a reported regression on the JSON
output, in case there is a need to make a new release to address it.

Pablo Neira Ayuso (12):
  segtree: incorrect type when aggregating concatenated set ranges
  src: add expr_type_catchall() helper and use it
  src: replace compound_expr_add() by type safe function
  src: replace compound_expr_add() by type safe function
  src: replace compound_expr_add() by type safe function
  segtree: rename set_compound_expr_add() to set_expr_add_splice()
  expression: replace compound_expr_clone() by type safe function
  expression: remove compound_expr_add()
  expression: replace compound_expr_remove() by type safe function
  expression: replace compound_expr_destroy() by type safe funtion
  expression: replace compound_expr_print() by type safe function
  src: replace compound_expr_alloc() by type safe function

 include/expression.h      |  15 +++-
 src/evaluate.c            |   4 +-
 src/expression.c          | 177 ++++++++++++++++++++++++++------------
 src/intervals.c           |  20 ++---
 src/monitor.c             |   2 +-
 src/netlink.c             |   6 +-
 src/netlink_delinearize.c |   8 +-
 src/optimize.c            |  38 ++++----
 src/parser_bison.y        |  40 ++++-----
 src/parser_json.c         |  18 ++--
 src/payload.c             |   6 +-
 src/segtree.c             |  40 ++++-----
 src/trace.c               |  10 +--
 13 files changed, 229 insertions(+), 155 deletions(-)

-- 
2.30.2

