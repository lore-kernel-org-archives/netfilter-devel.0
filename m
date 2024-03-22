Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE4E5FBB2
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711122550; cv=none; b=ADVXj1xtw2cofER0XzxaWGfGLd+GiHtW5/tXdyoKcvtWYE/TeLPWmd91qi5Zm4RuTS8WPNKQqaQshsaiQD5N/olUKcQARXC4cdc0SKigwPTGrpKBG+6kIwcIq20OohznMJg5Q5huVv9UVEHAziCLEtGbAU4xo+x7acxN31HEgTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711122550; c=relaxed/simple;
	bh=PDnfy5iSmzoSVzJL9RK8Hv8Iwu6ULMXdGVOo7H1ekgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hiOhxaPCtyYkOviLndxub084qhLP8xLk0u10nrMdCtpyNpvz46YCApSBprHijKCeNOGd6AnfIRWJ8FNLvEdCu0erC7+zvlDvk4DyVwtPAZjATPHrBtU6DYwmNEGXx4RwEDY8ZO8RvvQGALJclopNhqGVqOBVMEmPWasPzzYqZvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Qk97Rpir; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Qk97Rpir"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=27cZ9enhPfd2AQTgg4FnHVw7Ypjhql+HWU/gh1kmrlY=; b=Qk97Rpirb/7Q66TfiGH2j5R8p0
	LaWgUVfplGcsif0N3W6H1jHJhOZS67rNZq5LYeBWN9NPkwu7dOymniv+4MI6EPXBYjxtMpoTZSetG
	siov48Rih6QZvET0+emLv/asc+xLlnf+6S5uuQ49x95RzWUJ+KOet3T0yziHV2WFSkJV2yXCRrSef
	z4vrGjXzWL7ByPzyw9byKujkpJeIWeHWHG1O7prAEt0YIM3Lh5uWp8++UJG2WXpEcwAhDX3VOAg1v
	TPOZ2ulLhKjvNn/4vFFbOSSOmQ19EhpIAic+0AWRYnWzqIvq4PCSSb+zTgUWc9gQ10iFg9I9UNckr
	lv/K/8lw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnh8e-000000000no-359r;
	Fri, 22 Mar 2024 16:49:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/2] Add support for table's persist flag
Date: Fri, 22 Mar 2024 16:48:53 +0100
Message-ID: <20240322154855.13857-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support for kernel commit da5141bbe0c2 ("netfilter: nf_tables: Introduce
NFT_TABLE_F_PERSIST") in user space.

Patch 1 is not a dependency, but trivial enough to go along with the
second one.

Phil Sutter (2):
  doc: nft.8: Two minor synopsis fixups
  Add support for table's persist flag

 doc/libnftables-json.adoc                   | 11 +++-
 doc/nft.txt                                 | 13 +++-
 include/rule.h                              |  3 +-
 src/parser_bison.y                          | 42 +++++++++----
 src/parser_json.c                           | 68 ++++++++++++++++++++-
 src/rule.c                                  |  1 +
 tests/shell/features/table_flag_persist.nft |  3 +
 tests/shell/testcases/owner/0002-persist    | 36 +++++++++++
 8 files changed, 158 insertions(+), 19 deletions(-)
 create mode 100644 tests/shell/features/table_flag_persist.nft
 create mode 100755 tests/shell/testcases/owner/0002-persist

-- 
2.43.0

