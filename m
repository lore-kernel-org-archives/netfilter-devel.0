Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794493337;
	b=c9xYcRJzOMb3uqCzbByTdTWMg7Sk11om40m7OLmfPv2FT8W1vhMSib31zMoni2Lvj9Pa
	 geHyyaYIluAY0iiZ9vCUFPo3SrfzGk7Sk/Y/OmlvhhLy2gqDh1BEVOnTBlwRvCJKR5QW6
	 wu2lXpcHEqGihUPtvu3G4SUVhtFpTkXifzfcJXCNXjg7D90lBFHp5/DsIosBwxgORUfIC
	 ofTQgv3jX2Nwle3fsJtBK35SbI8fMzDpubPTUe0dgCX3OSsY0kmEteOC/qF7tmL/eMnId
	 UGyVmLgpVDGiaOZVkbQlg+feZ3B3nzswdLwBOy7O6H4Iy4kD+LBNI5mLZAkrS4eSC9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794493337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=BkSPY913MJp/2Pv8HdYqo1+VmEGuIw+PxFw6iF9wtX7YfHrm5eCVGTO9wP7RGOpOFAKx
	 Z6V5QMiuQPcFJjrcHFb+ctFi4cPSqv8X+n6yyWEkRhSooB+tzFrYZL/HBzi+Vv8m1icxZ
	 XA43yCnL2CvG4NoYN1Zxvj/ZbuFdtQS3hditzne/xCty82bqcaMVcfhEPzS+oL3pPe8uA
	 64ZJ0ldBcNCUaMLQ6yIPu2p75RcAbsBiwmP0gc913aIyf7a6ewzNRiJ/0J64LfN0bpCxz
	 Ai8IZyUFhGx8nTbs1Zep3/N9I7VwAxv5mMaTZxmg2Whq0KIf4DNPKDWTaA0LTZLtiBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5UfUSFX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F58606D56F;
	Thu, 12 Nov 2026 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V5UfUSFX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1499C1F00A07;
	Thu, 12 Nov 2026 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493337;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5UfUSFXT5h7oegd3qDj9fhErYliR66rL/EMERX9/3xmFgbneDCjHGC/3KID4WF9T
	 9i/VdYjveQtUGbsIehDtx2qg9nJkkwroWPIXkV7qvgGw9xPypAi0dNqpfvCtaerH6d
	 WH6OzLnO9X4SzaJWTJfgENqZmD7ps9PdEVMp1kfTZyM4tjjSVvs7AGqWmQ2sObW9q+
	 I+wx5iusH2w2NLG0hm0Jsao2PYRoA15V1clqQKosbBqiKf7xUR1xSYknkGjlHtnLAq
	 cEJ3Yvd9ocqmq1IWTqpHInZ8SyZ74yJBx6z3KNVOolmki2sb1k0nXRsVLbD51BX7IY
	 6sVYGY1FI3/bQ==
From: netdev-bot+sinfo@kernel.org
To: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nfnetlink_queue: use verdict sender portid
 for expectation events
Date: Thu, 12 Nov 2026 14:22:16 +0000
Message-ID: <179449333655.2168702.2394012834202740473@kernel.org>
In-Reply-To: <179449287223.132952.1536491080157978119.c244-nfqueue@gmail.com>
References: <179449287223.132952.1536491080157978119.c244-nfqueue@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
