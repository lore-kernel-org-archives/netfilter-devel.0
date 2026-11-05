Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876528;
	b=B76i8nPRmfdzbK5iEaqKbn/V1LSmNrLplgz/XJLu8vF5SxYcJh+dh+iOAiH4C8x5g8q2
	 BhD+uxrhFbZQLErkYMdPpP7cUl2NrE5WYY0+SD19KszMn8LHFiAqKYzOdeEYBNSAJwQnT
	 6z5AEErD6ngXYR0Igu0u0ecMfdTK5J9B6sZYrcwKQvhyfzfGqFms7ardyuUIiI/dxmnac
	 fpXbxDwuIVMgJOr5H1+SoX58FsEqv+Ny1fFZ8VnXqsBtMojGAiKJRjqeATsKN6mVLUq8R
	 Y3bzEolYkxAnbDFpwS/3reJOYuGB2JeVq6tc0tfELNbxHQqGNjbfhRqA3dR9e7gXkWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876528;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=R7DP1uNG35Sbet4cB2t9/UcoHOaIPaPI2vgXOPccRTQ=;
	b=p39WJjEUwV13z46A93SGBioOfbx5kPiQpgyELycW6G5niD1RfBNUs6cjxH4kN1fvH5Iz
	 0xi6RtLR7Gnf7eU6ypfWhYs1E8UpFoY/mmd2zACcechEvj4EEp0cB/wcXb3ydBXQDRLII
	 vye+4/b6ymcNe0QCUoUgj9X2QJ0k5a7IJLbvkIJvDjMmiKEIrACbc0jSZzSbcS38QeRGy
	 oDxfEeI7fctr/YdB/q8PngCG/nNrFy9WL4NqRm7dFF1gEWiuqbN//krKHwcJ+SiJ3MVvZ
	 VqUd2499ns6lIHnc8PP88DdCfJnqU1fCiYbEvJdOeD/5A/IY1Ep0LJvyfGARU9H5waQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fOXl741e;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 687FA606A31B;
	Thu,  5 Nov 2026 11:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 687FA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fOXl741e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793876517;
	bh=R7DP1uNG35Sbet4cB2t9/UcoHOaIPaPI2vgXOPccRTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fOXl741eoELUKMQc1lZC5pnhMimVXWLtINBvV7WTCQDw4mmyXrBLXbfWaRp57bsGj
	 i745Xk/VKMGj3IpVQbfzIANPd0oqH8YqJytL2YPGbKs1DNpoITEXUr4n3llP2qQlVG
	 dkMn4obIYPXO9uZtCfKfzYzx3GSLdEFD50QcuMZCpJE0Fwkxill6WJp+B1Oa4Y4MGn
	 eBSChWjQzF2R2bAxoABKpygAMlFfpUQvNsX8A46CJtaVfwI7hXtcC9yrpW7cEZ2riG
	 wyW9ZFKEQpLmo7eWIXkRiEYMT+nzppwSFzvRLTaVT50LxHmtu7z1QPAz7Bb7UZTaX+
	 eRDeuT71GaHrg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6FE3660052;
	Thu,  5 Nov 2026 12:01:57 +0100 (CET)
Date: Thu, 5 Nov 2026 12:01:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: shaos <shawnq1@163.com>
Cc: Sung Byeongchan <tjdqudcks0424@naver.com>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@kernel.org>, Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: xt_dccp: reject short option lengths
Message-ID: <auxiI-Jl7ctXoSZO@chamomile>
References: <179251068646.3135.16276902372052104830@kernel.org>
 <20261105081735.749379-1-shawnq1@163.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105081735.749379-1-shawnq1@163.com>

On Thu, Nov 05, 2026 at 08:17:35AM +0000, shaos wrote:
> Hello,
> 
> The 20 October review of the reserved-option fix pointed out that
> `dccp_find_option()` can mistake a short TLV length for the next option
> type. The merged fix did not address that case. I reproduced it on
> top of commit 2edda78aa4eb (the reserved-option fix).
> 
> With INPUT policy DROP and an ACCEPT rule for `--dccp-option 1`, an IPv4
> DCCP packet containing options `{32, 1}` is accepted. Option 32 is a
> multi-byte option, and length 1 is invalid. The walker advances by one
> byte and then treats that length byte as Mandatory option 1. The rule
> therefore accepts a malformed packet that does not contain option 1.
> This affects firewalls that use DCCP option matches as an allow-list.
> The match requires `CONFIG_NETFILTER_XT_MATCH_DCCP`; a remote sender
> needs reachability to a firewall that uses an option-based DCCP rule.
> 
> The reproducer uses raw sockets and a local IPv4 DCCP packet. The QEMU
> runs show the false match on the original kernel and after the merged
> reserved-option fix. With this patch, the malformed packet is dropped.
> A packet with a real Mandatory option 1 is accepted; without option 1,
> it is dropped.
> 
> The earlier review is here:
> https://lists.openwall.net/netdev/2026/10/20/477
> 
> Tested source revisions:
> - Vulnerable: c03c1a14507dfaf8b856c2608f9ac216021fc222 (Linux 7.3)
> - Vulnerable tree: 30fd2ef82912c26cf3a58ad0ba6afc375fa851ac
> - Prior fix control: 2edda78aa4eb04cd8f112a81897510ee0cdd7099
> - Patch control: 2edda78aa4eb04cd8f112a81897510ee0cdd7099 plus this
>   patch
> 
> Git tree at patch base: 8644625317c9d6e32244509e29387fb0c80af0f4
> Compiler: gcc 11.4.0, GNU ld 2.38
> QEMU: 6.2.0, x86-64 TCG, 1024 MiB, 2 CPUs
> 
> Console output:
> https://gist.githubusercontent.com/shaos26/a39f036057ddd1c1b78ce2da114b8f3a/raw/6a95ab42fd7f47c2e0113c55bc80a7e86002f222/console-output.txt
> Kernel config:
> https://gist.githubusercontent.com/shaos26/a39f036057ddd1c1b78ce2da114b8f3a/raw/f60c4bca22a42434cac67478e74d6f7c5b28442c/kernel-config.txt
> PoC source:
> https://gist.githubusercontent.com/shaos26/a39f036057ddd1c1b78ce2da114b8f3a/raw/3c45d0d340d804c236503cecf5ffe33f700245d0/poc.c
> 
> Check out commit 2edda78aa4eb. From that tree root, copy
> `kernel-config.txt` to `.config` and run:
> 
>     make ARCH=x86_64 olddefconfig
>     make ARCH=x86_64 -j"$(nproc)" bzImage
> 
> Compile the PoC with:
> 
>     gcc -static -O2 -Wall -Wextra -Werror -o poc poc.c
> 
> Boot the kernel in a disposable QEMU guest with BusyBox,
> iptables-legacy, and `poc` available. Install this rule:
> 
>     iptables-legacy -F INPUT
>     iptables-legacy -P INPUT DROP
>     iptables-legacy -A INPUT -p 33 -m dccp --dccp-option 1 -j ACCEPT
> 
> Run `poc badlen1`, `poc present1`, and `poc absent1`. On the unpatched
> kernel, the malformed packet is delivered, the packet with a real
> Mandatory option is delivered, and the packet without option 1 is
> dropped. With this patch, the malformed packet is dropped and the two
> controls keep their expected results. The test needs CAP_NET_RAW to
> synthesize and receive the local packet.
> 
> The option walker should reject a TLV length below two before advancing:
> 
> Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
> Link: https://lists.openwall.net/netdev/2026/10/20/477
> Signed-off-by: shaos <shawnq1@163.com>

This needs a real name.

> ---
>  net/netfilter/xt_dccp.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
> index 23a4e3e8df7d..e0d7f4374958 100644
> --- a/net/netfilter/xt_dccp.c
> +++ b/net/netfilter/xt_dccp.c
> @@ -62,10 +62,15 @@
>  			return true;
>  		}
>  
> -		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
> +		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1) {
>  			i++;
> -		else
> -			i += op[i + 1] ? : 1;
> +		} else {
> +			if (op[i + 1] < 2) {
> +				spin_unlock_bh(&dccp_buflock);
> +				goto invalid;
> +			}
> +			i += op[i + 1];
> +		}
>  	}
>  
>  	spin_unlock_bh(&dccp_buflock);
>  	return false;
> -- 
> 2.34.1
> 
