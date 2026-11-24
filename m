Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795520915;
	b=4k6Bm0E920bs7hFjaNdQfIdt5pdqME5fZc1M6jIaOu1nD8NcGnuVc6pFv5InJn/fIoK3
	 3TRojWsy8OuaCd6KjP4YBrEarDm58m2+pdqCvF5B1SsMUocr9/dCFGkb1AlWoEMyiRvAH
	 kYrGrcA0tUcSYY6yBm8cD2jqb+xDaEFxkegcZHt+FTebjqeFvO0Jwod9Siqk2sVci7aUu
	 as1+u2nS2Fk89VVkyYOsK5zNWAegSYTDdWCcg6VWWCrwPrrzgpr4AHOs6ogUDt3QbQebj
	 +SrT6Jbyr1nU6iw9NEvQq0d9k4rHZ4VuCoXfd67Shh165xlWXHFZ/olkpEr/wKtWlpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795520915;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TrVucuMyk5UQg1Xd/yhaskhbgLNkPUB2tqDjKlRyaEU=;
	b=xxk8ZtFtyGANrI9ODketd7CugbzGQP2cMyd9uIhiSI4ZeRBLGd1Ou/oUGNiLEDf3zHwJ
	 Eauc487cHv2DpqUErY2NMK8VVhw5yI2j/RtcS6DO8dA3HFPME6q4fUV+IsSmchY3s05p8
	 1mo/0GPzOBXfWAfDx+0w4FPii1qVh9bm2U/KieX4w2ZI7D7tW8LAQfTNYYWHF7mG5Yndu
	 Pz2FQ7pTIsuy1yEekPzU29hZJeK9wEYAibJzjAVIM3b2Dj6CUC7rcG8pWzoJD9pl4V8Ru
	 MhyWfJVThZ74UcmYwCZnS5F3m+QI36DJZVmxIgbouPGk3t8/mZKfMHeEaGBqcHQDSQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E4D606A31E;
	Tue, 24 Nov 2026 11:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68E4D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D8BE860327; Tue, 24 Nov 2026 12:48:25 +0100 (CET)
Date: Tue, 24 Nov 2026 10:21:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Zhiqi Zhang <zhiqizhangg@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: netfilter: fix missing echo in
 nft_nat_zones.sh
Message-ID: <awVXJo3to4HG8so_@strlen.de>
References: <20261124071926.8818-1-zhiqizhangg@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124071926.8818-1-zhiqizhangg@gmail.com>

@netdev maintainers:

feel free to take this one directly.

Zhiqi Zhang <zhiqizhangg@gmail.com> wrote:
> The ping failure path tries to execute the failure message as a command
> because the echo command is missing. This reports a confusing "command not
> found" error and returns 127 from that command instead of printing the
> intended diagnostic.
> 
> Add the missing echo so the ping failure is reported consistently with the
> other failure paths in the script.
> 
> I found this bug manually. OpenAI Codex generated the one-line code
> change. I wrote the reproducer/test case, reviewed the generated change,
> and tested the patch.
> 
> Fixes: d6905f088d2b ("selftests: netfilter: nft_nat_zones.sh: shellcheck cleanups")
> Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
> ---
>  tools/testing/selftests/net/netfilter/nft_nat_zones.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
> index d935c967dd..f15bfd3373 100755
> --- a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
> @@ -171,7 +171,7 @@ done
>  
>  wait || ret=1
>  
> -[ "$ret" -ne 0 ] && "FAIL: Ping failure from $cl" 1>&2
> +[ "$ret" -ne 0 ] && echo "FAIL: Ping failure from $cl" 1>&2

Acked-by: Florian Westphal <fw@strlen.de>
