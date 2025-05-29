Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17208219A8E
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551079; cv=none; b=OWdUOmlPUsmg5gcJWzRtXLNg11a2M7G2J1nDllTSJQFQLM4t5YMlPk6xAhsLOnALsHZiu/dr9jtJhxMdhzyT733zSXNgUxOmblQ/8V3P9w5MbDEWWdLaJPWx5o8uKHubrug091mPNQHLNQAAVOJ8GnjePGc6oxufT8+pXvpVUFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551079; c=relaxed/simple;
	bh=ZaAjSczGTWDGQGnWi5NmJuYifjG+mthHHsP8JUI6QhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKoZhvbCyTquUMYDbP9nLI2THJ5N/XyLbVB01eHX+81Dx7DkRRKlGqsxkoq6AEoQKTxfMqDMEUfRsgb8iVfut1dFoFHNUz9wuLrR9+kntdl9YBQzsEU/yRQEWjdANIb4nUKekgQZ28CbLAHiKnThhCzJb7n50/47WMuQDDpiM+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=U9ZwX5ks; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="U9ZwX5ks"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Aa2h3Km6eIRc8upqZbeevy/XSL28VmKRtK9Cq3Oa6pk=; b=U9ZwX5ksfxCvM6vJb++GczONFx
	/6nyJz/icEcjcgRiTdDwDUx2q3RwrIcGgUt6WWm254HvqE+D35sYx3TUaqgUMtHNn3huOqT83Xcri
	1pL6pOgXEXbeFAofpWa6rnrATziWNeMaTzqY2h5v3v4BRi6riQRoS+xDWFNOC2mxG/z6AbsateMGD
	mSdKHyVyZfJ2PfdiCj1T7SudfE7rWol37kpb299q2zVR42w7kJv49T6QihjaHpvU2Y9v+RMiT1Hem
	jFBeGqXbJzX2VaxFqLNPOpv/f89AjXk0VIZMMGuYchrk4hXyw0gIFecisGWsJkVFCGwFiBxSqShzm
	M9V8CmNA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKk0h-003E0M-2C;
	Thu, 29 May 2025 21:37:55 +0100
Date: Thu, 29 May 2025 21:37:54 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 2/3] xt_pknock: replace obsolete
 `del_timer`
Message-ID: <20250529203754.GI2764308@celephais.dreamlands>
References: <20250529203146.2415429-1-jeremy@azazel.net>
 <20250529203146.2415429-3-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="p2kZ4Os337YQVW4E"
Content-Disposition: inline
In-Reply-To: <20250529203146.2415429-3-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--p2kZ4Os337YQVW4E
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-05-29, at 21:31:45 +0100, Jeremy Sowden wrote:
> `del_timer` was a wrapper around `timer_delete`, and it has been removed =
in
> v6.15.  Replace it.

This needs tweaking slightly.  Will resend.

> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
> extensions/pknock/xt_pknock.c | 8 ++++++--
> 1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
> index 29016461db7a..fc488a46849a 100644
> --- a/extensions/pknock/xt_pknock.c
> +++ b/extensions/pknock/xt_pknock.c
> @@ -30,6 +30,10 @@
> #include "xt_pknock.h"
> #include "compat_xtables.h"
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 15, 0)
> +#define timer_delete(X) del_timer(X)
> +#endif
> +
> enum status {
> 	ST_INIT =3D 1,
> 	ST_MATCHING,
> @@ -296,7 +300,7 @@ static const struct proc_ops pknock_proc_ops =3D {
> static void update_rule_gc_timer(struct xt_pknock_rule *rule)
> {
> 	if (timer_pending(&rule-> timer))
> -		del_timer(&rule-> timer);
> +		timer_delete(&rule-> timer);
> 	rule-> timer.expires =3D jiffies + msecs_to_jiffies(gc_expir_time);
> 	add_timer(&rule-> timer);
> }
> @@ -517,7 +521,7 @@ remove_rule(struct xt_pknock_mtinfo *info)
> 		remove_proc_entry(info-> rule_name, pde);
> 	pr_debug("(D) rule deleted: %s.\n", rule-> rule_name);
> 	if (timer_pending(&rule-> timer))
> -		del_timer(&rule-> timer);
> +		timer_delete(&rule-> timer);
> 	list_del(&rule-> head);
> 	kfree(rule-> peer_head);
> 	kfree(rule);
> --=20
> 2.47.2
>
>

--p2kZ4Os337YQVW4E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJoOMWhCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmdHnR2MB104bwD05xzvcrukSB9Jc1S0mssFi0P3IQ4r
ZhYhBGwdtFNj70A3vVbVFymGrAq98QQNAABPSBAAznfLmgWMkAdv5+dGA220Zhgh
EmFmkNhxTMBjUyd4f0rOr6X5aN5NtxaznpPrW7V3+WCzW0I0dxuJ+MV3U7FMAHto
JquN+nj59z/RpcvOx/lK3ZgLvgE7F7OedhGFR11abL4sSuWGtAk9Om1M7CT05maX
FzdVg2Ou4vTFsJNLifG9Stu6ARWfqkuj6gm7fdKXFWtBRC6sJyumMMbsFPQK+/Xn
mJfkCf6ewOhuR0H5XiHwB5OFubUx2guTrL5Y/m8mtDsaqqlan32fPu/MVVvdzusU
tQctco0ellmOmCMKtmiyOJ2qJ3x+8LC3E2mhWZTS56J4ESLeqinWKU5mUxtuRQJp
3BGTFp3ZoopKCH6iv6khU2dieUWGue4q82RTnE1OT8X5qKXBw6gvGien3qhtT0PL
26RjV1DuReIN95MxRq5qqhUT2FoxNeVtdtADrpJdJuQviPFifN1S3RP+NAxeirck
HtH9t2/Wur0ZVepNfxgVCMWYCKi3I5Rawy0/3ixEmuMPioZvNFgFxyVViPPFVesg
+XGyk0AY7x/1pFxA6sY3k7KnQQKDEwTnIAd3CfTAMWy/+vN9C4p9RuVeqC1yE5Tx
7vIl/exvm06lkTgCQJ+BaDlXeYTXQ0+C3bKS++jrlN4v9fREygjnyUMRh4lOZ8dh
U8uUtIsTB0sQxKUpmYM=
=baKk
-----END PGP SIGNATURE-----

--p2kZ4Os337YQVW4E--
