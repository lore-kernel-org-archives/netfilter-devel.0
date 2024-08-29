Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1461547C7;
	Thu, 29 Aug 2024 08:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724918477; cv=none; b=Fv3UnKNgQXCfdXUC1XqkSzwQAE/ABJqMCHrho5w+PTqpt6qI7y5m+JaqoQtrgWbAd+a/CDTIfWV7xK2ggBXuqrcSIetRKqtOhbYVR2MEklLnvwj/hhqgS5J9uMDQW6FFXyoJSvG9lvO98h1JZMmFjn5M9Erg5/1SDXIo5s5GAkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724918477; c=relaxed/simple;
	bh=PaqM9/tIwzVN4UaFTMBCtN5L0w49rgk5eRP25mcWeJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n60GPj6BRHMl6JnMvzeto98e0ZGSdN8vW/zwRej+bj8iSngrEUnh1FApZXeI0DzGNtwbiYmpgODXaUMZjftpcz0mc8f5i57AVcgsSfg1voxaywsNcsUc21tUHbuaJQszJGWRWBnSXOgLbrm0gi/8o9U36sSwbuvAVcSDiZMAMFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sja5d-00007h-By; Thu, 29 Aug 2024 10:01:09 +0200
Date: Thu, 29 Aug 2024 10:01:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: reduce test
 file size for debug build
Message-ID: <20240829080109.GB30766@breakpoint.cc>
References: <20240826192500.32efa22c@kernel.org>
 <20240827090023.8917-1-fw@strlen.de>
 <20240828154940.447ddc7d@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828154940.447ddc7d@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 27 Aug 2024 11:00:12 +0200 Florian Westphal wrote:
> > The sctp selftest is very slow on debug kernels.
> 
> I think there may be something more going on here? :(
> 
> For reference net-next-2024-08-27--12-00 is when this fix got queued:
> 
> https://netdev.bots.linux.dev/contest.html?executor=vmksft-nf-dbg&test=nft-queue-sh
> 
> Since then we still see occasional flakes. But take a look at 
> the runtime. If it's happy the test case takes under a minute.
> When it's unhappy it times out (after 5 minutes). I'll increase
> the timeout to 10 minutes, but 1min vs 5min feels like it may
> be getting stuck rather than being slow..

Yes, its stuck.  Only reason I could imagine is that there is a 2s
delay between starting the nf_queue test prog and the first packet
getting sent.  That would make the listener exit early and then
socat sender would hang.

I'll test following tomorrow on an old / slow machine:

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -39,7 +39,10 @@ TMPFILE2=$(mktemp)
 TMPFILE3=$(mktemp)
 
 TMPINPUT=$(mktemp)
-dd conv=sparse status=none if=/dev/zero bs=1M count=200 of="$TMPINPUT"
+
+COUNT=200
+[ "$KSFT_MACHINE_SLOW" = "yes" ] && COUNT=25
+dd conv=sparse status=none if=/dev/zero bs=1M count=$COUNT of="$TMPINPUT"
 
 if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
     echo "SKIP: No virtual ethernet pair device support in kernel"
@@ -398,7 +401,7 @@ EOF
 
 	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
 
-	ip netns exec "$nsrouter" ./nf_queue -q 10 -G -t "$timeout" &
+	ip netns exec "$nsrouter" ./nf_queue -q 10 -G &
 	local nfqpid=$!
 
 	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
@@ -409,6 +412,7 @@ EOF
 	fi
 
 	wait "$rpid" && echo "PASS: sctp and nfqueue in forward chain"
+	kill "$nfqpid"
 
 	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
 		echo "FAIL: lost packets?!" 1>&2
@@ -434,7 +438,7 @@ EOF
 
 	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
 
-	ip netns exec "$ns1" ./nf_queue -q 11 -t "$timeout" &
+	ip netns exec "$ns1" ./nf_queue -q 11 &
 	local nfqpid=$!
 
 	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
@@ -446,6 +450,7 @@ EOF
 
 	# must wait before checking completeness of output file.
 	wait "$rpid" && echo "PASS: sctp and nfqueue in output chain with GSO"
+	kill "$nfqpid"
 
 	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
 		echo "FAIL: lost packets?!" 1>&2
-- 
2.46.0


