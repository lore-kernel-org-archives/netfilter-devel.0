Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793862207;
	b=nVNQYbYbqe/iDsLTn8zb9sE7CuVien7T/x0ZL5h9SfUD6/MDmCzek+Fzwqi4E02MEY9S
	 CWdaXLRz6WajqfDqiD+CLbDlGA1QLuaKJGekmgS9Wba4xdxHuxN/snm/NcP0bk+v2fX6n
	 +S77zrYyAjGXlaibFiPidkPpA0IqGx0MgJt+Jlyc/z2S7DQvPfqMbhTEU0BGo50z0TlDX
	 CTW83++9WV1oys6uUAoKLXKJ0YVIKaBlPjkoB1J4JB3mwFXRtNjxjDOruQ5pCy3QN2C+Z
	 jXmgzN8NSgDKpbLHc3ZjsMXfn7GcAg9YXZpuivQOKcvyJnurYd6skSJkjbNWtdx2aAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793862207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=H9npzdh5j2yeI2tYxNqPA+Ts5joV+rRU0ZcWosngAaYbXDioS0bwo25F9fcwBC4PefyS
	 Q6vE5ZZOL6OX/tfZsUdfNG7a4aML3fL7dFyvjEHiVZPwIY53G5ImQvxSFgw3bF3CphL6k
	 xak4fL2xDRKzkhhkk+pZ2M0ivbUYzaoGk2/1bGkqxN+s0ac+TjvjRDQg8mQJx2RzNO3Ii
	 VCVWH28TIDook6AcTg4rPusDEaXYKVC/kSUlMeHcKbs9m1FYA9311wk29M1aG/3diqk4f
	 y7I2H1zIfmjqCVk1EKvG1QYtoZsMHZUyneU6V7KNQzjOtJxDp3of1Zz+hjmzUt8sayA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzTGrmi9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5522F606A326;
	Thu,  5 Nov 2026 07:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzTGrmi9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA961F000C1;
	Thu,  5 Nov 2026 07:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793862206;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzTGrmi9xfsJumawMXwsx5Sm0b3u3LyMFsY/ejO7spi4+LnmiO4Di+HtGY8nYYaUm
	 Aqomukvj4KaH3aZiEG5cT2ngBz5Vf0CxNWkBbDUxXnpIIxUmLGgJfyziyM8B6F8Rx7
	 0z/ar7lcnMlELn1l90bnt0nkl0VlRSpLa5YbjdlUnQbwNhdH9/EHJLhEag8G7h6Z4y
	 JZ0z1A+rndT3ZfhYZIDRRq0DlTVN15ljANTbugvJ00C+Xy/DdySWjPpAQx0w3B00Qr
	 iU1sN9wIBPegZhfArstXcLF977sengRkfibdcYwBxHqO8NAUaXMAO6Dot6XOJR6iVS
	 9HpG/+RQfyYgg==
From: netdev-bot+sinfo@kernel.org
To: Qihang <q.h.hack.winter@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, vladbu@nvidia.com,
 ozsh@nvidia.com, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table: defer pernet stats release
 to last flowtable teardown
Date: Thu, 05 Nov 2026 07:03:25 +0000
Message-ID: <179386220573.488859.7780877584306117605@kernel.org>
In-Reply-To: <20261105065509.94627-1-q.h.hack.winter@gmail.com>
References: <20261105065509.94627-1-q.h.hack.winter@gmail.com>
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
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
