Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2619B4EFFDB
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614011; cv=none; b=lu9nl178PFQ6UZKuvjdpxyhUw9gmTlhMAc91v5SbcJ4hnZz6rcOzTSVaHde57ULP73C0DyT2cVqb0MnNJ0l8RxNZpXrmUNOzPX/1HyEKR+vsrqOafq2VmdVDETa9YtwRZ64MYA8sKOMuHNVcE8kN3Ypp7VF2TejFnpq1BgP7NZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614011; c=relaxed/simple;
	bh=7iaoIpWM/R3mg7wjVxK+k86hgohoY67cdqwYxn98cTk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXDU+Hcg3mxOa8X0V4GOVKVc+Rtc74zgHixF7EtiV9X53+IyXzf5tMIcq3VM4P27OVi3q3r2Z8fA6bRuthevvxtTToIXN2iqIv3iLIixk+xshC56IUxcXgtipVZRJJVElGggy2AFYCGOQ0j/lx/3uGzZfX11Tfnj5wGYVRQmkl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Um3r8M4n; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Um3r8M4n"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a006bb267eso5418895e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 09:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790614008; x=1791218808; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TApQB6o5GODK3Qy+KRwi/qdbHOm6PDL/Z9x3Ev6nyY4=;
        b=Um3r8M4nb9dcLRdAUFlnA2lRoBHHqswDpEHcMg+z6uwgDB1EzFN9uHAuS69w3IeRwC
         SBSAAUmOqWWxU2sF9ufyrC6GywUmCUMbxpA6ypZ91te/ByW21PRUou6bD06gtKk3XJQ0
         xodKGSeajhAPqHCnpAKj+nvJ70qvtXf8hOevwBv89q20KMDEin8FUdjBI3CVm4zxvZ8g
         qrfLb4SEFf1ieXCOJ8L5IRpjZ+rV8F2DazTk4FrCsEvUUrFnEdu4xz52g71A77zu/Nac
         zAA/O6sWGw5caCS9T3AHthhMH1DWU6hMXSiCkKHSVXThjgaZKFpd5sZsDk1oGf5627E/
         QWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790614008; x=1791218808;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TApQB6o5GODK3Qy+KRwi/qdbHOm6PDL/Z9x3Ev6nyY4=;
        b=O1BrxPC/TKINk3Fi5BMWAr1Urrg0MWFzNpLT/6XdkHYLY4YECnQRBC6fXu9yWvPuDe
         +IeKR7qfYtVLdjBxNN+eb9vd2qLaCGU9OrVcBiU9VnbyuNqts4Tc+S/Q+0KSYbX/CMtv
         dX1g73cOxj5hCU5DQRuxX8j+lSHLELeWUyM7INq6JIpsD2gcsX1GOr+xt2smxyPmMvGy
         IfU8UoN+5tzP325Ceq11L2DTG7wbrUPFAM/kQMhgSsBpABpVU1BfMBpY3xZ83TBdc3H5
         LSeihrWEzSiHDb/Ua413IeCcIXRXNNlXblaahrpYmN1Eb4ZZxUpwjrwUA2NwDjZt9T+X
         F/nw==
X-Forwarded-Encrypted: i=1; AKwUvBzGnInXavBsuPL4sK4cBaq/PP3OP/kc4J4WIVDrf7Ywao4yEe+M6uMwwCdfY1Y7tsRFhPEIUGC0840W6ciKuak=@vger.kernel.org
X-Gm-Message-State: AFuF++lvCE4nGsG35XAJ9FCyGV/jQ65xGbZTLOt13Gf0nrUVovPgIup4
	9Iwu16kNE2hoxC03wG63LTVelhHDWmdgM274X38ydgeBa0o6i4lQd3da
X-Gm-Gg: AYBFou0lDzoK9CiJUop2QnZjfNhTVP4xBQAksbxqm0xovBt/uJN+xUIYG8hFWiC3wWQ
	j0+IR7PWCtcTk9Usm93r7OrE8gIYZzawQsCVP0pg66PFK4lSwEozk5B1uzYbs8C5E4SHKpZyVfo
	FmVtbD2CbfU2jEEjG8/wHR7u7MScaMScfxU+APwYWjZH+4PP/OVrhn5kG50XvwX0igyMNM7eCvj
	WL62j7HNyDAEX+go8zYcdOubOCtxCMtBUegaCd4xwg32A0Ze5Yho8x95tCjkGsQXZ2FztX6FW5n
	nGL01UEalYwsPXbXdHAgW5C1J6i4E7HNOoak1nhUzgX3aYiZEnMrN8fWJ9AKNScr8aVa+JGV1lF
	xtpYUwHLogfNgTK6v3pYOsTYkNc6FDQJewkBal+ZkvLl8l2oQyrszGzlN+SjE5c+YF9uYUdcFqf
	lm807aqztOI8n2s652hekORUupuHMc8EjWZA3oULw69VpMOfdQ7CzgSAycKTSFHFeIskJloofrV
	/vZwvLlWvcNM4dBWe4Gj04aSqNiVJQJ5C3cjrsAS7/V1+qN0g0i4hY4YK0f0zl1NiQir6F9AGvb
	kOgR
X-Received: by 2002:a05:600c:8411:b0:49c:fc6e:a3da with SMTP id 5b1f17b1804b1-49fe66ef334mr228064375e9.25.1790614008214;
        Mon, 28 Sep 2026 09:46:48 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00d46ec56sm800965e9.2.2026.09.28.09.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 09:46:47 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: br_netfilter: restore VLAN tag on
 refragmented IPv6 packets
Date: Mon, 28 Sep 2026 18:46:42 +0200
Message-ID: <20260928164644.354396-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179061238760.31693.2318453255259270234@kernel.org>
References: <20260928161830.351199-1-parri.andrea@gmail.com>
 <179061238760.31693.2318453255259270234@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 04:19:47PM +0000, netdev-bot+sinfo@kernel.org wrote=
:=0D
> This is an automated message. This series looks like a fix, but its=0D
> commit messages seem to be missing some information:=0D
>=0D
>  - Whether the issue was actually triggered, or is only theoretical=0D
>    (e.g. found by code inspection). If it was triggered please include=0D
>    the symptoms, like the stack trace or error messages.=0D
=0D
The issue was triggered, not only found by code inspection. I=0D
reproduced it under virt-ng with a local test on a VLAN-aware bridge=0D
with br_netfilter and IPv6 conntrack defrag enabled. The test sends a=0D
fragmented IPv4 packet on one VLAN, then a fragmented IPv6 packet on=0D
another VLAN that the bridge floods to several ports. The test is=0D
available on request.=0D
=0D
Symptoms: with the patch not applied, the refragmented IPv6 packets=0D
leave the bridge with the wrong VLAN tag. This is the tag of the earlier=0D
IPv4 flow when both refragmentations run on the same CPU. Otherwise the=0D
packets go out untagged. There is no crash or warning; the only effect=0D
is the wrong or missing tag on the wire. With the patch applied, all the=0D
IPv6 fragments keep the correct VLAN tag.=0D
=0D
Thanks,=0D
  Andrea=0D
