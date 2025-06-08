Received: from mx01.frank.fyi (mx01.frank.fyi [5.189.178.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBB71372;
	Sun,  8 Jun 2025 20:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.189.178.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749415461; cv=none; b=DK8NRa+yglL6syPeKXWkvQBfTrd+H3vRdeMIYiz/gC/CfwadlYZpLaO6vcDCQlJ8rbUN4/JulcDOsdBB1Zv0kK9pKOYG0Or3NxOKIses+ALziKZoyYT+KmlQcVFPuxTWfoiy3DFjjtQvqUYCF5oHMLykU1/8AIgo1ZSReP8zWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749415461; c=relaxed/simple;
	bh=shxjksDekB8ChinFGMsEVfVoFkMhQF9M0d+6h9vW450=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jRpX0flchBfHaB+nESpSX2jOf2H26Yc2cnYNuQORqRBWTHXjcXkt+OvgJ7u6F5Tonkz+f+bms/j7AQcp1elvSaQpOOv3jdjJpp6W1oHFWuJrBooWF1tzYnZc6SzZ9DKv9OblfTOIzon/VHRy0/tFbjGa6C1LiHUWnr/ZaCWZ8MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=frank.fyi; spf=pass smtp.mailfrom=frank.fyi; dkim=pass (2048-bit key) header.d=frank.fyi header.i=@frank.fyi header.b=AIA2GyFm; arc=none smtp.client-ip=5.189.178.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=frank.fyi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=frank.fyi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=frank.fyi header.i=@frank.fyi header.b="AIA2GyFm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=frank.fyi; s=mail;
	t=1749415030; bh=shxjksDekB8ChinFGMsEVfVoFkMhQF9M0d+6h9vW450=;
	h=Date:From:To:Cc:Subject:From;
	b=AIA2GyFm68JMqnwos+ZsW5kep2fHYIvP4SK0x3ruQ4o9E0Kl3nzY6ej7PdjMEKu3i
	 C/IwYjnWZ4KyWYtqrAGUjULJsEzIUAv6x4RkmmLL1ntBqz+T28ZvDLcafO3bL37q4J
	 isMwXZYPzEh0/l1wL/wiRxQ7miMJ/J/D1rKOF/cTTTsiGuUjFP7SxigLwAx+Nz2Yn8
	 cChdhXSm5hrh6giYG6clohG2IHErUSRse4VMSEAkwto2fZbLfRhMadG4ZcK6/A4/Js
	 omkIZyfvOzGkNBog5l38SViXdExAkW2qnxzZLfE1NimYWWC5Bwpu573hlF06HpKw96
	 kbdxwMUX86UDQ==
Received: by mx01.frank.fyi (Postfix, from userid 1001)
	id B012411201F2; Sun, 08 Jun 2025 22:37:10 +0200 (CEST)
Date: Sun, 8 Jun 2025 20:37:10 +0000
From: Klaus Frank <vger.kernel.org@frank.fyi>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, netfilter@vger.kernel.org, 
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>, netdev@vger.kernel.org
Subject: Status of native NAT64/NAT46 in Netfilter?
Message-ID: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've been looking through the mailling list archives and couldn't find a clear anser.
So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?

All I was able to find so far:
* scanner patches related to "IPv4-Mapped IPv6" and "IPv4-compat IPv6"
* multiple people asking about this without replies
* "this is useful with DNS64/NAT64 networks for example" from 2023 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b308feb4fd2d1c06919445c65c8fbf8e9fd1781
* "in the future: in-kernel NAT64/NAT46 (Pablo)" from 2021 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=42df6e1d221dddc0f2acf2be37e68d553ad65f96
* "This hook is also useful for NAT46/NAT64, tunneling and filtering of
locally generated af_packet traffic such as dhclient." from 2020 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8537f78647c072bdb1a5dbe32e1c7e5b13ff1258

It kinda looks like native NAT64/NAT46 was planned at some point in time but it just become quite silent afterwards.

Was there some technical limitation/blocker or some consensus to not move forward with it?

I'm kinda looking forward to such a feature and therefore would really like to know more about the current state of things.

Sincerely,
Klaus Frank

