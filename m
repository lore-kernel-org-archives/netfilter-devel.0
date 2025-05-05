Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995FA142E86
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2025 11:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746443913; cv=none; b=sfQLO5DgnxNmXEiXltnZqUTieVpOa/b4ZciJrKB6P+PU/76eUfI7Xjayj8vzZxQfZUvggKT9gFPxICLrUIwMqPXMXH57INHNoXmuVM4ayB8hXtVPnYrUF1QhypwmQANPabsGjkq70R3Lbg5XfyjHGkQet1980vsVRFpD+bcwjOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746443913; c=relaxed/simple;
	bh=g5cG/NCtKUQ0jbblJKripliHND94VlYO37sn5GN8En4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+onldEpOR8f/xoqUirgN42wnow6nk/MGbIViJVsutwX7XhQh8xinyLZbc0vbyflKR7hxfmCWYVnG1PbTCtVLyQBuA1OqzlAGmpA6qZk+sOpfjV7+U9A4rhRJTx3lA6PkejRwZubmH6qwD9yZzrEPymDXdlOfy7wLPSIPbTS8A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fSAJ/aRQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ryb6DEGI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fSAJ/aRQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ryb6DEGI"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 10506602F1; Mon,  5 May 2025 13:18:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443910;
	bh=fZkZRk6J5pyG7EFv6+B60wmFWj9wnCD7anDDmc3wA0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fSAJ/aRQ45zAqbaVkQnepo4lyL57ZXkD2ywNeswu7PQ9T82NryBqpRzfftEBR9lHv
	 oVs4XlV+F+cIskYyOVW2GVAf/nG+hOYXJzluHFbIzti8cka1+pQATKCAf/g1RfXNxu
	 uohHVaq05w3HjiISpbxFF7TPJrFJqFg3qtObcLEc6PizYL0sOr9J2RU5T4uio7aiKS
	 pg91MiRFojm/yZqJP39TXl76eJV8YceQR3C6i2scKO41V50AfWg9kjonnF0D5wpYNL
	 yOcbtsKpR6JAOoHG8t9jRZUuzU15z9tThWk+QUGs7ypAJgJdX3lLX0mA6FwgDIq1jv
	 gQejNI9AW124A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 856EF602E8;
	Mon,  5 May 2025 13:18:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443909;
	bh=fZkZRk6J5pyG7EFv6+B60wmFWj9wnCD7anDDmc3wA0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ryb6DEGI8W8PDkXEQb5DGSpza8+e8jvBlH1FLTqLUU/XAfsG63ravejRaiDxfh/bk
	 x4ZhlNS3+sQTX+pYP3IEbe0eT3QE/UO/ykjj+y1GssFxpgmskL+KrYezjMaFLfdGj4
	 qafYEpxT5B/OkKvr3hiybXlvh8i/tUhT4KoQG0N8BUa51GJaLGkTzHzyhkcZUyNnF9
	 rrZ9i1xTRsleajXywlEndSl6qtTRH5Wgo7WCzFy2c/HPtqVU+UvQjvhGR723HRwFW3
	 kXk+S7IwUcKbHuCfvqzmFebHghlK2QEP8EcnHPAoAiGS7YRAhh0VsAGyvVTU2UtBFX
	 7rhI2IiORopMw==
Date: Mon, 5 May 2025 13:18:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] selftests: netfilter: nft_fib.sh: check lo
 packets bypass fib lookup
Message-ID: <aBieg4v1-8AtP-_g@calendula>
References: <20250423095734.16109-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250423095734.16109-1-fw@strlen.de>

On Wed, Apr 23, 2025 at 11:57:29AM +0200, Florian Westphal wrote:
> With reverted fix:
> PASS: fib expression did not cause unwanted packet drops
> [   37.285169] ns1-KK76Kt nft_rpfilter: IN=lo OUT= MAC=00:00:00:00:00:00:00:00:00:00:00:00:08:00 SRC=127.0.0.1 DST=127.0.0.1 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=32287 DF PROTO=ICMP TYPE=8 CODE=0 ID=1818 SEQ=1
> FAIL: rpfilter did drop packets
> FAIL: ns1-KK76Kt cannot reach 127.0.0.1, ret 0
> 
> Check for this.

Applied to nf-next, thanks Florian
