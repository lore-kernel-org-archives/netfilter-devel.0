Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272828;
	b=r0thA9JX4t1kI5EgQnacn5QXOww33FFBM7uh5dyFphjmFrH/AgPij05qGCdyEZvTMIsq
	 cQPptMez9/lHKTg8tRmFEq2V6LAExy9xcuwNAwjwWdY5bmFoEwrXP8Ma6ZIkJylcvtBH3
	 zgUiYREtcIEM26pvuBQ1CFRfjwVg/qqUD+aThYd6rTbO/GV+f/oVTsFiRn5TSFwigMy9n
	 j4KG3oGBo0kaNugi9MdfnNiOmy8zVa3J1iC5UVSm+AGrklok7vTuN0Y+VTEmpuv8QGF2i
	 B2r7CxsnjTjWHlBEwGnnfsOMArdwJFA8ZVg++KlXkPu3Sw+r9rONU4tSxi0/9Xjqa5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272828;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=QMZavQfyxegdbTeVgohaNKvJvzRal1J/ACJkCkgdELc=;
	b=w9UlQcaRWcfyA9AHLAntA9OygljIlUrDfvT3PzJaptiLnuKJMQD82Qmz4cn0O6rWxbnF
	 oUSbsmSrdbWo2NZBSsjqSgY8NVW22Ybal7Lu2O+WD7sNmBhMB3yOHYPNvBb90iyXSGzAY
	 whJkW8K4uaLLTaB+3k45fYckzKmPAd8z5sAQHOvWP20FTuLseN/Tvxo7aB6IsMqaB98bx
	 GGG+DYwGghNALAvOMac+WLduVXQMwqw5+G+7+XrG+h3YXC0/4ahGlVQa1I065UtaOe8Vk
	 7ITR5rzCsalJ9K5iXOf/93lVOg/vRESPvvK1A6NRL/B18Sfkd3hI4CENV1um8i77f9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cxljEmr1;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A8338606A334
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8338606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cxljEmr1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794272825;
	bh=QMZavQfyxegdbTeVgohaNKvJvzRal1J/ACJkCkgdELc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cxljEmr1YQSpIqAyAHxy0PlsVDCPtyN4mDF3/YIzpeOjtyzmNsiXP7EO+nlO4WssP
	 MWaXCK2V6vWG0yo+YzOpMJeq97G4BzKJQFhgT4QW9zl+97p9kxupKU/vjLeoRU29AB
	 hRvpEskgLBoUb78mnZ50eyhZ0qPfAjXtqZBgoz/SZzxSxoVYnKPpVL9RfQIBRW87Vj
	 EE5r78RfthQj1EqachKMgpnjlgz6z6/+Vy4gPwZsSEgHcxt8Mi+hJpXKNOqs0CFVcf
	 a7WfLzGJEItbfnUqCpWsG9CxdgHRgUVDRILhBJ/BBIqwGJAirxVWjyU19ykGORTXv+
	 QS0RRzwH/IWBQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7DA8E60052;
	Tue, 10 Nov 2026 02:07:05 +0100 (CET)
Date: Tue, 10 Nov 2026 02:07:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: zhangmh25@mails.tsinghua.edu.cn
Cc: netfilter-devel@vger.kernel.org, jianjun@tsinghua.edu.cn
Subject: Re: [PATCH nf-next v2] netfilter: nf_reject: validate TCP header
 length before sending resets
Message-ID: <avJuN1cClzssVmi0@chamomile>
References: <20261109164726.3868529-1-zhangmh25@mails.tsinghua.edu.cn>
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
In-Reply-To: <20261109164726.3868529-1-zhangmh25@mails.tsinghua.edu.cn>

On Tue, Nov 10, 2026 at 12:47:26AM +0800, zhangmh25@mails.tsinghua.edu.cn wrote:
> From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
> 
[...]
> With connection tracking enabled, segments with an inconsistent data
> offset are already flagged by tcp_error() in nf_conntrack_proto_tcp.c
> (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) on the
> paths where conntrack runs before the reject rule, so rulesets with
> an early "ct state invalid drop" rule never pass them to the reject
> target. The netdev and inet ingress reject paths run before conntrack
> and are not covered by that. The affected configurations are stateless
> rulesets, netdev-family reject rules, and rulesets whose reject rule
> is not preceded by an invalid-state drop.

I am not sure I want to duplicate all these checks that already exist
in nf_conntrack only for the stateless case.
