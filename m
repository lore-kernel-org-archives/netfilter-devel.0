Received: from libra.cs.put.poznan.pl (libra.cs.put.poznan.pl [150.254.30.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CED3FB077
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.254.30.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785157885; cv=none; b=KjSMYyuf5am8g4im9p/juagGaK3X7vntTzkdJsKJkFLaiofOts+AQwvgnuMBNCIYY/63f0jVIs7xwJg4yqFBnxOyLPojedJ3Jmhs0SgV1KSuoprmSlO2peAi9Ullv2Ugc28fWO0PHU0wQI5v4jhdegIF5N/QEdGaWirJ2dUD0fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785157885; c=relaxed/simple;
	bh=Tg+ajY187rqHQDVaYpky8w53YjPWBGqWIbDBPzQOqoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRvmDrfNG+YXzji6UyVCPM3Es4QjDBtqPRI6blLwV6cR69nhodETAA/OyyBxvxx2StWEwYtzimckGH7LMldWDlVcjMcIIotI6l9FiMc7zIj7by8N4Sng6sn9n2cfXNgUJY2k1/gBSEa6icqIH9AVfXhMK0bsFN8KwGqZ1Xutiw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl; spf=pass smtp.mailfrom=cs.put.poznan.pl; dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b=iMPilUiF; arc=none smtp.client-ip=150.254.30.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.put.poznan.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.put.poznan.pl header.i=@cs.put.poznan.pl header.b="iMPilUiF"
X-Virus-Scanned: Debian amavis at cs.put.poznan.pl
Received: from libra.cs.put.poznan.pl ([150.254.30.30])
 by localhost (meduza.cs.put.poznan.pl [150.254.30.40]) (amavis, port 10024)
 with ESMTP id DSaOUVD6l-p7; Mon, 27 Jul 2026 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.put.poznan.pl;
	s=7168384; t=1785156477;
	bh=Tg+ajY187rqHQDVaYpky8w53YjPWBGqWIbDBPzQOqoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMPilUiFlPfOfbplU0+RrddwgM3YO0W/4ZG9cE1SCfDI+IvIlhHvlSWEePUALcl4L
	 9BUMteuV/IwlYfpsBCRfb3j89kyFFmdAbPD2tLLYaQSWtLiAHYAFK6AjfcZr40tGBP
	 11G50/M5i1j6RCjSPqZGCszj8xCJ+/kigM5JKg3dgiGjuorxxpxnNjcbB98i8tISF2
	 VvRTUEG2zzOGi1ZJLtcrDyxSM3lz7EE4oXeJHoHEorfzChUEIKOQfN55F7qu7dZD0V
	 sAqtXMtoyU4C/tL9l/vqolAG6BrmhOzDtmTTc0uF10ygo0+FLgVampmK/UYodMtKKl
	 +u1Tri6Swdbhw==
Received: from imladris.localnet (83.8.81.20.ipv4.supernova.orange.pl [83.8.81.20])
	(Authenticated sender: jkonczak@libra.cs.put.poznan.pl)
	by libra.cs.put.poznan.pl (Postfix on VMS) with ESMTPSA id 0816063748;
	Mon, 27 Jul 2026 15:02:07 +0200 (CEST)
From: Jan =?UTF-8?B?S2/FhGN6YWs=?= <jan.konczak@cs.put.poznan.pl>
To: Eric Garver <eric@garver.life>
Cc: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_bison: Fix for bison < 3.6
Date: Mon, 27 Jul 2026 15:02:02 +0200
Message-ID: <2756315.9Mp67QZiUf@imladris>
Organization: Institute of Computing Science,
 =?UTF-8?B?UG96bmHFhA==?= University of Technology
In-Reply-To: <amdMsU0e0JDYYXkD@egarver-mac.redhat.corp>
References:
 <20260611125231.652353-1-phil@nwl.cc> <amHoSglXwfNia7V7@orbyte.nwl.cc>
 <amdMsU0e0JDYYXkD@egarver-mac.redhat.corp>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

I guess the right way is to add 'autoconf-archive' package to build
dependencies - it ships the missing file. Hopefully adding this as
a dependency won't be a big issue.


On poniedzia=C5=82ek, 27 lipca 2026 14:18 Eric Garver wrote:
> Hey Phil,
>=20
> I see a configure failure after this change [1] on ubuntu-24.04.
>=20
>   ./configure: line 5247: syntax error near unexpected token `3.6,'
>   ./configure: line 5247: `			AX_PROG_BISON_VERSION(3.6,'
>   Error: Process completed with exit code 2.
>=20
> Does ax_prog_bison_version.m4 need to be added to the m4 directory?
>=20
> Thanks.
> E.
>=20
> [1]:
> https://github.com/firewalld/firewalld/actions/runs/30020547439/job/89969=
65
> 4992


