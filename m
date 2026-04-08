Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10AF33CEA8;
	Wed,  8 Apr 2026 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775661536; cv=none; b=YIDqanZrVvQ9lKC7T1+Fas+O/MvGd14zjpMkvCCX0e7LSje0UIY9zk6pPb6REhPuEjviKz+KX2m3ZET0m/pdbcK2P0Azujz+la2j3mqj0hR0s+JpyrnoNr7RNg9uxp19g60hUEltBLkL234oT9U6+tkxHga3jJHVAwivD0Abadk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775661536; c=relaxed/simple;
	bh=K0smtATRRlPhzZC/f2FuIGBbZSELomfitHg/FX7/F+c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iEO/y9+6ejXZVaGCFO8haC0YEsA72V0c4lpaJJlMixkC2GaNgYG0N4sZ5wMzjKjUqqgX9gaZ8xGBeCvVEiu18ACdbDwM9LI0qYC6vpqUu/pp2MdvvSOw+zg9c0ERRt8/VitzKZfBugCoz6pN6kRiuK9r4J1v326pYY457tTYw4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VW/ctqfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VW/ctqfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AAAC19421;
	Wed,  8 Apr 2026 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775661536;
	bh=K0smtATRRlPhzZC/f2FuIGBbZSELomfitHg/FX7/F+c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VW/ctqfWbUrk670cLw5GbIb5IloiAdZviNrvkFPmmqRL6p6+EHv5DTHowzQ3ovPHw
	 aRyqchU1bT7LNV6SxiCzsNRrDzSIksRADxnKGdFnxZu5htqCFFWMc5u4QUutAHEU1e
	 bbeMUvdRBC/OUqesuEbPWcgFzb7v3IPc6PFqJ5FWwDz5RC8ZiqmsiYY+EOitBJtd7e
	 +CqsG0M1uIUi6yhv0paoxwNL2WB4EdiwtIPK93Jo3LVqSamcT+azpoKYqcMOBSsiMo
	 dcSjPFgJA5WWka/2nOwZ8pzHBEmYJXn6Y5bhs6DwVHhWS5jUB27L4TVtnPgc+wdJD+
	 nz239NiXc2oxw==
From: Thomas Gleixner <tglx@kernel.org>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>, Stephen
 Boyd <sboyd@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
In-Reply-To: <20260408155353-42aeefa4-db66-48aa-ab07-0538a8cfdbf0@linutronix.de>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <20260408143313-ac6c3b82-70e6-4ce3-b33a-20f5e6ba160b@linutronix.de>
 <20260408155353-42aeefa4-db66-48aa-ab07-0538a8cfdbf0@linutronix.de>
Date: Wed, 08 Apr 2026 17:18:52 +0200
Message-ID: <87zf3d32g3.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 08 2026 at 15:55, Thomas Wei=C3=9Fschuh wrote:
> On Wed, Apr 08, 2026 at 02:41:20PM +0200, Thomas Wei=C3=9Fschuh wrote:
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -369,7 +369,7 @@ int clockevents_program_event(struct clock_event_devi=
ce *dev, ktime_t expires, b
>         if (dev->next_event_forced)
>                 return 0;
>=20=20
> -       if (dev->set_next_event(dev->min_delta_ticks, dev)) {
> +       if (dev->set_next_event(dev->min_delta_ns, dev)) {

That's wrong as the callback expects cycles (ticks) not nanoseconds.

I've just pushed out an updated version to tip timers/urgent which
addresses a potentially related issue. Delta patch below.

Thanks,

        tglx
---
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -324,6 +324,8 @@ int clockevents_program_event(struct clo
 		return dev->set_next_ktime(expires, dev);
=20
 	delta =3D ktime_to_ns(ktime_sub(expires, ktime_get()));
+	if (delta <=3D 0 && !force)
+		return -ETIME;
=20
 	if (delta > (int64_t)dev->min_delta_ns) {
 		delta =3D min(delta, (int64_t) dev->max_delta_ns);
