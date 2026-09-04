Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577263D7D77;
	Fri,  4 Sep 2026 16:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538398; cv=none; b=JkiA+bBe3xqtMT57wCvVdXFaqnnhXPcZ9aFLWdUipwStXf6AEeM2dbIoufBOo3b9eKaX8j505dTWDll7BLinzqPfJUEaU3QrvcJE89wmJOyLSeJn4yl06VfBnxsHbot4RFjL+u4yIzQLg95L5sRr3iTU5oEJZv6VlXg6oo6bN4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538398; c=relaxed/simple;
	bh=ORW0jeXF7DivaNyp85fhot+P8digT8+Mnkpp7M81Vj4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kyzLg9jtLBK4eQslu6ZzX9l5Iv8W8Csl8cf3twANZDRmd8+uzYBQ/PoGcjiVJ5rxoNYRmtgOaAPP2hN3U3XdZdlykiT5gXPkOcOAr515xMPM35QVf2siIH5l11vCPpkiEcysQXeR+I0GI330VCHTbMXbwPZu9dYxxs2Xt3RBnU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fioImzMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fioImzMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC331F00A3D;
	Fri,  4 Sep 2026 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538397;
	bh=Saa7M/Fy4UdAFhW71iWxRHBrw+6UzNQHW18GjlQQlsA=;
	h=From:Subject:Date:To:Cc;
	b=fioImzMRmgwhrIhomSuvPRx/j3rchsPCR0gxuolX7tZPaVhvR5d5r0TsPhnZ562Lg
	 90Ot6mIj4u6tWuoxcV0OORBVQQ2Yg46EGDsdg0N+SKFWxfnqm/RC1/HcaTpHEHFeal
	 3+XQpAvR6sjcC9i6vIHaMG4M9IOj1Bjd48HHj+uknFGeffs/4vfquIIK40PrYcDfUG
	 iHgl+Ah8X1e+8PSio6TkMNip0f948Bt12XiJzVUF9Ary7ZH0u6+j522G85fTfMY1+H
	 VVx8UsRofLK5AO16AtWtdu/3nHTKF0kaVU39iNrQPSRcpJ1VNgngmps1evcjk8Wx2H
	 NM/mrHWxQnQVA==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH net 0/2] selftests: net: use KHDR_INCLUDES in CFLAGS
Date: Fri, 04 Sep 2026 18:13:01 +0200
Message-Id: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QrCMAwAf2Xk2UA7R4f+ioh0bbpFJUrTiTD27
 9bt8Q7uFlDKTArnZoFMH1Z+SQV7aCBMXkZCjpWhNa0zJ9OhUEFNBSXhY4r5xhKecyRF03vvBmd
 td4xQ83emxN9tfYFawXWXOg93CuU/hXX9ASF6y9aBAAAA
X-Change-ID: 20260904-net-sft-nf-khdr_includes-07aa6b61143d
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>
Cc: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1547; i=matttbe@kernel.org;
 h=from:subject:message-id; bh=ORW0jeXF7DivaNyp85fhot+P8digT8+Mnkpp7M81Vj4=;
 b=owGbwMvMwCVWo/Th0Gd3rumMp9WSGLJmvZMQMks8ecXzbnVXaWL75APmLqtfHRPMZVZZI7Glc
 fLj1FeyHaUsDGJcDLJiiizSbZH5M59X8ZZ4+VnAzGFlAhnCwMUpABN5nsjw33fF0ccnt025d+Xx
 9OI/H3xlH69d43TvdpahkkPNxLdBE24yMrT9d/JrXetjsPQzz5Ubhc+ETeabdxYWHtrnLRjxn33
 OKTYA
X-Developer-Key: i=matttbe@kernel.org; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073

KHDR_INCLUDES is typically used to include headers from the kernel
source directory instead of only relying on the ones from the host: they
can be missing or outdated. See the issue reported in [1] where users
have to set USERCFLAGS instead, which shouldn't be needed.

The kselftest doc [2] recommends assigning KHDR_INCLUDES to CFLAGS in a
target Makefile. lib.mk will set KHDR_INCLUDES to "-isystem
$(top_srcdir)/usr/include" if the user didn't set it, e.g. if the kernel
was built in a different build directory.

Other net targets have KHDR_INCLUDES added to their CFLAGS.

Link: https://lore.kernel.org/275ba183-49fd-45b1-881d-0f362b4c74c0@ovn.org [1]
Link: https://docs.kernel.org/dev-tools/kselftest.html#contributing-new-tests-details [2]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
Note: this series is targeting net to help CI and devs validating Linus
tree or the stable ones. These are not critical fixes for the kernel,
but still useful for the tests. If preferred, the series can be applied
on net-next.

---
Matthieu Baerts (NGI0) (2):
      selftests: netfilter: use KHDR_INCLUDES in CFLAGS
      selftests: forwarding: use KHDR_INCLUDES in CFLAGS

 tools/testing/selftests/net/forwarding/Makefile | 2 ++
 tools/testing/selftests/net/netfilter/Makefile  | 2 ++
 2 files changed, 4 insertions(+)
---
base-commit: 641d03105cc0d2437e32fdeec164f91a4ccef6c4
change-id: 20260904-net-sft-nf-khdr_includes-07aa6b61143d

Best regards,
--  
Matthieu Baerts (NGI0) <matttbe@kernel.org>

