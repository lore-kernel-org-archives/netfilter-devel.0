Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592652;
	b=EfkvIO9T9Fk2ZJE2OV/8JG/p7JFtV5Xyf8cxSX3Ae5NT/2zYiGnoA2VZyPlAaJZCa1Yi
	 tavOp3qSkZ0L2HXbiNp47zKjv+BYWR8rBqvLvuoCHZPYjIXA21+n+PsCh1wyRpBgmno7V
	 ILXsDePiGRtQ6MWMsUIf7fMfZ6qkm0z3/zgnGViXt8HRAw0jvN810KN2JIE80/AQzl1qw
	 554mv/mZWOf+RxgU1Y0zqMmSZs5Ja7/DzbedIeh6+zWoIESqs+WWzW8oeH5seHy60Dz4B
	 UCEdcR2iQyfXezYFjEG4wf2brHEGZ2MxvfridYoYZVxdMcv3cMOK1Z5IRyBrp1Im6QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592652;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=KGPByt1l/w2w5NVSgCv2fP9X+uQOLitOIGrz+voENZ4=;
	b=aUVEq9Xinln5/52dkm9Fd6U4rgeaP1HUKnukcXunMP8rnn1cpXuMOngFLjRU4fSHkHll
	 aG4NCqlAmLhz/5tdgY5c747d4gHuRHFue4NlQt3RfxR3sLUNNIKtCe9cM4IMvO8zO4sUh
	 l1XXcB+GG8NpEZJjpMljjT+zWZUulxVdQszY6UFwmeo6r1VOiFY8VcRko+DJT8zxoI7gF
	 C5I+Ne4Qe16R2ytRI9AuKdISosu/JQeH6Go8rpbq+llpniqCN489dxaeCg+6CfQtz8v0R
	 Dak1yc+5rIGBLHsSbo94zABkjjhZvQkkVsEbaVsSgQj4iCElRB3lSFe1qpoRquOdNZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOTYLjeo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EA6606A321;
	Wed, 25 Nov 2026 07:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOTYLjeo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1BC1F000C4;
	Wed, 25 Nov 2026 07:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795592651;
	bh=KGPByt1l/w2w5NVSgCv2fP9X+uQOLitOIGrz+voENZ4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mOTYLjeoSuWpYR+AWHxkzZH/8kuw+oTfJZrBa+eZH/RZg7dC8oyxWEZEOlh/1dmFr
	 DEoR5cBmihCIzEQGG/tuNQMzU6n5c6FItNMz3+jfpKUXOI3EaONmV9aoL1+38Ewzip
	 7ZTBg5Oq7Js+Pkt94LaeGDNslRp+C8QGRMd42PScLGVEJvMjl5wM7FzkvjaCSpiCMe
	 WPiljurDQMF3MSqAkwcZXaxKpkCk1Bbo80MrABk8VgLJKaDZQG9k774d4n1UO/yaR5
	 hUiNGCq8gDJdpx0sN+PoR4XP0ptEXjuGAIsuYNCVl8USZMXeQxQopUNyfAjjH6iF6C
	 CktNrPUkcEpRA==
Subject:
 Re: [PATCH] selftests: netfilter: fix missing echo in nft_nat_zones.sh
From: netdev-bot+sashiko@kernel.org
To: zhiqizhangg@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 shuah@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 07:44:10 +0000
Message-ID: <179559265058.3135.11860282333221465868@kernel.org>
In-Reply-To: <20261124071926.8818-1-zhiqizhangg@gmail.com>
References: <20261124071926.8818-1-zhiqizhangg@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch fixes a statement that can never run, so it does not
  do what the commit message says.
- [Medium] The diagnostic this patch turns into a real message, `echo
  "FAIL: Ping failure from $cl"` on line 174 of…

Pre-existing issues:
- [Low] On the veth0 icmp counter-mismatch path in
  tools/testing/selftests/net/netfilter/nft_nat_zones.sh, the check on…

--

selftests: netfilter: fix missing echo in nft_nat_zones.sh

The patch adds a missing echo to the ping failure diagnostic in
nft_nat_zones.sh. Without it, the shell tries to run the message string
as a command. The commit message says this makes ping failures get
reported the same way as the script's other failure paths.

> diff --git a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
> index d935c967dd13b..f15bfd33739f1 100755
> --- a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
> @@ -171,7 +171,7 @@ done
>  
>  wait || ret=1
>  
> -[ "$ret" -ne 0 ] && "FAIL: Ping failure from $cl" 1>&2
> +[ "$ret" -ne 0 ] && echo "FAIL: Ping failure from $cl" 1>&2

[Severity: High]

Can this echo ever run? The script is #!/bin/bash, and the loop above
starts the pings in the background without saving their PIDs:

  ip netns exec "$cl" ping -i 0.5 -q -c 3 10.3.0.99 > /dev/null 2>&1 &

In bash, a bare wait with no arguments returns zero once all background
jobs finish, whatever their exit status. The only trap in the script is
on EXIT, so no trapped signal can make wait fail either. That means
"wait || ret=1" never sets ret.

ret is set to 0 near the top of nft_nat_zones.sh, and nothing else
assigns it before this check. All the other ret=1 assignments come
later. So [ "$ret" -ne 0 ] looks to be always false, both before and
after this patch.

If that's right, the "command not found" and 127 symptom described in
the commit message can't happen on an unmodified run. A failed client
ping would also still go unreported here.

Would it make more sense to replace "wait || ret=1" with a per-PID wait?
For example, save pids[$i]=$! in the ping loop, then call
wait "${pids[$i]}" for each client and set ret and print the failure on
error. nft_flowtable.sh in the same directory uses wait $lpid this way.

Also, before d6905f088d2b the loop checked $? right after "ping ... &".
That is also always 0, so it looks like ping failure detection never
worked at this point. Backporting with the current Fixes: tag would not
bring back any ping failure detection.

[Severity: Medium]

Which client will this message name? cl is the loop variable from the
background ping loop:

  for i in $(seq 1 "$maxclients"); do
    cl=$(eval echo \$cl"$i")
    ip netns exec "$cl" ping ... &
  done

After the loop, cl always holds the namespace for i == maxclients (100,
or 40 with KSFT_MACHINE_SLOW=yes). A failure from client 5, for example,
would be reported as coming from the last client.

The socat failure path later in the script prints $cl inside its loop,
so it names the correct client:

  echo "FAIL: Failure to connect for $cl" 1>&2

The wrong name came in with d6905f088d2b, when the message moved out of
the loop. Since this patch presents the line as the fix for ping failure
reporting, could the respin also report from inside a per-client wait
loop?

[ ... ]

[Severity: Low]

This is a pre-existing issue, and this patch did not introduce it. It is
in the same script, outside the quoted hunk. On the veth0 icmp counter
mismatch path, the check looks up one key and the debug dump looks up a
different one:

  if ! ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 }" | grep -q ...
      ...
      ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.99 . \"veth0\" . 10.3.0.1 }" 1>&2

Should 10.3.99 in the debug dump be 10.3.0.99, to match the key that was
checked?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124071926.8818-1-zhiqizhangg%40gmail.com
