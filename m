Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D7B27A116
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716980; cv=none; b=mPQt8bxJgawo5Ntv/MO3I2ahULmy3l4a6f0T2HZ3Bxgc0B0QNzsVV+IyCW7W7JUj4XGCXPhjK6TlTIHxep2tLLEXRprlHLkPV2rdA6uUF4IMwRXZyX4mmBQNLYHYVzI5cN1l4zdeozpYG+E/XQzxHep/EynUB+EIalfWO96gi9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716980; c=relaxed/simple;
	bh=Da25KU7/KQzsLncLVT+jIeWEjcLP04QAW0xvzKdyBEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K9PB5RsYuVJLYPjZ5pc88f6SzRKnUom3I6GpQ1PprHpA7elQvFbJSG4aKQYsn51kVoUo8lOMvq+aABOrlZwuxaP7OYsKUlXmTYbE2tMqtlFOd9oB0N8IB/LFYuuuUHlnSvjflC/TNTYx4lJceM3VstfgtffzZ88Blr0j5ylUE80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uD2sS-0004uD-8E; Thu, 08 May 2025 17:09:36 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: nf_tables: include conntrack state in trace messages
Date: Thu,  8 May 2025 17:08:50 +0200
Message-ID: <20250508150855.6902-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the minimal relevant info needed for userspace ("nftables monitor
trace") to provide the conntrack view of the packet:

- state (new, related, established)
- direction (original, reply)
- status (e.g., if connection is subject to dnat)
- id (allows to query ctnetlink for remaining conntrack state info)

Example:
trace id a62 inet filter PRE_RAW packet: iif "enp0s3" ether [..]
  [..]
trace id a62 inet filter PRE_MANGLE conntrack: ct direction original ct state new ct id 32
trace id a62 inet filter PRE_MANGLE packet: [..]
 [..]
trace id a62 inet filter IN conntrack: ct direction original ct state new ct status dnat-done ct id 32
 [..]

First patch is a needed prerequisite to avoid a module dependency.
Second patch adds the needed info.

Patches for libnftnl and nftables will follow shortly.
