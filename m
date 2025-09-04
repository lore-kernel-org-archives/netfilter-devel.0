Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0DD22F74F
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999506; cv=none; b=MXaHxO4Io/qsOGN2xnCEU22lcZjHSAfXAyGuft+QeR5gurPViEnEYDZSIwSEC9N1TD4vC1Dm6pM5rQkV0/RBHuRhRpgZucad5f0BN5EDDwz2V3Gbxx7DO99dl8eWiVT/B/VTWpRGyQ+x8DqCx9z0efDM3qj9STfj/3Wpw4+xlpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999506; c=relaxed/simple;
	bh=/BlupDn577YOplpdvnQsPqHtcr+P+6bWvvWNh2wFAAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avaOFVleXsRjmp10XKDasbWsDhbkG3dM96DtWXlPzPXfdrv9TLfnqMI9uMNXS6XyDbEC/ENXuswHKVNY4lmXZPhx91g4ELbuLRK3ocvl37dkX39vOJN/1oTSxz6wwrvdZWfFDVE8fDSYuxSFLIudK6wIpldX8nxrvRdls5HgXU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=a8gygNKx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="a8gygNKx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yOxpeyc2ljMUbd5pt3BRY5Rxkw+5IFxp/QonasRFywg=; b=a8gygNKxfnW7LRUPY0RYq0LJnM
	sMGc+JxoHgLn2hJYUcf4UfmKIeXPHxT4rH+up4YUqcXNs9FLMALTbrFyWFnXYgNWuMhaoVsz7HXMx
	uQIK+ZSFVVQfsM7IgLuGLPqMEqf0neyhreOs3DSM4Pjsf+1Lw1g8/QdLksX4dHflL+E9Zy3AmdwYk
	yRdl+bTvGMlRvjYyPp3eJeZw/aiF8tQ8pZwE4w8e4smPVTIYndwRlDnImHNPFx7VmrovDaTosFRnO
	X+oZdYQfztkwNhM1PD1h0thpuGAcq+0Mbw1B9z/rcexsR0nodyd+h8bHzkYfKyiodKn66TVe0b+p1
	HzNGGwzw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBpf-000000001pO-2ECX;
	Thu, 04 Sep 2025 17:25:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 7/8] tests: build: Avoid a recursive 'make check' run
Date: Thu,  4 Sep 2025 17:24:53 +0200
Message-ID: <20250904152454.13054-8-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250904152454.13054-1-phil@nwl.cc>
References: <20250904152454.13054-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When called by 'make check', the test suite runs with a MAKEFLAGS
variable in environment which defines TEST_LOGS variable with the test
suites' corresponding logs as value. This in turn causes the called
'make distcheck' to run test suites although it is not supposed to.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/build/run-tests.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index a5e026a97dd5b..80fa10168d003 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -20,6 +20,10 @@ fi
 git clone "$dir" "$tmpdir" &>>"$log_file"
 cd "$tmpdir" || exit
 
+# do not leak data from a calling 'make check' run into the new build otherwise
+# this will defeat the test suite invocation prevention for 'make distcheck'
+unset MAKEFLAGS
+
 if ! autoreconf -fi &>>"$log_file" ; then
 	echo "Something went wrong. Check the log '${log_file}' for details."
 	exit 1
-- 
2.51.0

