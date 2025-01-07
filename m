Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40611F4735;
	Tue,  7 Jan 2025 19:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736277290; cv=none; b=IxLOMeS+LW5nTk8eVF1Id7ylWbr6s/oqJ23WFRorku594n2SCNx6DpsiM8E53VPjRNy6luDy9zGFmhLUUYBaDx5gZ8b2e5zvN6RCiPfdYCY/BPzxayNa/H/YOsfENQZteDthRsIXp1I7A3N2US//5CaGUq0iaxQubZ9TvhYvH6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736277290; c=relaxed/simple;
	bh=Bl6Lt5L/hqIAReIHN2gjN+Raui64aJzXkqiHddEiguU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NZ9EmA0lGy9wsLFzOpFRtNdTOsXO7orAwbe0PRWvA63Byq9RfmzL23YI56p2/BfVOGbcQpI7T6sVXe+HMEHFd+qTJAJfuqL2ZQ0/pBotj900PkfdV4b0tsiOsvisGNAEagz1mWEOx3rwqUyy0UWs7u7nT3YABwHR8VXWoPx+fK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id ED48332E01D1;
	Tue,  7 Jan 2025 20:14:37 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id xeAgBr4RHqfQ; Tue,  7 Jan 2025 20:14:36 +0100 (CET)
Received: from mentat.rmki.kfki.hu (80-95-82-13.pool.digikabel.hu [80.95.82.13])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 5E2FA32E01CD;
	Tue,  7 Jan 2025 20:14:35 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 15AF2142729; Tue,  7 Jan 2025 20:14:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 12D321421D7;
	Tue,  7 Jan 2025 20:14:35 +0100 (CET)
Date: Tue, 7 Jan 2025 20:14:35 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
    kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/10] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
In-Reply-To: <20250107024120.98288-1-egyszeregy@freemail.hu>
Message-ID: <21ca8213-46cc-69b2-4817-d8a2c041baef@netfilter.org>
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-55138303-1736277275=:220661"
X-deepspam: ham 0%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-55138303-1736277275=:220661
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:

> From: Benjamin Sz=C5=91ke <egyszeregy@freemail.hu>
>=20
> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
> same upper and lowercase name format.
>=20
> Display information about deprecated xt_*.h, ipt_*.h files
> at compile time. Recommended to use header files with
> lowercase name format in the future.

Much better, thanks indeed! I'm going to comment just the patches where I=
=20
think some improvements are possible in order to focus on those.

Best regards,
Jozsef
--8323329-55138303-1736277275=:220661--
