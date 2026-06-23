Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A251215075
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235298; cv=none; b=bbvUuCfzxgcv/jdq03+UQgLlEMBbsVUceSGVG5eqPlRe2kDgcIM1pXa91QjKkKL94etYiDb9UyxTmpCm6Sa55T5siX2zn6BQ2FxYj7wHNHWULEgdSXBE2vP030R87Iql+E1RA/Z1PBn06FBUIxI5oxuVktd/GGUghqyK/Pxmv6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235298; c=relaxed/simple;
	bh=t0OL12Bc6wP+9J4mksldsMKJMnTjUCvxKOS+rUnfQaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gn+4ebCFibmCkRTKjn6ywLm/C2IX8CFwkE8xZYTrdbrejD/vi029HXrj7yiI5SBqSpVgI62wWAKSLuYJ7dmVneI+05KTuYqsIret0UdlxmEOXu0aaErFdvTISoDVG4e5Kj9QDoJel8nVV6NO44k4uNdnbOo+I7wlF8KFYCxJBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FN/ewL+X; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FN/ewL+X"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D0C2E60193;
	Tue, 23 Jun 2026 19:21:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782235292;
	bh=mjfjbAG+PsC5Lo1ODRjj3ha+bPiXu0aD/d2o0oV51/Y=;
	h=From:To:Cc:Subject:Date:From;
	b=FN/ewL+XQ6e6q5kLMOMwnclgrJOdvBmRI4tKpkHiaKbQ2WcYoGIBZ3FEH7ivlJ45B
	 LIqjVURpyCm2nYASCtvJTH6n4O9OMWQMi7lCtpx+SYPC6VkZsACoS6L2+aM1qMH6jA
	 YO34bsheSFc/EodRVjto4iwIBorAf77J6En3AAgpIOWqW59APtW+7QvhtmJseJ3AEH
	 k5MxzJ70pYfi0top3dPcKrGRVMC71vwboNEwr5rt0VQNb1o+lIUSuQR+c+UBYzrfSJ
	 0WdlChXwzVHmD2Efsejx9gE1PVgWZ+VZisSQ9htTLd8t7huzpl6XQafyxmdHsHaZ42
	 0puyPnj+itAbw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft,v2 0/5] support for several list and reset commands 
Date: Tue, 23 Jun 2026 19:21:23 +0200
Message-ID: <20260623172128.401234-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently, it is not possible to run two reset commands in a batch, eg.

  nft 'reset rules ip x y; add rule ip x y counter'

this fails because the cache logic gets confused with the requirements.

This approach runs each reset command separately, fetching one cache
for each of them.

This series is a follow up to:
 
  https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=499127

to address an issue reported by Phil Sutter.

In this v2, this round simplifies the logic, allowing the combination of
reset commands with list and get commands only by now.

Patch #1 to #3 consolidate common code between nft_run_cmd_from_filename()
and nft_run_cmd_from_buffer().

Patch #4 add cmd_batch_add() and validate compatibility of reset command
with list and get commands.

Patch #5 adds the cmd_batch shim object to collect sublists of commands
to deal with several reset commands.

Pablo Neira Ayuso (5):
  libnftables: add nft_run_cmd_release() helper and use it
  libnftables: split nft_run_cmd_from_buffer() in helper functions
  libnftables: use nft_run_cmds() in nft_run_cmd_from_filename()
  src: allow reset commands in batch with list and get commands only
  libnftables: support for several reset commands

 include/cmd.h      |   9 +++
 src/cmd.c          |  59 ++++++++++++++++++-
 src/libnftables.c  | 144 ++++++++++++++++++++++++++++-----------------
 src/parser_bison.y |  12 +++-
 src/parser_json.c  |   8 +--
 5 files changed, 170 insertions(+), 62 deletions(-)

-- 
2.47.3

