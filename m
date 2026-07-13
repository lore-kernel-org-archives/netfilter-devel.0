Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EA542B310
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783949721; cv=none; b=DR8TkKKpPJv2iPCN9LMMHzZADN43eEAbXC+0H3jtts0EMRxcVVpy+2UflrTVaB5d1KVb6eLB2tvyFweTJjVjsYaJase+bI14oQQBvMMmgFVqewJ+8gXC/J6JWqcaPvJgel+JYlijMIv7xbDiCAVEGcHMU7p0j27Q7sVkD8tXysY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783949721; c=relaxed/simple;
	bh=gXaZZ9aHGE6gG7ymQ3HT3lNNBrMhtDMG1DcqB85HYt4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=O2hg1XZmPS4qNNVCdNixVMIPRGu68AfAgjwzM7HdXbgOq381ZTZRrbsXFsMxEQBe2juNsXfcDDOcrfvlsIS1yShnzTjvfcGb/VPNIrEYw9CpbaGkceOyqZC1sSlUAleavHHX6lNImoN2xe9F/fn0Gcwh+7aZy2hqBtikwJd/Miw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=GIcT9WQc; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="GIcT9WQc"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gzNjK2hdqz3sb0N;
	Mon, 13 Jul 2026 15:35:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1783949715; x=1785764116; bh=aIaKVkkSip
	n5XoXfiaQ36eaDr+imiVQ1N1IWqYd1cIc=; b=GIcT9WQcMTYNCb2O34JBa5Bx1i
	UU8IRYVAT7QclH6a4XzunApQLbHxYoDDx9F2vIggTJFlxe8QhR1MM3vqTC+cFLLN
	l8DzbGNBJTD5UJNmcrUmOi33O0iGwGzRPqMXKwj8jJj9eNTi2XSKw9x53za0+G9I
	8XDaYqHYCfG6XblSg=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id GK1OpWC9eFrc; Mon, 13 Jul 2026 15:35:15 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gzNjH0Ndyz3sb0Z;
	Mon, 13 Jul 2026 15:35:15 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 0061534316E; Mon, 13 Jul 2026 15:35:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id F154134316D;
	Mon, 13 Jul 2026 15:35:14 +0200 (CEST)
Date: Mon, 13 Jul 2026 15:35:14 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH ipset 0/7] test updates
In-Reply-To: <20260709200358.15504-1-fw@strlen.de>
Message-ID: <b84ff62f-bdea-4999-d889-c6e4da6d191e@blackhole.kfki.hu>
References: <20260709200358.15504-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1023174482-1783949714=:4576"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1023174482-1783949714=:4576
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Pablo,

I have committed Florian's patches but it seems my old rsa key is still 
valid at git.netfilter.org. Could you replace it with my attached ed25519 
key? Thank you!

Best regards,
Jozsef

On Thu, 9 Jul 2026, Florian Westphal wrote:

> Hi Jozsef,
>
> This contains various enhancments for the ipsets tests/runtest.sh.
>
> The largest enhancement is the removal of the sendip dependency,
> in the last patch -- this adds a sendip emulation via scapy.
> Note that 'sendip' will be used if present and the bundled scapy
> sendip.py otherwise.
>
> Main motivation was to make runtest.sh work with my CI pipeline.
> This uses nipa (https://github.com/linux-netdev/nipa.git).
> Test scripts spawn kernels via virtme-ng.
>
> 1) resolve the above. Add a temporary directory, export IPSET_TMPDIR
> to all scripts and use that in the tests to write files there instead
> of cwd.
>
> 2) make test setup simpler: re-exec runtest.sh in a new namespace if
> IPSET_UNSHARED is unset (the default).  A dummy eth0 device for tests
> is added in the new namespace.  This makes ./runtest.sh self-contained,
> no extra work needed.  Also avoids clashes with the test network
> addresses used by test scripts.
>
> 3) diff.sh: preserve file names in diff output: use the new temporary
> directory to store the postprocessed dump files before compare.
> This isn't needed but it helps to spot the cause of failures more
> easily, as the failing dump name is preserved in the diff output.
>
> 4) check_klog.sh: Enable direct fallback to dmesg without error messages.
> Not needed either, but it un-clutters stderr in my environment.
>
> 5) Use the local ipset binary instead of host binary.
> Allow fallback to plain "unshare -n" if user namespaces are not
> supported. Parallelize the test and increase iteration count to 124.
> 'unshare -Unr' doesn't work in my setup but 'unshare -n' does and it
> should be good enough.  Note the script will still unse unshare -Unr
> by default, it only falls back once the first try fails.
>
> 6) Make setlist_resize.sh more verbose on error:
> Capture command output to a temporary file, then dump log on failure.
> This also fixes a spurious error, the script uses 'set -e' and
> occasionally the first 'rmmod' try fails here which made the script
> exit too early.
>
> 7) Add scapy-based sendip emulation to runtest.sh.  Fall bacl
> to a scapy-based alternative if sendip isn't found in PATH.
>
> Florian Westphal (7):
>  tests: make runtest.sh work with readonly-cwd
>  tests: runtest.sh: run inside namespace
>  tests: diff.sh: preserve file name
>  tests: check_klog.sh: unclutter stderr
>  tests: setlist_ns.sh: use local ipset binary and don't rely on userns
>  tests: make setlist_resize.sh more verbose on error
>  tests: runtest.sh: add sendip emulation via scapy
>
> README                      |  13 +--
> tests/big_sort.sh           |   8 +-
> tests/bitmap:ip.t           |  30 +++----
> tests/check_klog.sh         |  11 ++-
> tests/check_sendip_packets  |   2 +-
> tests/comment.t             |  32 ++++----
> tests/diff.sh               |  13 ++-
> tests/hash:ip,mark.t        |   8 +-
> tests/hash:ip,port,ip.t     |   8 +-
> tests/hash:ip,port,net.t    |   4 +-
> tests/hash:ip,port.t        |  32 ++++----
> tests/hash:ip.t             |  30 +++----
> tests/hash:ip6,mark.t       |   8 +-
> tests/hash:ip6,port,ip6.t   |   8 +-
> tests/hash:ip6,port,net6.t  |   4 +-
> tests/hash:ip6,port.t       |   8 +-
> tests/hash:ip6.t            |  32 ++++----
> tests/hash:mac.t            |  16 ++--
> tests/hash:net,iface.t      |  12 +--
> tests/hash:net,net.t        |  32 ++++----
> tests/hash:net,port,net.t   |   4 +-
> tests/hash:net,port.t       |   8 +-
> tests/hash:net.t            |  16 ++--
> tests/hash:net6,net6.t      |   8 +-
> tests/hash:net6,port,net6.t |   4 +-
> tests/hash:net6,port.t      |  16 ++--
> tests/hash:net6.t           |   8 +-
> tests/ignore.sh             |   2 +-
> tests/iphash.t              |  20 ++---
> tests/ipmap.t               |  28 +++----
> tests/ipmarkhash.t          |   8 +-
> tests/ipporthash.t          |   8 +-
> tests/ipportiphash.t        |   8 +-
> tests/ipportnethash.t       |   8 +-
> tests/iptables.sh           |   8 +-
> tests/iptree.t              |   4 +-
> tests/iptreemap.t           |   4 +-
> tests/macipmap.t            |  16 ++--
> tests/match_target.t        |   2 +-
> tests/nethash.t             |   4 +-
> tests/portmap.t             |  16 ++--
> tests/restore.t             |   2 +-
> tests/runtest.sh            |  52 +++++++++++-
> tests/sendip.py             | 154 ++++++++++++++++++++++++++++++++++++
> tests/sendip.sh             |   8 +-
> tests/setlist.t             |  28 +++----
> tests/setlist_ns.sh         |  29 ++++++-
> tests/setlist_resize.sh     |  34 ++++++--
> tests/sort.sh               |   6 +-
> 49 files changed, 541 insertions(+), 283 deletions(-)
> create mode 100755 tests/sendip.py
>
> -- 
> 2.54.0
>
--110363376-1023174482-1783949714=:4576
Content-Type: application/vnd.exstream-package; name=id_ed25519.pub
Content-Transfer-Encoding: BASE64
Content-ID: <445a1e34-b8f0-a5d8-79c0-b4a85d7ac906@blackhole.kfki.hu>
Content-Description: id_ed25519.pub
Content-Disposition: attachment; filename=id_ed25519.pub

c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSURROUdqTkt5
cXUvMmlORWh4V2VwRjA5OVRuanZ6dGdtMk9FbndSUHNSZHgga2FkbGVjQG1l
bnRhdAo=

--110363376-1023174482-1783949714=:4576--
