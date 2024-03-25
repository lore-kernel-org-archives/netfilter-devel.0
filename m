Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64BF717EB72
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 09:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711358381; cv=none; b=YP2BDdxmni5WU6SwQQVP+fZL/zmu5m5qTKD9HU9Qt6gucuTvIEplnjToaba5UQzBXo5ffWgU4PAblg7aB9zW6KBIZCA+iL5p/i1+OHfsXh49Tqff/cGlcyhArjwO4OgxE3PRHZLLzF+67AOJ7Jt25K+shFAsD2aFf9yXa61PeLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711358381; c=relaxed/simple;
	bh=qAMStYQqsNm0tOiBlXok7t2v6H47LJwLOLVvYwdXRGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nryYzt28by/sM/2otENNrcYerCtkuT+kyUDb2V6a5aPvHqpkPwROahd/ScIe8Q+qlNgBUKPK0EQFZnErmeo/gl6JgUpykQVviG61Sc6e/oUBC2wKhkHSaYuGWgmra/93BRv3x9Gzr4TkDBWKdmx5+YtzSgH4pnScF5srOWHaS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 25 Mar 2024 10:19:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next 0/3] netfilter: use NF_DROP instead of -NF_DROP
Message-ID: <ZgFBn1fuSRoDuk1r@calendula>
References: <20240325031945.15760-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240325031945.15760-1-kerneljasonxing@gmail.com>

On Mon, Mar 25, 2024 at 11:19:42AM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
>
> Just simply replace the -NF_DROP with NF_DROP since it is just zero.

Single patch for this should be fine, thanks.

There are spots where this happens, and it is not obvious, such as nf_conntrack_in()

        if (protonum == IPPROTO_ICMP || protonum == IPPROTO_ICMPV6) {
                ret = nf_conntrack_handle_icmp(tmpl, skb, dataoff,
                                               protonum, state);
                if (ret <= 0) {
                        ret = -ret;
                        goto out;
                }

removing signed zero seems more in these cases look more complicated.
