Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8963B435518;
	Thu, 30 Jul 2026 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785420563; cv=none; b=rOwLp1rHo7zn9KY96nlFM+K+i09OrjIjOGBdouCuwM1Tbgwf+PH+xYUXgkmLj4TuJHsoPYzZGvUFoYHXdu59SHRBHZf6o9trc5PNvAGohcpPQ0j2iyxh9JYFk7uc8u2d8Xq2TJ9lCz4s+fsaCFU56wmOm5Gk0B7aDStTqh1vf6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785420563; c=relaxed/simple;
	bh=cLLb8BQB8reOxL4gX8bY1a1SDpjSvWdnF4MX2pM8Di8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npKvS565n9KWI4jkk9ac7WFOjrUtqQ44anAsrJ8T3dcPNAM9aVnsNH9vdc34PtWzQPJMDhPGT5OA+qGC/uHdgNVhQgNEyyWvk1elq76dJVMAAlkfcpi/s3pi04R7xlVx0UwdQP1adMPczwnzz1ZZLd6Uv6GyJNN0bzVtbVal9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=igutYt82; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hByCu7Iu; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="igutYt82";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hByCu7Iu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 6835E1D0002E;
	Thu, 30 Jul 2026 10:09:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 30 Jul 2026 10:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1785420560; x=1785506960; bh=8udFup9Noz
	aduK7FJgWwdcD9QjYfOaTlmc3535sNv7o=; b=igutYt82RvwT+jgHLX+aNaI6N1
	kSaHeQHY4TIOo217hvQWQwgqwIvsbX4rpe95c/MCWogbQm47AiAHUhiAMyouirkz
	xfLikHzN8yD4pqlBpDcGoaZeFVKdkn6vRX0bwMi2inERan22z0EgoHOW+uJBO7z4
	Pl0eRhFd5gOgAgreV2WlyTWiKkks8sCqoYB5AJTKUFW1DTzCBMoORAoAppUxJ4qF
	qbLuPg5lv0fYi8YKcFEemY2+g+R2DaEW0mB1hwr5hPRS+z5B3nxGUENaNAQNFXUQ
	ykQJzOukQzbqoNknPeChubac/3MD9/A/o9jDgDywLwqxYz57nRmH6bHmbQRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1785420560; x=1785506960; bh=8udFup9NozaduK7FJgWwdcD9QjYfOaTlmc3
	535sNv7o=; b=hByCu7IuYFNkeWazTiTbjZ/8CfKjFJC5fMUYErNhf5h12ZHALfM
	LykY6jU2UyPVbMI3WZkOTtk7/NDrmBiQDOwj0necQAjthOPqixVZf/aHTW+4eIho
	ZtHQVDU6IL1R2QcTHBblfG9SKRDSckucai64A95+VrJjf6BeC6znPi1QrgAQ+jSD
	eoa8TPGEutLAkszOa9zb3QdKmZfEATB7/uF4H/+vl4s/CQW4iw9QijGs+BskWdgb
	5jJJ37NAwd5sKeQAYIyxGFzSJ//fJSgxhv2A4VHnV9bfoNUwCPreyMDPSkANxR/v
	yUFfpy0D/xYcZaJTVCWprzRz0gXn6GcheaQ==
X-ME-Sender: <xms:EFtratnOxHGTD98v-ssXFwyFZx8SYxQnt73h0YfHxpqQm-7mZdXqzg>
    <xme:EFtrarboYlOf8QFsTIE80ap90Kb7FtDdhS3jaaPapTHRCIP9DPtNxlu7ZCfv6SQ9v
    VeZRaDmvew_KboWN1GiGI5OnjX8QrA_RlDwVEKITK2wzcsHwQ>
X-ME-Received: <xmr:EFtranRuFkGH6mnp7v0vakJJoLqZawj0SNvNkmI4oVT8qCLKtKuGEZehkvG6RngD4tUEOy8qcKbey4YhuTqj13A1a8_jE1vZJOXIyjcvp9w>
X-ME-Proxy-Cause: dmFkZTEgL6A9/pkDTpV7xv0CzIX9X6r4+w8Se7aiV4ziyuaXpMOvRVc6656AynEqeA8GLs
    +Y36ti16t6J8SQzqUa8Eua8ZXlYXoSyF8Q7SYh2RrQq0N1hUPAscANf0BTlPsZeKFr53zk
    eOSsDdpd6mDXJOMSwTGAOBkwZJSQP3hg8d7PHCtUA/b7olZ6ksx9B8qmxI68Xtlzq/H/Es
    tOeumULX0lCebom5vyz1SBDPO1eG9n1ukYmkSJUNPFUxX2qJwCuk4D9VL+tEtaT2s0PUQA
    kCGaPM3UVZ9RSHax8pxw8/EnYJQW1SgkrYFvZMF6tIpBv6DFVqc9mCHxGtBsUlEXZkvdf2
    Ubv4kHs8Fd8iaRbWpLamBUoXBtNs87VbsMBMlQzajTkSI6gQXPSTKw4NhgfryJUW7KhMFZ
    8GHVn8XrU2aMvXNiqEuRnvlnRuuJCw8j484SGyfRRuq4dH12ET6KJGq+A1MCyGVNgo6CxW
    1vZ1b3A0mKkBnWWz2nznTFlCC3M5/EYLEV0r1yHp0oA4i2P9mZEoYsa3zQMNvDXrzwAl1j
    0j7gZhFB3xsrEYEfeWWeA28xerUFq0p1sqs4XxEn9jGyd/8NGpHImoEIBxRRU30htLi7sn
    dsvwSXOF6Xy5Ke7AKBGVD2I8jzt2x8+4no00foTUtDKpbZ8CepKkswnX91qA
X-ME-Proxy: <xmx:EFtratv0RVblwDC95gswPIsq5mP_yVeeU4SECahkenQsQ0WnItjFUQ>
    <xmx:EFtrahEzKrvFbUM3jqxsVAh_ssTbiouqV3gXPTPjY9eRw9qRXTBWoQ>
    <xmx:EFtramy6Jn6KDC0oR4ew1PFRb4CURg0nctEd9KMqqhrbfZc1UVDLOg>
    <xmx:EFtraj1kkc6epvhB_zNYpxvBNteec6T9oMPuYdT29KT_i9KU47eHIw>
    <xmx:EFtrasjtRNasGz5CpqkfNYnldFDZ5m78ZJ6aAJOQkYj91Xa6RSPQnluL>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Jul 2026 10:09:19 -0400 (EDT)
Date: Thu, 30 Jul 2026 16:09:06 +0200
From: Greg KH <greg@kroah.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ilya Maximets <i.maximets@ovn.org>, stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: Backport request: "netfilter: nf_conntrack_expect: restore
 helper propagation via expectation"
Message-ID: <2026073054-certainty-reapply-a613@gregkh>
References: <ee95f6ac-181e-4315-a2ae-e4d1388c5e69@ovn.org>
 <amqHu5H6xu02Izo8@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amqHu5H6xu02Izo8@chamomile>

On Thu, Jul 30, 2026 at 01:07:39AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 29, 2026 at 11:38:17PM +0200, Ilya Maximets wrote:
> > Hi.  The mentioned commit dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a
> > was backported to 7.0, but not further, while two commits it is fixing
> > were backported down to 6.1.
> > 
> > Admittedly, the patch is not very important as far as functionality
> > goes (at least for FTP), but the issue does change the user visible
> > behavior and that makes all the FTP system tests in openvswitch
> > project (in userspace) to fail.  This makes it harder to validate OVS
> > on kernels below 7.0 and makes it unnecessarily harder to validate
> > changes for the openvswitch kernel module on stable kernels.
> > 
> > So, it would be really nice to have the fix backported to the same
> > branches where the commits it fixes were (6.1).
> > 
> > AFAICT, cherry-pick works without conflicts down to 6.6.  For 6.1
> > there is a minor conflict, 6.1.y has the extra debug message:
> > 
> > diff --cc net/netfilter/nf_conntrack_core.c
> > index f5c466ea1e7d,8ba5b22a1eef..000000000000
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@@ -1800,8 -1811,8 +1800,10 @@@ init_conntrack(struct net *net, struct 
> >   		spin_lock_bh(&nf_conntrack_expect_lock);
> >   		exp = nf_ct_find_expectation(net, zone, tuple, !tmpl || nf_ct_is_confirmed(tmpl));
> >   		if (exp) {
> > + 			struct nf_conntrack_helper *assign_helper;
> > + 
> >  +			pr_debug("expectation arrives ct=%p exp=%p\n",
> >  +				 ct, exp);
> >   			/* Welcome, Mr. Bond.  We've been expecting you... */
> >   			__set_bit(IPS_EXPECTED_BIT, &ct->status);
> >   			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
> > ---
> > 
> > WDYT?
> 
> I am fine with getting dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a into
> -stable release < 7.0 if that is what you mean.
> 

Great, can someone send us properly backported/tested patches to apply?

thanks,

greg k-h
