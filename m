Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA81C6A4;
	Mon, 13 May 2024 18:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715626010; cv=none; b=bRTHrGpArIycx43y34j8lh0/jq+cjhulxPXv+JdsX6pNQKsnPw7Qlxbkf4YxZF9p7TYaJwxIdL+U3kK+h7vlW0ZsxNnSZoQ71qoHccs6Z5NZw6LrmVTtHS5iD7RD0dJhXbsZSD2CtK4Z0DnOujzOnKwKTNC8PVc+GyqixebNJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715626010; c=relaxed/simple;
	bh=JDIRg2qmzi1h/Y7XpCRFX2kK31gZ2skohimiZqp27LI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiNjw4v6UL9DA054GNOkDzOQs/+Mbu9/x7cmQo/4jUxGR/R9l29VFdTtoinE52Vt7K1rbmJx3p5q11UYem2D8fX1WDXYA1vVBQkuncuKYr56Iwn7sLcJJ78H4kcUUbd3ugg83D9vodHbWjm0viDD8NI/+wro4D572k/fwjMc4zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKPPw/+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKPPw/+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E23C113CC;
	Mon, 13 May 2024 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715626010;
	bh=JDIRg2qmzi1h/Y7XpCRFX2kK31gZ2skohimiZqp27LI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UKPPw/+MqfbJysICHEmw4uABDW5P6zrloQP76mEoxaIa4WzlrCwwqi8TSqUyYesXi
	 NJigUW2zEvI351ImGNv2lVqVe/WahxN85/UQQ1dhwO/QoduqD5jSxMuRxLnNsdWgKQ
	 Iv0AWQD04PUTVhjPXt8ZXIomStbeF71bvs/8feOa70a7dqWiQAKplWVDCMGNRFXZZs
	 HJX2T3yStoLIIwbm9PTC7eZXJa2VAi52sEm4c5RNxvxq6IuOgzWFpK+vtZ5vVs8oz0
	 NO58FjD6BLU4in3WT64z6GwWzn7/znXP7gn6fBqid7nXax3x7z1ZtzyjAaq3s96Rdb
	 iUEnD/W9NcLQA==
Date: Mon, 13 May 2024 11:46:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de
Subject: Re: [PATCH net-next 16/17] selftests: netfilter: add packetdrill
 based conntrack tests
Message-ID: <20240513114649.6d764307@kernel.org>
In-Reply-To: <20240512161436.168973-17-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
	<20240512161436.168973-17-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 12 May 2024 18:14:35 +0200 Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Add a new test script that uses packetdrill tool to exercise conntrack
> state machine.

Hi Florian, I installed packetdrill in the morning and the test..
almost.. passes:

make -C tools/testing/selftests TARGETS=net/netfilter TEST_PROGS=nf_conntrrack_packetdrill.sh TEST_GEN_PROGS="" run_tests
make: Entering directory '/home/virtme/testing-15/tools/testing/selftests'
make[1]: Entering directory '/home/virtme/testing-15/tools/testing/selftests/net/netfilter'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/virtme/testing-15/tools/testing/selftests/net/netfilter'
make[1]: Entering directory '/home/virtme/testing-15/tools/testing/selftests/net/netfilter'
TAP version 13
1..1
# timeout set to 1800
# selftests: net/netfilter: nf_conntrack_packetdrill.sh
# Replaying packetdrill test cases:
# packetdrill/conntrack_ack_loss_stall.pkt          (ipv4)                    OK
# packetdrill/conntrack_ack_loss_stall.pkt          (ipv6)                    OK
# packetdrill/conntrack_inexact_rst.pkt             (ipv4)                    OK
# packetdrill/conntrack_inexact_rst.pkt             (ipv6)                    OK
# packetdrill/conntrack_syn_challenge_ack.pkt       (ipv4)                    OK
# packetdrill/conntrack_syn_challenge_ack.pkt       (ipv6)                    OK
# packetdrill/conntrack_synack_old.pkt              (ipv4)                    OK
# packetdrill/conntrack_synack_old.pkt              (ipv6)                    OK
# packetdrill/conntrack_synack_reuse.pkt            (ipv4)                    OK
# packetdrill/conntrack_synack_reuse.pkt            (ipv6)                    packetdrill/conntrack_synack_reuse.pkt:33: error executing `conntrack -L -p tcp --dport 8080 2>/dev/null | grep -q SYN_RECV` command: non-zero status 1
# FAIL
# packetdrill/conntrack_rst_invalid.pkt             (ipv4)                    OK
# packetdrill/conntrack_rst_invalid.pkt             (ipv6)                    OK
not ok 1 selftests: net/netfilter: nf_conntrack_packetdrill.sh # exit=1
make[1]: Leaving directory '/home/virtme/testing-15/tools/testing/selftests/net/netfilter'
make: Leaving directory '/home/virtme/testing-15/tools/testing/selftests'

https://netdev-3.bots.linux.dev/vmksft-nf/results/593541/23-nf-conntrack-packetdrill-sh/stdout

same for the retry:

https://netdev-3.bots.linux.dev/vmksft-nf/results/593541/23-nf-conntrack-packetdrill-sh-retry/stdout

Not much to go on here, anything I can do to help debug?
