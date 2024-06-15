Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9ED817555
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Jun 2024 09:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718443120; cv=none; b=KYb1OcS9sFrrWk20sSa77gLLiRMs1+KIOAXpEcWEbDbLiZUfBS//5sClJIGlaywClEU6mQvmRSCJD0FeSoABkcbsTw/9O62FNaIUG94lUiWCr+REBC/r1Vvp4zvpsQpT1EFtPKFz6XY+AU4SnEc7XicWU+/lRJQ2owfq0LLvM4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718443120; c=relaxed/simple;
	bh=VRUGbGgb08b+8zqWGJdxe5MJssws3crueCgdVpx1Hx4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type; b=WJ5cQ2H2zl+2YufvjbKPxJtagSDHyHLGfCRQx8rNBqblPmDVTmbCihkzb6WMQV9/00+EN9TeKc2P7lpoKpzrDzgjWhypKJQ+uArUmDbL8myYKEzpqwvL6OTbCYukzGS2A2n9ratEI+RNFYigN9z6x2jTNyTeo0OF24sDfwWBNp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/2] nft include path updates
Date: Sat, 15 Jun 2024 11:18:23 +0200
Message-Id: <20240615091825.152372-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This patchset updates include path logic of nftables:

Patch #1 adds -f/--filename base directory as implicit include path,
         so users do not need to add a redundant -I/--includepath
         such as:

  # nft -I /path/to/files -f /path/to/files/ruleset.nft

Patch #2 searches for default include path last so users have a way
         to override the default include path either via -I/--includepath
         or the implicit include path added by Patch #1

  For instance, assuming you have:

  # cat /path/to/files/ruleset.nft
    include "file1.nft"
    include "file2.nft"
  # ls /path/to/files/
    file1.nft file2.nft

  then, make a copy of the ruleset:

  # mkdir update
  # cp -r /path/to/files/* update
  # vim update/file1.nft
  ...
      file edit goes here
  ...
  # nft -f copy/ruleset.nft

Comments welcome, thanks.

Pablo Neira Ayuso (2):
  libnftables: add base directory of -f/--filename to include path
  libnftables: search for default include path last

 doc/nft.txt       |  2 ++
 src/libnftables.c | 19 +++++++++++++-
 src/scanner.l     | 63 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 23 deletions(-)

--
2.30.2

