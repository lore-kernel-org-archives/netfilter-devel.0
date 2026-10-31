Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793447356;
	b=e2vJNrzB1vwtwjsP3P5TYc/+3DnseJ4yWsKQzZnF5U5NxFW4ZK4rBRfFNectLq32P4w+
	 CSDIU7cZYlSbw/3D8tiz1QMAiSz9WJC+Hzfkk6fVl9ea6UQFMiSqtygRsnMlaEay4D/qt
	 FocxufpcQhc9APSNNGbgqP3gcskVUrIkbGLEckAWodMdT3dYaUd5afvcSo8WwhLkULwh1
	 eIUQuCzOOP+AkHrPobyPqbjK6bi92h82Yd6Uy7Fyx4/lGu38bRB+rfcbJo0p9pptvNubz
	 t1gSJ9SZD+dozoAmskLKQSyqLMq6YKla66wR0JLJVO++BHid+siwusP5MCITKKL1V6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793447356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=mANONhhdZKoBtgoMUercS/GoISV+5AaavOMokQDJz1GPBCB/WjvaCXo0vWvFdcjyHlGa
	 ug6faPTAqI2Ar7mLKMF4UdH8nMwM0UtHalU7ycZN7+uOnNgsiZ6KCqqo2h/Pe/H0IOFOg
	 t1v4kS70K8wmX1u8E2nfdOIDhF4bTp8NpZbGnAvrZGLwRT7bnUraQJPXC5nO5tN01Dtkt
	 x4ubz0tLT1kJ5wOfNMzACtFAGMf+uAIAeKqd4ZpfeJQkgovNsJYjMm9FwprowgGWw21dn
	 8taa6+Piq46rYrzPzGgJFAdAyAUaS3CE/52G6nBDyteWSY/DXdy1+5f6/OFUcjMIfUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GU/cbaEo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD9C606A31A;
	Sat, 31 Oct 2026 11:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GU/cbaEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75ED61F000C1;
	Sat, 31 Oct 2026 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793447355;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GU/cbaEoA/AMRS9U8oKLMXHMzqGQweVw2RqzwdNol+LUqjVOPQAqkxOsvaAKkkAw2
	 0yEjug9lWiGzG4ymPYOmJtpkAaRFP6TdIT5baeME6z0FMCRI1WY9wEfUN2fPjTyvh8
	 BV/qA7enmciwrETf/8tnYvpXrXm66Jh4XbVlu70KVhh6I//7e0HRgWP30l+1kNGZs2
	 2x/bzNkkwPsX375G671ySQF43qKH9drgWfhS9EOr8PaXX2yLcCCxvxlVSuhVwB1jgu
	 HgISSkPITLmO/MtuIPfXpHsNj5PLEaQgzt//iDkQeBzNaZu+eLJ3IvGRE3rsVm2ahC
	 bGNCP1RZFgmOQ==
From: netdev-bot+sinfo@kernel.org
To: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: cthelper: report absent filtered deletes
Date: Sat, 31 Oct 2026 11:49:15 +0000
Message-ID: <179344735502.3286.1270571604287311699@kernel.org>
In-Reply-To: <20261031114436.31788-1-pocj8ur4in@gmail.com>
References: <20261031114436.31788-1-pocj8ur4in@gmail.com>
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
