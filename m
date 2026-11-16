Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868721;
	b=B5IQsAOJE95Tzi7EyMDRdPcAFrHhFpJInB+arei231imHEKXJ50p7q7nmsdwL1gEL7OI
	 LGGduXvl8AaXSh6XpAm69DvaSLVuD8blgVoQWiO609epeK1lY2szId1g/vNJSqKwb+ZXV
	 MtxrNnG1i/8ssxxDgEQUP9E4/FnJzNMS3ajp8lzJXhRKgfmmeIqs96k+0hCkUUznj8Obx
	 e2RR9GCS9mHZh43KBxJ3JgJU8oGIMaIZX523Mq5HRmC81hDQeQPWW73xZQsXQb5bPHQ1I
	 PkpwQGQ2hqvKoUAnQ01ATZCF/JgxBYlE3LzIms/y7wNc4mljOgMVddQiTq88u/WVlaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=I4ZopmN8SuoHsV+/NqxZqcA01Y2gAlwDCrX6ifSHGp1HecwClvDVFJYIZ8KtWbT9VhTU
	 V41gXsjlGnUp1oZPz+8ypKg83fFK+oRBAAwSg8f8ROn8J8txTRlJUL7yEfwzIbbhvbf9a
	 0o/eqHC4Y1Z4Kt6j7rQtnuwpkMxqZQMIG5qBdaayKAk5YQcyDtqoVC2ODWMQFIGedOOyJ
	 JdPU1glA9JLM46ziDEe/6T3/GDau82IWoDNC7g805BCm4JCkoitUS0QrJy++GdogHCBYG
	 ARGv54zStJCjlwjUfzxIkf7SST6AKYUDcPFPYahuIVEqMeCs0y/qLj/dC+3SPMn6qwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GNWnV1PG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CAC606A33F;
	Mon, 16 Nov 2026 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GNWnV1PG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1220E1F000C4;
	Mon, 16 Nov 2026 22:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794868721;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNWnV1PGjcdzbOacpLmztFsnh+FnLqTXz3XeEyYVY1H+flnCxBj4CEvNW9dghQFab
	 o+9W7kECCLqEEwDJOZ7TTsGOQBQPzbC9TzW/VQrNBsyX/gcLqGXJ7EUAiaY1ZfJKvv
	 F1509QwEhs8jZgijHYgU8b9iDBlIMpbR2ZHClbueQBferEVBBT44f/XwF9ZhMQS36c
	 faJEZErVCSTsIns6KwYi33I6e/w8ait8RtR5dNDfEC/WMZSCL1B4V3q1p5Lr2V9azY
	 vCfQ/zglr3D+qR35fHwFdBqWtxux1NgU5RO5Ft1iZwM3MjbLc19Uq94P87PQPet6No
	 Sw7ieVwtX65QA==
From: netdev-bot+sinfo@kernel.org
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org,
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jonas Gorski <jonas.gorski@gmail.com>, Vladimir Oltean <olteanv@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next 0/9] net: bgmac: add Northstar IPv4 TCP/UDP NAT
 flowtable offload
Date: Mon, 16 Nov 2026 22:38:39 +0000
Message-ID: <179486871961.3291.17535527526102286596@kernel.org>
In-Reply-To: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
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

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
