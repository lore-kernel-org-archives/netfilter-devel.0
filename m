Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.78.67
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701942;
	b=lkkNuhicUn2/vRjBEU17HQwLdLg3yDqM/6onFWizJdpJPu7CBnlewRq9PJQXdeuevYZ0
	 bX61U3WbpMf+HkNWw3Ca1fwBdJGIWWpkpMFTh1oVMnbFKgGCeySwSvb1/ONuCeDt8TYNe
	 3N0JMW5EwYKdxXE5xIletX0jT3Wo5Ev/fFokEohGDaVmBwyUsNYPMv4MzlN/3HBjJEXRu
	 OazyItXOdx6aL+VmbOccD/KAnUHoF/c4cDQ/3g8PAsH5im7hk+JDP70Mna2S73YYM788u
	 q8bS10a8EoTG6e91PTvVCIRJIQnWk69CmAFU9AgdKIcvGF+Vn4ImvAI75XH2ucW77Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701942;
	h=DMARC-Filter:Received:X-ICL-RepId:X-ICL-Out-Info:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Authority-Info-Out:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-JNJ;
	bh=ol+vGPPVt3xxO1bgQrRp6EdP81/Ts6I57ZAp3TlMs2Q=;
	b=h9rJ73z9Dxl7LXOaOHNx7XbE3pTNtAZdfdcpapV05JzqBFZvWoZaKE7ihkahicm6YSsH
	 gqxbbHjb5ENLFJzptGNiU97mJSnSVMEJFEAoolpo2Bgy62Z6o0b+i3rGOXH/kPzkIcB5G
	 psQ7n+FL+bth2TV5EGv91umvbqowWUlY1gIU+MZK2Ib0xsM2Jo69yqq8kosBRHwQu20bG
	 sU2lcgJYlAAZH2XLILfJnZ+ppLZ2AFrOh83195O0t09o2vhW0AEz7D3Haw8BfpiXb2Sdw
	 yKPNOt79sPNmtYOQOpKxGOxxLwvH5MmyIBOG7Tern/58B97PszukKO+OzcHfy4zuN7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=seeber.me;
	spf=pass smtp.mailfrom=seeber.me;
	dkim=pass header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=D0BjbLMb;
	arc=none smtp.remote-ip=57.103.78.67
Received: from outbound.st.icloud.com (st-2002i-snip4-4.eps.apple.com [57.103.78.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C27606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 20:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C27606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seeber.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seeber.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seeber.me header.i=@seeber.me header.a=rsa-sha256 header.s=sig1 header.b=D0BjbLMb
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id 7C36E1800136;
	Thu, 22 Oct 2026 20:45:40 +0000 (UTC)
X-ICL-RepId: 01a1655c-c2db-7138-bebc-ea9069804714
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQFMHVwDWhxEDlYCWAZLVxQEElwOXw5cMEodVg9SGRwdXFhVCQoYVxVbHUFDWg4SAlpFBU1fDl4fBBdGGVUERx5dVkAZGQJRHFYNV0NUBF9QSQxBUGxaAEcXSB1dGVlvUF0cDh5SDlAVS1ZeCBcGWxQERAFdBV0DQAtKAV0DXgFEF00HXwVSH0EUElwOXw5cMEodVg9SGRwdXEYTGU4bV01aDUAZWAZtFFYVUgRZ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seeber.me; s=sig1; t=1792701940; x=1824237940; bh=ol+vGPPVt3xxO1bgQrRp6EdP81/Ts6I57ZAp3TlMs2Q=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=D0BjbLMbdMEqhgsbBItT7rWbY1OrXH0cX9L94gybkxu433XP675S0Y1J8/da7v19AKu7zRTg++RZZ6ykpC2WM52Sqg6FdK0wTdx+yIzN85c1ez62y4tgTHJ6cGq+D25T2hQxKMm1V3/4r/RxmzbRgQvCYvmmux2ACUnQ+kyNe6iuRxIBqnxMWBMLTMTFhffPQM7FCrLaxrbSMaXjyGgCOejeCOVA2fD+we+65oGVfdTjies8FUjGRP6oL0EXhrWZdFq1CA9TWD0NSK6oLUIpZyZ0zHh5hpzIZ6b3H79mQdYlLqkPZasUetocIK2n8c0wU0SZvynG+pQAtT7IKG9WJg==
mail-alias-created-date: 1307199970000
Received: from localhost.localdomain (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id 49D23180011A;
	Thu, 22 Oct 2026 20:45:39 +0000 (UTC)
From: Jochen Seeber <jochen@seeber.me>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	jeremy@azazel.net,
	Jochen Seeber <jochen@seeber.me>
Subject: [PATCH nft 0/3] allow map lookups as operands of bitwise binops
Date: Thu, 22 Oct 2026 22:45:31 +0200
Message-ID: <20261022204534.54229-1-jochen@seeber.me>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=YqgChoYX c=1 sm=1 tr=0 ts=6ada75f4
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=MKtGQD3n3ToA:10 a=1oJP67jkp3AA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=oFoB1EQrw9wYjVdAChoA:9
X-Proofpoint-ORIG-GUID: xSGefUKrZvBqqNdOhN8XoySOLl-xcNSY
X-Proofpoint-GUID: xSGefUKrZvBqqNdOhN8XoySOLl-xcNSY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA4MiBTYWx0ZWRfX65fhFLbyAvoo
 hDLKF1cO71A2mvn/gSWkykvQ6kxvteW0pTVu5Fp2IRfoIa1TnW8+cJDCeIPWsRExdhaq5haIDoh
 Lz/xi2Dm8JbA/LrkE+Kf2FHOpe4BRqvI8xt9rhPCHG8FGcPbO9aeez1p2Rv5DCFFBcaxwj+h+al
 aH6qZ7c69oG6LLtjIe0cZ07SR/xeIFBu52Vpd2QctEn/UyUoCi6mkX4ewd5jdwgJm0fm40PTn4d
 IIrQUBsMGx9JmbjsKj2ycuZDbGfn0qCjyrHvYyd4UMVvm2RTB8YtHprRr7lY6kkOG1fUouqQ24B
 RQYZGWJ9gn+E82sTPhKxRdD8arSH94WiRZpfdkrAIXsy/WHth2d2vGWY4ThxCc=
X-JNJ: AAAAAAABD2HU9Qsbj73SDM6eT89TfBO+or/wlW0RQhrNU6ANaUL0I3c9yiQdjs4YpJqv09Fgdp0/O+LRd03iSixwFuyFvH3PG8jVCfAYputCeTY4PY+4yuPQwjQ+Sp19vJC55j4vqsK4zQyDScadd5aw3xY2kvGxmfJFcxyxQeMVLmTh4SuwkicfhKrzQrhuYGQCPYwJJIED5E/orRXiwtU4uDFSLSVwD16GgM7CnHfDL1OCA5uJLDQoDEoJ2h4QJFoF5lhXSlcJHQa+rFoIXa0AjL3fD8xiNNmBYpA0ilLxkSgfoVHBsHoqlLH/nKixwzO7oECyshHrFv4M3zjBhP5o5pbSiEbkoASW4RkHiG1oQnOpNwTmqaWbjyaDd9kLs1A60GkzrNuceCebUQy9E63azLUMj87pu94mTgFJky60Ku+KGBYwZ5NlRm7fAoHUe9dgujYhky03C9QSMvpwmm4n7j/HFEPLv7xS3zaELV7J4X4r0T703MPb/qjRqAsfhNpX7CW0ldcQUJ8gPYI34mvvR05MOznX0OUBNUIEkNEjKuoaXUvYPI18MaR6Y7TcvpMLa1l7d2VaoFUMIoOP3zsWcbGzXHedn+GcOE9VZ+k0oLY2W7i3GXS43RxkfG2OAVMh8J3l6VXTzP9heEpYlziBTi5SoEAyWTmqKbe0eh+2i97sStz4vRyfY2yswA/X4NtilupQCcPYmmhGgZA8K+9PZ7Pm4gzQ1vGNXj154Rv+BlfCegsASflxjCraSutT9nFe+x/zxxq4ZHPhLQC3bavwFUk+PlmBIrQrHLeua8lvyqvR9Qv9bsyh/dJc6/SJLFuIZP9aAwZgr6XrR8gPA73a/E9Usjhvh1tWZkqD2ZkkAKi5gRV9jDwi9eDUcJNHTrtZXKdftS6DVnXRSr0YSbQhVOWRz/oKB1nmAMzGDZA2BZ1Lfv+tFD8Svltnofh+T/04vnrFSL0vSC8Lk+QNDWyN68ex8Mo
 MjyIjOTQGS+wIpbfUo9vD+caSvstl/yXVuQGgAMdaUlbxvZwjTp+G+q/hZrZNpS1i9y8INkaizWh105GPWBQ328plFYnlV5t+Gg8cMKxxqU8FOWo7jfoFBiGPSkI/ME2YOXiIE4aNiOy3q3k+3Iet4PMX0uZGRumcx8VpPBrwCDlh+2ozy8QnbaAp327oqU93pGALVgcpCZpUmUROfRS3goQtz6Xy1ujOE6b7wSMPd6+tpCspF+XOwxHPUn1wgJfF2RGyxRlq7igw1OBIqYLn2GtQsLM8lwWqKh4Dh3gbX3NI5m5Z2LEQkfQwCos0

Hi,

this series allows a map lookup as operand of the bitwise operations
&, | and ^ in statement expressions. This sets part of the packet mark
from a map and keeps the other bits:

  meta mark set meta mark & 0xffffff80 | (ip daddr . ip saddr map @m)

Today this takes a chain per map value, each running "meta mark set
meta mark & 0xffffff80 | <value>", or a detour through the conntrack
mark:

  ct mark set ip daddr . ip saddr map @m
  meta mark set meta mark & 0xffffff80 | ct mark

The kernel side exists already: since Linux 6.13, the bitwise
expression operates on two registers, and nft uses this for variable
right-hand operands since commit 54bfc38c ("src: allow binop
expressions with variable right-hand operands"). Only the parsers
rejected map lookups as operands.

Patch 1 changes the bison and JSON parsers, evaluation and printing.
Patch 2 adds tests/py cases. Patch 3 adds tests/shell cases, including
a packetpath test that checks the resulting mark on map hit and miss.
The shell tests require the bitwise_multireg feature.

Two points worth a look in review:

- expr_evaluate_map() flags every map lookup as constant, and
  statements rely on this to skip byteorder conversion. Instead of
  changing that, patch 1 clears the flag on binop operands only.

- The grammar change also admits a map lookup as concatenation
  component. That linearized, but "nft list" then hit an assertion in
  netlink_parse_concat_expr(). Patch 1 rejects it in the evaluator.

Jochen Seeber (3):
  src: allow map lookups as operands of bitwise binops
  tests: py: add map lookups as bitwise operands
  tests: shell: add map lookups as bitwise operands

 doc/statements.txt                            |   7 +
 src/evaluate.c                                |  26 +-
 src/expression.c                              |   2 +
 src/parser_bison.y                            |   4 +
 src/parser_json.c                             |  15 +-
 tests/py/ip/sets.t                            |   2 +
 tests/py/ip/sets.t.json                       |  91 +++++++
 tests/py/ip/sets.t.payload.inet               |  23 ++
 tests/py/ip/sets.t.payload.ip                 |  19 ++
 tests/py/ip/sets.t.payload.netdev             |  23 ++
 .../shell/testcases/bitwise/0040mark_binop_14 |  14 +
 .../shell/testcases/bitwise/0040mark_binop_15 |  13 +
 .../bitwise/dumps/0040mark_binop_14.json-nft  | 100 +++++++
 .../bitwise/dumps/0040mark_binop_14.nft       |  11 +
 .../bitwise/dumps/0040mark_binop_15.json-nft  |  85 ++++++
 .../bitwise/dumps/0040mark_binop_15.nft       |   6 +
 .../testcases/packetpath/bitwise_map_operand  |  62 +++++
 .../dumps/bitwise_map_operand.json-nft        | 250 ++++++++++++++++++
 .../packetpath/dumps/bitwise_map_operand.nft  |  19 ++
 19 files changed, 768 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_14
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_15
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_14.json-nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_14.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_15.json-nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_15.nft
 create mode 100755 tests/shell/testcases/packetpath/bitwise_map_operand
 create mode 100644 tests/shell/testcases/packetpath/dumps/bitwise_map_operand.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/bitwise_map_operand.nft

-- 
2.56.0

