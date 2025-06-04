Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0929A2;
	Wed,  4 Jun 2025 22:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749075637; cv=none; b=GROVQnqlhJPGpcbgpyVpMxOXrqop2tzEYyt5hbZPk2SrK2KsbuasRjcht6elKppiYAMS5SHq1sCboj2PQfXtQI7iIQZNX5e0cQ7KRZ80XsN28L87pBZYe91EzKt7PnjpL6LBdO0KMj82d/y1Q5dUPZSe1J68Y/npKINnrGHEKH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749075637; c=relaxed/simple;
	bh=DOSmI2IaRVg7WCqkBlxjxSwDieLB68PH7PBr7wnT/Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JGSEDhGuB/s6vvkxIc8CDw8xYCErqkvTfD1McPIDggmqkLUjnDxZTAJKF1I/VLkPHeZ6bz5WvYkTp/9wEsukaWB2q0ICuMBc5+WX+hLHlXHRCHHfcbWfOuVHv5x/zV4myJJtLXyDBXHqaWnykoO/8eLskovvelaU51mo0U0P0T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jISIXxtj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TGOu92SO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jISIXxtj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TGOu92SO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D288E60287; Thu,  5 Jun 2025 00:20:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749075624;
	bh=hKHl4xGHN2ZfBaoVSK43zlyrD9LyyJzycHsHtTYcrIU=;
	h=Date:From:To:Cc:Subject:From;
	b=jISIXxtjI4dvMFBlvaUyE+COgVp+f8lq94LdWGlX+UWb8N4yZq79468v3Cf7sGYzp
	 yaTkw12KOaQBuZICCqfopA7G/aEBvDYoFmcrmVje2MiwtphVUA7dtOPKWfWbgrQ/+r
	 QRoCFnYd4Dq+t0YQSWPtIH7H5Lhq8/p3TzlfYVMBnWXheVUf6UL2f26Hy9rTje2ay+
	 LnxR52GG69pRfW4P7vKoh79q7/EvWpZkxnpVI9VprPuS0wfZDlMLaBn/sUbsymCPxZ
	 8if5lCq0O2TMCx2HOp1o7CV11euL73s9xzwgRgrB8TehH3FPoieMrr6o+n+nSCcba+
	 BnjgCG+DFamvw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A149A60280;
	Thu,  5 Jun 2025 00:20:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749075623;
	bh=hKHl4xGHN2ZfBaoVSK43zlyrD9LyyJzycHsHtTYcrIU=;
	h=Date:From:To:Cc:Subject:From;
	b=TGOu92SObib4os8F4OXMo+wqskcCbuuCqQ1UcljR8XupJz1Mt+Sl8qeoVWM1edjdI
	 pROjU37ipLAPYUmpej+khrQF+so23s3xPjHbmUdsYFpKttzagUUWG71vtYr7NMvPYU
	 oP3c7S5FKvnc1Q7k+iThZKTDGdc0WpbDgFq/LALktd2rEjAuc3PvszLd1eehz2p3VN
	 JMpfH88nvkImOnSO3EoVMUDks8iJHz63Rm7s+O794fVpGIKrq/x5cGmzZKNZmpawDq
	 IMDs/S/GEvgP9yBr6AJkb5ybVjUP9PZwn5oTRFzYtoseRkEEucj4r7tQZzHS8iKN0c
	 zpY26qXvp9q7Q==
Date: Thu, 5 Jun 2025 00:20:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] knft testing/fuzzer utility for nftables
Message-ID: <aEDGpWxv26Ac5AAw@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

knft is a tool to improve test coverage for the low-level nftables
kernel API by providing a relatively simple way to define a transaction
batch with nftables objects without having to mingle with netlink.
A set of tests 612 test (.t) files are included.

knft also provides a rudimentary deterministic fuzzer (via -f option)
along with several fuzzing modes that mangle existing tests in different
ways to improve coverage for error unwinding paths:

 deltable     \
 delbasechain  \
 delchain       \
 delrule        | - delete object in this batch
 delset         /
 delelem       /
 delobj       /
 flushset         - flush set
 dup              - duplicate object
 reverse-commit   - turn commit into abort
 reverse-abort    - turn abort into commit
 table-dormant    - inject table dormant flag
 table-wakeup     - inject table wake-up flag
 swap             - swap objects
 bogus            - inject bogus object to make the transaction fail

To inspect how the selected fuzzing mode mangles the test, you can use
the -d option to enable debugging along with -c to run it in dry-run
mode, eg.

 # src/./knft -c -f deltable -d tests/expr/meta/03-mark_ok.t
 tests/expr/meta/03-mark_ok.t...
 [FUZZING] tests/expr/meta/03-mark_ok.t (deltable)
 >>>> fuzz_loop at index 0 in state=0
 add_table(NFPROTO_IPV4, "test", NULL, NULL, NULL);
 del_table(NFPROTO_IPV4, "test", NULL);
 add_chain("test", NULL, NULL, NULL, NULL);
 add_rule("test", "0x1", NULL, NULL, NULL);
 meta(NULL, "NFT_REG32_15", "3");
 cmp("NFT_REG32_15", "0", "ffffffff");
 commit();
 <<<< fuzz_loop backtrack STACK limit reached
 ==== still more tries at index 0 in state=0
 add_table(NFPROTO_IPV4, "test", NULL, NULL, NULL);
 add_chain("test", NULL, NULL, NULL, NULL);
 del_table(NFPROTO_IPV4, "test", NULL);
 add_rule("test", "0x1", NULL, NULL, NULL);
 meta(NULL, "NFT_REG32_15", "3");
 cmp("NFT_REG32_15", "0", "ffffffff");
 commit();
 <<<< fuzz_loop backtrack STACK limit reached
 ...

knft provides a few more options:

-e to display the error reported by the kernel.
-n to perform test runs without flushing the existing ruleset.

This tool requires libmnl to build and to parse the netlink messages
that are sent and received by the kernel.

This tool is released under the GPLv2 (or any later) and it is
available under the netfilter git repositories:

    git clone https://git.netfilter.org/knft

This project is funded through the NGI0 Entrust established by NLnet
(https://nlnet.nl) with support from the European Commission's Next
Generation Internet programme.

Happy firewalling.
