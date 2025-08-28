Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8AB30C624
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 11:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379050; cv=none; b=JkKv8a/Ti0Iv2OqIsBbeo6EszXAX2Z89ns2JF7MXhbPRWr6HDJppUJP4F5166Hz+vjLT3PzUPlCH04c7xoVemjB50+u4AmEFNwbbPHK1nBVbw+zUxf1G0016xqKiDosaIo2UedcJuCnTU1uqlqs0nD9RM67fH32utl8rb9lbk+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379050; c=relaxed/simple;
	bh=kPFv6qYms6OrP/QlRWUpHFbwcPF09zB55C5JxkmI/0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8eg2CceTTXdG8KLu8AGzNEMJ7H4C1fK7xTNBm7R36AB3qExeelq7GVFFXaTpgtgUBx2k5thw5vfvW/5zOjUR6eb1fNGsAkeX2PcKAPLqfEPUZde3dcRXDPQm6NvW9uQ9nJ/MqfxrOewPgYyzp65NKHX2SNq0PBS02AuN2zxtAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=idia8m4e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="idia8m4e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TM+V4OHJqoV2KF7bOUPeSuHKfND2DoienCyHePFxL6s=; b=idia8m4e8quUTZiGhvbziZaH8M
	hE+jUxbxca7prUXPWuH+50Ecz2PdeZPdqGZRIwS26IpERCN1qAVCE32tRARO2OJO0H8KrAAAK7cRa
	cbs4CLerqdB8MjFADGk4WQ/TddaNzUUVhM6/vnCjw9AYAlLzUitH9U81bIUiiRwi5L9Ij4XYiotad
	DDaAqCYJWYHF9J7RzLyr6GXaK2nOoRMFcfCVk/gZfePpGWE7hz29dHOJfPU9TKt7AXOhvUnGAkeAv
	tcP8fWxTyfyhr6dWIdXJfzurIhTHGR8RRGKv0euo5LSrwP876Gz4T92vJdGIdEBgAHu7m9rem350C
	Goxs21UA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uraQI-000000003vl-2jcC;
	Thu, 28 Aug 2025 13:04:06 +0200
Date: Thu, 28 Aug 2025 13:04:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Yi Chen <yiche@redhat.com>, netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: Re: [conntrack-tools PATCH] nfct: helper: Extend error message for
 EEXIST
Message-ID: <aLA3pp6yXJjdEjjl@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Yi Chen <yiche@redhat.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20250815155750.21583-1-phil@nwl.cc>
 <CAJsUoE2zCJYSvm9_=784BtH26GsRDJGBTn8930wW4ZSU8nTjYA@mail.gmail.com>
 <aK-H5xydGbsYIvBU@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK-H5xydGbsYIvBU@calendula>

On Thu, Aug 28, 2025 at 12:34:15AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 18, 2025 at 11:47:08AM +0800, Yi Chen wrote:
> > This patch adds a hint when:
> > 
> > # modprobe nf_conntrack_ftp
> > # nfct helper del ftp inet tcp
> > # nfct helper add ftp inet tcp
> > *nfct v1.4.8: netlink error: File exists*
> > 
> > or other type of helper.
> 
> This patch changes EEXIST by EBUSY:
> 
>   https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250818112220.26641-1-phil@nwl.cc/
> 
> This userspace patch is not very useful after this.

Oh! I missed that nfnl_cthelper_create() also just passes through the
return code from nf_conntrack_helper_register().

> So maybe a follow up fix to retain EEXIST for nfnetlink_cthelper in
> the kernel is needed?
> 
> I mean, return EEXIST in nfnetlink_cthelper but EBUSY in case of
> insmod, ie. add a bool insmod flag to the helper register/unregister
> functions to return EBUSY for insmod and EEXIST for
> nfnetlink_cthelper.

Do we need to retain the old return code? I would just update the patch
to print the message for EBUSY instead of EEXIST.

Cheers, Phil
