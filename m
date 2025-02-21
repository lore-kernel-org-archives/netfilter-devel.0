Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1372B20767F;
	Fri, 21 Feb 2025 10:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740135208; cv=none; b=lV88JkrZnwhuhZaYo5IPvniFhnwlw3McXoRpyMsEnGnpLZkf0t5scTKf+dyX+H33aPbE5RoXPHwL99+AQRNOy6Y7mZ5eRBVkh8VXt1ksqRlln0vnHce5W9gKIw01vdO1wEXlBkcrr3cbcqnHl1XvRPVwKKKN+dCdLItxTZama5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740135208; c=relaxed/simple;
	bh=UWLFT2ycnB61ZUcON9v1HZSKUWNgHAi22ZxR4YEjISY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZmwvd+lDlFsCteTmtrQ7CRy88/Eq89pRXJpXDFl+FiB9Aq5IMgar00C3NiGB2GUaIfYn5+OFrlYkqgiFLAGeDTAC0o/U63hB17w1lkkbaIjSYZYSDROgETMz+GUBbQrjmvUlZmUIXmwLJlwFi2ateUXEPti4Cheh86cf6GF01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MFYP9S2s; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Xphrwjk/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MFYP9S2s";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Xphrwjk/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 02471602A9; Fri, 21 Feb 2025 11:53:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740135203;
	bh=UjWp1rHD7uehIrgbPHgyTnzhHT5mQmNpOJ75YrO66dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MFYP9S2srHkuutx8ysj1z1RUFKBkOL1bu6CTjZuEZwZJpGHI1XbZA4wNjWiDI4VFt
	 BhVo57pT84PC9aGACBTH5yiv8iunp6DDWSyTlmUceyKj67EafvPuzUHm3q5N6uCpgf
	 t/+/152MBQcA3Dd1bpUSuiJq0qS0klKt0wHzleuIFh1TR+/WezcpajfWPLO4Ov6Itt
	 LQQz3dXiH1NQRgwMmAIJzjMg5nu6jcGVml43NdBnjD8yBitzIgRZn+wk3gUWxeVag0
	 k9j3yebTz4Pym4vi6znPvbCg+XqZVI53NTDr1IVZOsLgxgXu7PYpdlPI9PIh/LMf4y
	 j2jzuAA+dE9Fg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BC26060293;
	Fri, 21 Feb 2025 11:53:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740135200;
	bh=UjWp1rHD7uehIrgbPHgyTnzhHT5mQmNpOJ75YrO66dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xphrwjk/q32QbzCMJujPE8aN3O8QqhNkLRyX8tbHrag87dIrKa1VbVFi0Z8ymJ1zj
	 NFEzFTVLmtDeinMrc6DXeDcX7b3JhuHwy5cKYva4zr8WasudR/LaYBjl1EnMZiG7h4
	 y64E7++K/nQqrH9Fbc2ox2jtDd7B4Aj07FRQup2GZ3FxjkHvlauVg5GQCiEkpT5Seq
	 LlsZlU6nIskU3D1DxhIRbhKtFtgDOKrdoAONUmEf8tETsO2ya/CuufIqtsAyqDqCSl
	 pLc29x8WxxOios0m2a0dw1No+8/MnQlXC/V6XkhihjKk55h5ivoayLM/56gv/IjXGb
	 6cz7ANbYncvgQ==
Date: Fri, 21 Feb 2025 11:53:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: wh_bin@126.com
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack do not print ah and esp as unknown
 via /proc
Message-ID: <Z7hbHd0yK5I3ks9-@calendula>
References: <20250221102153.4625-1-wh_bin@126.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221102153.4625-1-wh_bin@126.com>

On Fri, Feb 21, 2025 at 10:21:53AM +0000, wh_bin@126.com wrote:
> From: hongbin wang <wh_bin@126.com>
> 
> /proc/net/nf_conntrack shows ah and esp as unknown.

there are no AH and ESP trackers in conntrack this far, that is why
they are shown as unknown.

> Signed-off-by: hongbin wang <wh_bin@126.com>
> ---
>  net/netfilter/nf_conntrack_standalone.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 502cf10aab41..29fb5a07a6c2 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -266,6 +266,8 @@ static const char* l4proto_name(u16 proto)
>  	case IPPROTO_SCTP: return "sctp";
>  	case IPPROTO_UDPLITE: return "udplite";
>  	case IPPROTO_ICMPV6: return "icmpv6";
> +	case IPPROTO_ESP: return "esp";
> +	case IPPROTO_AH: return "ah";
>  	}
>  
>  	return "unknown";
> -- 
> 2.34.1
> 
