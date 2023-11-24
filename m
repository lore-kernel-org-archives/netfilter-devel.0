Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IFPbB30z"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30293D5A
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zpTH2c3Uh3DIEe6RrWuL8l2SQ7LuPJhyK8glAURbV9w=; b=IFPbB30zIpDNWEN+5it5T247DQ
	0gsKTrH5HWVQ8666VJvD/3dnF/EkUGyiqXNiy3SQyTMw5YyBTdPFfhLUDGwZ9Ai/os1NouqMVRytk
	Trq11c1kTfFonR+7SIBLjw5Pe9gcpxOnIDf5Va8XyJYywbZxesfHF0l8s14BrFjJQ2yxlTf38ZAZo
	bDLxWQ3ETXjeYuHUw8fijuxnwTrjNbRYrfBRnhgOmyGCrI+LUgiySAqnFcZ5Dd2Yi7f4LcbZe9x73
	9bWAwMAcVJWFPIIaIILpJg6QEGhZgc7lsTHUIeqqCz04KolltTVca57/f17TaJ067r+awyfrWuCIW
	R60tcxiw==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6UDT-0002UM-Ko
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:19:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/3] Review interface parsing and printing
Date: Fri, 24 Nov 2023 12:28:31 +0100
Message-ID: <20231124112834.5363-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Take advantage of the fact that interface name masks are needed only
when submitting a legacy rule to the kernel. Drop all the code dealing
with them and instead introduce a function to call from legacy variants
if needed.

Phil Sutter (3):
  xshared: Entirely ignore interface masks when saving rules
  xshared: Do not populate interface masks per default
  nft: Leave interface masks alone when parsing from kernel

 iptables/ip6tables.c            |  6 ++-
 iptables/iptables.c             |  6 ++-
 iptables/nft-ipv4.c             |  3 +-
 iptables/nft-ipv6.c             |  3 +-
 iptables/nft-ruleparse-arp.c    |  5 +-
 iptables/nft-ruleparse-bridge.c |  3 +-
 iptables/nft-ruleparse-ipv4.c   |  5 +-
 iptables/nft-ruleparse-ipv6.c   |  3 +-
 iptables/nft-ruleparse.c        | 33 ++++---------
 iptables/nft-ruleparse.h        |  3 +-
 iptables/xshared.c              | 83 ++++++++++++++++++---------------
 iptables/xshared.h              |  8 ++--
 12 files changed, 76 insertions(+), 85 deletions(-)

-- 
2.41.0

