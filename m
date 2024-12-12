Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5311714D7
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734007662; cv=none; b=TLcLiWSUXJV+qk3pkgoIcXJWwWy58GlvOCZ4iOLV/QIm/n/nmPT8WSYoWaT+/jaw/CiLADcIdBzHBU0KM+4vvsgfzFgJEwFqfwQeT4oLuDtAwfGWkuRgJffO7WLWFN+iaTOQeBpY9kfUHtYsxXMFaySkXEysQO0HMUqFi600+2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734007662; c=relaxed/simple;
	bh=lYwbo5zYLyqHtqR+WE+V8duza/uYNemhthtCtIASamU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y2ndoSCZorQPhfSIZ+6zhf8Bf8L9Kl1dZDTW6oj4PqMUW5ZpzBSwpDOXY5p5lQO37tOSOjyUEECE9azyDGhtFOy4I5MS7z5FUQ2cAYtBi3jmut4BsJsjgDAV9x5nSGby476CiT47PEthoWzHr5cSuVB2Gxsdex1l18FB0476WmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=M3vX/YE9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="M3vX/YE9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s4O7kgdG/BJRicX1uzU3LnLiwt8+t7zdCAwZOeJRrrI=; b=M3vX/YE9tHyro4ciStwXFdTZrv
	Rwf6XyT0F1+lFkRnRZ54q0vXUE+6VKmdrNupaw3PUOEgCoPsD3T6/SSz3Icn0G9ts2NPusA6l4mmb
	1f+bU1Nnoh9V06qX675zb6ypuXheB5XwD8CSLjyjvs3T5z7bTCzWdGIMJm2JucTbypMvSh9unFqJq
	cPBlv2q7/k2Ib8Sl07Mtci0p4Cl25rknfSb9j4cqzSiufn8pS0GsruQCzuArdBG6ar1Ov5IvG0eTW
	A9DYz4FD+LlMGBhNExxP5uLoCh0g+w19afUlpkadOVqeazNnIKgV+47TIRUpV3hbxx8CXZC4V5GwK
	urBsCBxw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tLibM-000000000au-2GFH;
	Thu, 12 Dec 2024 13:47:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 0/3] tests: Fix cidr.sh, keep running despite errors
Date: Thu, 12 Dec 2024 13:47:30 +0100
Message-ID: <20241212124733.14407-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first two fix cidr.sh for testing a RHEL machine's host binary. The
last one is unrelated but convenient when testing systems which
expectedly fail some tests.

Phil Sutter (3):
  tests: cidr.sh: Respect IPSET_BIN env var
  tests: cidr.sh: Fix for quirks in RHEL's ipcalc
  tests: runtest.sh: Keep running, print summary of failed tests

 tests/cidr.sh    |  5 +++--
 tests/runtest.sh | 12 +++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

-- 
2.47.0

