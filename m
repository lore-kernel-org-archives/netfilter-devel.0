Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF691185920
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742988603; cv=none; b=VCbcCXggXtkNG098ZElnTts1sqrdrrF+S5cq8728LaOpTMEkHP9KfaybVGiKw0jdRG3uC3xZ4a9S4A5RoKmZ6zd7tjFt9bQTdW7U/Gdhi1ux7/uhwHJb7RRIS21ShK0mU7KU3NqjbsbJ2MvzRTj18irOOWU8S9vxBkwNkDjJSRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742988603; c=relaxed/simple;
	bh=QQuLJExrTd8/JIDDGFTAKx1lK55wYNWtoodvsEOLaYA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LgMCFaCYnqrS+77z+wrKqkqSfincK1rsOn8xq3s64c6oTqDuevAu0pclnOtGAgHG1/bqlRbaO6PKiLXHV7hFAS3odHXKUWhMnNwctTAAiCo3FGjQDwHub2roRikdWvb42xyH7VZO1dlP8QGxNS11g/5LNm3OFZDU5wajZtW2QPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id DD7515C001D5;
	Wed, 26 Mar 2025 12:24:16 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 5KjXopGwqtMZ; Wed, 26 Mar 2025 12:24:15 +0100 (CET)
Received: from mentat.rmki.kfki.hu (77-234-80-150.pool.digikabel.hu [77.234.80.150])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id DDA505C001D3;
	Wed, 26 Mar 2025 12:24:14 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 959E214222E; Wed, 26 Mar 2025 12:24:14 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 914C4140783;
	Wed, 26 Mar 2025 12:24:14 +0100 (CET)
Date: Wed, 26 Mar 2025 12:24:14 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Rob Bloemers <rob@connectedserver.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: IPSET create exists issue
In-Reply-To: <184E283D-2392-476C-B23A-9939FE71CA34@connectedserver.com>
Message-ID: <57adf6c3-4038-f1fe-2472-241a351ae837@netfilter.org>
References: <184E283D-2392-476C-B23A-9939FE71CA34@connectedserver.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1500205670-1742988254=:20381"
X-deepspam: dunno 31%

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1500205670-1742988254=:20381
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 26 Mar 2025, Rob Bloemers wrote:

> Hope this is the correct list to email, else I=E2=80=99m eager to hear =
which=20
> route to take.
>=20
> Using netfilter-persistent package on ubuntu an iptables restart gives=20
> error when reloading iptables and a ipset already exists. Afaics -exist=
=20
> ought to work, but it still returns error code 1 and systemctl perceive=
s=20
> this as an error.
>=20
> /usr/share/netfilter-persistent/plugins.d/10-ipset start
>=20
> Which runs: ipset restore -exist < /etc/iptables/ipset=20
> Still returns: ipset v7.15: Error in line 1: Set cannot be created: set=
=20
> with the same name already exists
>=20
> ipset restore -exist < /etc/iptables/ipsets                            =
                                 =20
> ipset v7.15: Error in line 1: Set cannot be created: set with the same=20
> name already exists
>=20
> ipset create -exist vxs hash:ip family inet hashsize 1024 maxelem 65536=
=20
> bucketsize 12 initval 0x9bb42fcc
> ipset v7.15: Set cannot be created: set with the same name already=20
> exists

What is the definition of the already existing set? If it differs from th=
e=20
one above, then the command fails even with the -exist flag specified: th=
e=20
set definitions must be identical.

Best regards,
Jozsef
--=20
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef=
@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
--8323329-1500205670-1742988254=:20381--
