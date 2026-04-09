Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3DD261B8D;
	Thu,  9 Apr 2026 19:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775762541; cv=pass; b=NoGOE8m1aD0kAAG0vRLfIDj6OjFF1dZvC12OAP+IQsW4A2wgxeCybalb1/if+MEJyTPbkIRnytHGXIjmNWAMXgpYHNEiD0VMfJ+L0/1s2R9GXbyPLqi5gMEz9lHXDrQTgAh2j00dSWZXNblRp+P9ADfhhcK/EWaGHgWcIIyXAkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775762541; c=relaxed/simple;
	bh=ABg8sJ+/UIG+zaHTF8FE4V2Q8CfCjtoq7FfLessYPIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDQubcoe6SHVJMlkMKkrxcrXCWB6fms36HoRn6IPivpEJHNbsjsIM5vtwjVF/U4yDtc4qQxqL1n0SdjDEkiGaYGB3MREmKhTmzZR5/Pm0kRDzcYQcDvn5vWtXeTA0AjQd6+0ZbhKvH5jgOjDxAGWAWxqr8C9fpA8ibJnz5SRs9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b=AUAa/L3+; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b="AUAa/L3+"
ARC-Seal: i=1; a=rsa-sha256; t=1775762463; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=LQlkhaNjyUWKbfUI20z4Sf3YS1KXPL7jIOiTz9QQebt+/5alABNaXgzyknVE0jXSnulby0iELWugUFszjHTtlJAiAu2XyP9z3N04j9ynaHH5XoFoFxtLKE0jiRtIoPVxaWEVrGyQXtiF0hkGtvLBzx0FKM7iVd9MbRqe9rFNuxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775762463; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=F3Si1X1PgfNUXsdrfdhmzDQHbKwjXj53THXSeknqpyA=; 
	b=LPS7I3lOkF4ABWJNXHjlKfo/6IkuMA20YSQPMs692qQJKYfxqk28xUkElvEmLgdpeimhqC3DoHYFsjiHqpJ27GPJyCiaODVsxC5cqgMe0hPfI4GwsGDg4iRuxK4bxQHuaZ/wUYmij2f/Yw/ONiMz4zjJ0ZagsmFYKLXYYue3L3k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=sebastian.reichel@collabora.com;
	dmarc=pass header.from=<sebastian.reichel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775762463;
	s=zohomail; d=collabora.com; i=sebastian.reichel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=F3Si1X1PgfNUXsdrfdhmzDQHbKwjXj53THXSeknqpyA=;
	b=AUAa/L3+2lwVCL2ZUfTY1LNdK91B6s8tQ5VeIrMtAQqAlMwE3MmmyWcWyy6p2VkA
	3IUgm2n8XHb5tSjzFDzvnXYsIxyoPcDV6hZBRg74n1V6qVPnKT3yHQ0EWte9RuGdrs/
	fuorKCbCwIr7tGLCtnF9xpeN4Q4XRD+Q+LOa3cm8=
Received: by mx.zohomail.com with SMTPS id 177576246039850.8603406281004;
	Thu, 9 Apr 2026 12:21:00 -0700 (PDT)
Received: by venus (Postfix, from userid 1000)
	id 2ACC9180E60; Thu, 09 Apr 2026 21:20:55 +0200 (CEST)
Date: Thu, 9 Apr 2026 21:20:55 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, 
	Calvin Owens <calvin@wbinvd.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Frederic Weisbecker <frederic@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Subject: Re: [patch V2 09/11] power: supply: charger-manager: Switch to
 alarm_start_timer()
Message-ID: <adf72vL5dCapChax@venus>
References: <20260408102356.783133335@kernel.org>
 <20260408114952.536945376@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wmsijnsatuforoie"
Content-Disposition: inline
In-Reply-To: <20260408114952.536945376@kernel.org>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.2.1.5.2/275.753.7
X-ZohoMailClient: External


--wmsijnsatuforoie
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [patch V2 09/11] power: supply: charger-manager: Switch to
 alarm_start_timer()
MIME-Version: 1.0

Hi,

On Wed, Apr 08, 2026 at 01:54:24PM +0200, Thomas Gleixner wrote:
> The existing alarm_start() interface is replaced with the new
> alarm_start_timer() mechanism, which does not longer queue an already
> expired timer and returns the state. Adjust the code to utilize this.
>=20
> No functional change intended.
>=20
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: linux-pm@vger.kernel.org
> ---
> V2: Rename to alarm_start_timer()
> ---

Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Greetings,

-- Sebastian

>  drivers/power/supply/charger-manager.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> --- a/drivers/power/supply/charger-manager.c
> +++ b/drivers/power/supply/charger-manager.c
> @@ -881,7 +881,7 @@ static bool cm_setup_timer(void)
>  	mutex_unlock(&cm_list_mtx);
> =20
>  	if (timer_req && cm_timer) {
> -		ktime_t now, add;
> +		ktime_t exp;
> =20
>  		/*
>  		 * Set alarm with the polling interval (wakeup_ms)
> @@ -893,14 +893,16 @@ static bool cm_setup_timer(void)
> =20
>  		pr_info("Charger Manager wakeup timer: %u ms\n", wakeup_ms);
> =20
> -		now =3D ktime_get_boottime();
> -		add =3D ktime_set(wakeup_ms / MSEC_PER_SEC,
> +		exp =3D ktime_set(wakeup_ms / MSEC_PER_SEC,
>  				(wakeup_ms % MSEC_PER_SEC) * NSEC_PER_MSEC);
> -		alarm_start(cm_timer, ktime_add(now, add));
> =20
>  		cm_suspend_duration_ms =3D wakeup_ms;
> =20
> -		return true;
> +		/*
> +		 * The timer should always be queued as the timeout is at least
> +		 * two seconds out. Handle it correctly nevertheless.
> +		 */
> +		return alarm_start_timer(cm_timer, exp, true);
>  	}
>  	return false;
>  }
>=20

--wmsijnsatuforoie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmnX/BMACgkQ2O7X88g7
+ppCgQ//Xp8a07UKClRacIo2ssfPxtLLDokFqQogI/X3wdIBPG7TzC4up3u6iOpW
QL/v5Ei9zpO1frj1LZsqyHNoUFccdjnXa8aJLB98SI0n1fCb7ffbrrCX7GVhr0WD
AmfPILOLWqL4Qnw6UH1xRrJGE9ovffSK41qGIFCa3q6fDySJFf/VAjgpusxS02zO
1KhGRmzAfsQZ4tPTsoBpUIDoRPip9x2lMZ1amfNRPHjPgqPv9h9lAvWhcKFHaOkH
6xO4bKJnCN3liD4Jl5wGLN3lv1u2bOOB+JfjxhVobrgyNR1N07GdfOug5O9czi4X
KOmcuiv2o0i+xae9lgOO0q6QwbW+hjCJI10AfU9lzzXHJotL0U49unBeOGUME5OK
Oxg1Ls6EUd37jOceN3sV6vi3FvASZUC1aZbRK7qR9Y/fdI2Vkf1ekCnkRHkJ7wve
XEL+28UxEH6NZcfmJ4aHlMAFcSApQakDW9D8pKiGxZHw3W16Jt3AGDNgaReLbJqY
jzAxbxKhn97GnGADeLNm6XNiO9yiano/1fHVlzk28E6otD9/kNcGVQhITEHNTiLl
OWkjFBapyzwofoXJfFmrsB/8ume7hzcdnSIjeBLWQvMJyKB1ykFuQqCeZViRLrhS
RG2ROUORryKiQwoVDt2saF56FLbq9zsNy1bpPxHjKdlGMF8AYL0=
=crXt
-----END PGP SIGNATURE-----

--wmsijnsatuforoie--
