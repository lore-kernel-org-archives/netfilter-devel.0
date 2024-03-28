Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983F21C32;
	Thu, 28 Mar 2024 03:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595945; cv=none; b=ow3vx/k7mmHpnAWQmUvrZcstEDo/yLZx7kCBV8jXoGt1XoXoiW5G2gMawgYBJWapdgNR30bgOkX6LJDryqC2iL3SHCoh0WUjF1tQXSG4B+FcJOnvTiOJh8ZGAX8y/KC28SeJXaAn6wKDjnVu9XgGKONfXbM0sJhrcYbHlX4gpwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595945; c=relaxed/simple;
	bh=QTz251rznx9aHr2gZYWcSir2TY09oHDh0f9vKk71Ra8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZAui4PI5h9qxavSb1RNrmH1T6yza5ZGy/YP0uEchOLNHXF9BXKIrmedvb07CUVQ4gsxCilFnf1zA25pCnFZ13LrkLFHO/62VY2mf6MK8AeZsnI+z/0k1S9A7XUHoapvP39hUWtJK2ZSeRhiGF3CerValYqavDcYoEFhPOVtUq7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/4] Netfilter fixes for net
Date: Thu, 28 Mar 2024 04:18:51 +0100
Message-Id: <20240328031855.2063-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

Patch #1 reject destroy chain command to delete device hooks in netdev
         family, hence, only delchain commands are allowed.

Patch #2 reject table flag update interference with netdev basechain
	 hook updates, this can leave hooks in inconsistent
	 registration/unregistration state.

Patch #3 do not unregister netdev basechain hooks if table is dormant.
	 Otherwise, splat with double unregistration is possible.

Patch #4 fixes Kconfig to allow to restore IP_NF_ARPTABLES,
	 from Kuniyuki Iwashima.

There are a more fixes still in progress on my side that need more work.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-03-28

Thanks.

----------------------------------------------------------------

The following changes since commit d24b03535e5eb82e025219c2f632b485409c898f:

  nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet (2024-03-22 09:41:39 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-03-28

for you to fetch changes up to 15fba562f7a9f04322b8bfc8f392e04bb93d81be:

  netfilter: arptables: Select NETFILTER_FAMILY_ARP when building arp_tables.c (2024-03-28 03:54:02 +0100)

----------------------------------------------------------------
netfilter pull request 24-03-28

----------------------------------------------------------------
Kuniyuki Iwashima (1):
      netfilter: arptables: Select NETFILTER_FAMILY_ARP when building arp_tables.c

Pablo Neira Ayuso (3):
      netfilter: nf_tables: reject destroy command to remove basechain hooks
      netfilter: nf_tables: reject table flag and netdev basechain updates
      netfilter: nf_tables: skip netdev hook unregistration if table is dormant

 net/ipv4/netfilter/Kconfig    |  1 +
 net/netfilter/nf_tables_api.c | 50 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 8 deletions(-)
