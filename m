Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940339;
	b=fYD/aMO9FSrSSuOXirgeIJVKbRKdk5xVzI4O5JbGYjMVV1tzzDnfkFJREyJ4fq8K3+ff
	 rSANDpDMV5T1oTCaiVJiSOZL8p+DMls5j5xk7IOKrM0C1bNzeVX084WeYGQRp+5vCXmV2
	 kFcXbDV4vC1RJJ22J9dZyn9c0jCjnqMt0nrQFYWD0ifRe0klffE1mYH2DKF1eCWvVotsy
	 LsGJ13zYImqp/kMDW/5P7ApI6111HpDC97z1lcyVNadGyz0fc8VUuo8xYGUW7ArRQRfej
	 mJACjZRJ09n7NWDeISdNQlJt8sToqudRGEQxkX90LxlLP2rAvl0MtJx5jejUP1x03lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940339;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4vaHZLIW0SPZkIRMSxFNq27ulwhfeMcZ9wy5M8gPylg=;
	b=V6IEAaRgYQgfrdhI9MqMBLIng5cU28bLto+b01Nvg27BzO8mPW25rXEoDPlr+mSZoIFG
	 R9yFyVbPt4u5KBv9XjXL3inKJ1BxGVdWxzmHpwe/e9dowWgNwcV6vqHlLj2iGyj1MKWeA
	 8i023e/Md043tstAkZtRuuG4ChX9DW1SuXenX6aq9hZxQ82zx8KYtrlOI1rwD85ZMrEVJ
	 YjSTjWgozNO7iyRuYBDOi0YuUYJC3Lb5O/+jltVXsOlLwQlJVpADZw8AorhG2SMHz9kEr
	 PbF1Tx+Nhm+utEOAfb+3TYZXq+7v38jvasqvh3a8yV/KkPqzQjpHp7HG8ivw9IoWZIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF7606A31B;
	Fri,  6 Nov 2026 04:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13EF7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 439836060B; Fri, 06 Nov 2026 05:45:35 +0100 (CET)
Date: Fri, 6 Nov 2026 05:45:34 +0100
From: Florian Westphal <fw@strlen.de>
To: alireza@asgari.net
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	kunit-dev@googlegroups.com
Subject: Re: [PATCH RFC net 2/3] netfilter: nfnetlink_queue: fix batch
 verdict ordering across large ID gaps
Message-ID: <au1bbkpwnSzzb3l4@strlen.de>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
 <20261106-nfqueue-review-v1-2-b6c933f44943@asgari.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-nfqueue-review-v1-2-b6c933f44943@asgari.net>

Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrote:
> From: Alireza Asgari <alireza@asgari.net>
> 
> Signed 32-bit ID differences do not order packets separated by half an
> ID cycle or more. Queue length does not bound this distance: an old
> packet can remain queued while newer packets receive individual verdicts.
> For IDs [1, 0x80000002], batching through 1 incorrectly selects both.
> For [1, 2, 0x80000003], removing 2 before batching through it also selects
> both remaining packets instead of only 1.

BATCH verdicts require strict in-sequence ordering.
