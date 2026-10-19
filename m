Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB30253951;
	Mon, 19 Oct 2026 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372882; cv=none; b=fbkHxplNhie0w+VHa/AGgP3PyTp1aL4+Y31u9suwYS/l1cQMvUlYqawkjMU/EMYzznkOAvhmIeZi5t3RnjEY6dBwkYj1/k3q0WhiRXdhxrd1J8/1ItraXWHJBeM2dbE7hQsQhVuLU5LrFmZmCFcRorPlUftNebcqbg0iNy3a8UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372882; c=relaxed/simple;
	bh=3Ir8TP71k1No72mzl+a2aflk/XS3VTqfJ00gJ3yVlJ8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Dw3xYUT/VpHyatJUjjI05rPicml+qQuNTYanhu5WfUx+CWuU2aW8mAIsuKTogmru6k1Xhd8viJQdPJMWz5azAB56em8PGHVxs20Wn7fHn/u54VUz59luzULGMvO234GaiSd1IJKZcl2Z6enxYEK2fdvUiLF41kELRx8d9gTOPHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcTeZ0r0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcTeZ0r0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6C11F000C4;
	Mon, 19 Oct 2026 01:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372881;
	bh=BaoUA/IiB69pw5+i5a25POFMR2S2myjx3y6u+M5wcw8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kcTeZ0r08fSCiNizJiDxkHgA+kLrVQ4yoy0p8aPXDfMurZYLmVmqMKLdb9Yl2qcqg
	 4OKQUqmteLSqkGn5/oxeS8oYalw967nLY8ryxfaTBnJ27XdWiLKaf7D10whkVassxB
	 ULbpohMjqEwdbMKNw4gvaXLAmkufiAZBKjTilBrpBJal6M5lE1ZlDh/42thNz4IZec
	 LkVDcJQXrWE5c6P5gPJOiKTY126LoV2jnA2AgxCOJMjz0hPkA/D1UA4S8mjtDFe8ZF
	 hjJZtHyjb2uN8QdyJGtsuovzF0VCcrUn6N/wO5Mmpvjw/PvsRMa4W7/+QvWc/UBpvB
	 5aX7E2FRZbY0A==
Subject:
 Re: [PATCH net-next 01/15] netfilter: disable br_netfilter in user namespaces
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:20 +0000
Message-ID: <179237288041.3135.11774275051307629447@kernel.org>
In-Reply-To: <20261018005638.1776148-2-pablo@netfilter.org>
References: <20261018005638.1776148-2-pablo@netfilter.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
  re-execs itself under `unshare -n` (line 40) and then runs `sysctl…

--

netfilter: disable br_netfilter in user namespaces

This commit disables br_netfilter in network namespaces that are not
owned by init_user_ns. In those namespaces it skips registration of the
bridge-nf sysctls and of the br_netfilter hooks. It also adds a boot-time
warning that the module is slated for removal in 2027, and updates the
bridge documentation to match.

> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 0a394e5f43916..e15355ff215a7 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c

[ ... ]

>  static int __net_init brnf_init_net(struct net *net)
>  {
> +	if (net->user_ns != &init_user_ns) {
> +		struct brnf_net *brnet = net_generic(net, brnf_net_id);
> +
> +		brnet->in_userns = true;
> +		pr_warn_once("br_netfilter no longer supported in user namespaces\n");
> +		return 0;
> +	}
> +
>  	return br_netfilter_sysctl_init_net(net);
>  }

[Severity: Medium]
Should tools/testing/selftests/net/netfilter/br_netfilter_queue.sh be
updated along with this change?

That script re-execs itself in a new netns via unshare -n. The new netns
inherits the caller's user namespace:

    [ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }

It then treats a missing sysctl as a hard failure:

    modprobe -q br_netfilter

    sysctl net.bridge.bridge-nf-call-iptables=1 || exit 1

Suppose the selftests run inside a non-initial user namespace, for
example a rootless container or a CI job under unshare -r. Then the
netns created by unshare -n has user_ns != &init_user_ns, and
brnf_init_net() returns before registering the sysctls. The sysctl
write fails and the script exits 1, so the test reports FAIL instead of
SKIP.

Before this patch the sysctl was present and writable by userns root,
so the test passed in that environment.

The sibling test br_netfilter.sh already treats the same condition as a
skip:

    if ! ip netns exec "$ns0" sysctl -q net.bridge.bridge-nf-call-iptables=1; then
    	echo "SKIP: bridge netfilter not available"
    	ret=$ksft_skip
    fi

Could br_netfilter_queue.sh use the same handling and exit with
$ksft_skip here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
