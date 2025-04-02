Received: from mail.mailboxbox.com (mail.mailboxbox.com [54.38.240.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09970236456
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.38.240.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743583091; cv=none; b=XZXN/6s1TcNcxQ+7ZjqhBEaJ9L3EirAV7MamRiElXg99bA2NVyXGR3bZ4MA8kVdpT/Ounh++qWBGdXZUgbK3RmUMb5+TtM1mH/v6Jb/Df7kZhET04Kpacjgm0S0max1dWarP1TA5ooaW3inOB5yVIS5ISyNr5PIkrwhJDPiGizE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743583091; c=relaxed/simple;
	bh=fYnr4ODCSdfju7a4DySLcAMpP8spxYuTZNqIZ5BmvGg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PIAYgSBk6jU539OJfhYYk2l0tJ1vrCm6yaqLJTzJ1EbUeWcRY5aa3blFtGIIiNjX+HmDEHYhFN6iD45vFP2eRAucXCDqwpjjLOBypY4w/ZeT+JV2CeKB2tCwNdLtFr2rG+eq1bdqnS0KsMfGt6fEBKS19xcOnr/h9dBIycQHjYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=connectedserver.com; spf=pass smtp.mailfrom=connectedserver.com; arc=none smtp.client-ip=54.38.240.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=connectedserver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connectedserver.com
Received: from mail.mailboxbox.com (localhost [127.0.0.1])
	by mail.mailboxbox.com (Postfix) with ESMTP id 9B6C82477
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 10:37:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mail.mailboxbox.com
X-Spam-Flag: NO
X-Spam-Score: -0.999
X-Spam-Level:
Received: from mail.mailboxbox.com ([127.0.0.1])
 by mail.mailboxbox.com (mail.mailboxbox.com [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id r4bF5ntws-nX for <netfilter-devel@vger.kernel.org>;
 Wed,  2 Apr 2025 10:37:55 +0200 (CEST)
Received: from smtpclient.apple (unknown [188.90.125.33])
	by mail.mailboxbox.com (Postfix) with ESMTPSA id 5188476E;
	Wed,  2 Apr 2025 10:37:54 +0200 (CEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: IPSET create exists issue
From: Rob Bloemers <rob@connectedserver.com>
In-Reply-To: <57adf6c3-4038-f1fe-2472-241a351ae837@netfilter.org>
Date: Wed, 2 Apr 2025 10:37:44 +0200
Cc: netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7CCC12C1-A1B8-454F-8690-B37A3219DC8C@connectedserver.com>
References: <184E283D-2392-476C-B23A-9939FE71CA34@connectedserver.com>
 <57adf6c3-4038-f1fe-2472-241a351ae837@netfilter.org>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

Hi Jozsef,

Thanks for your reply again, you were correct the definition was =
changed, not exactly the same. The stored value missed the timeout=20

Kind Regards
Rob Bloemers


> On 26 Mar 2025, at 12:24, Jozsef Kadlecsik <kadlec@netfilter.org> =
wrote:
>=20
> Hi,
>=20
> On Wed, 26 Mar 2025, Rob Bloemers wrote:
>=20
>> Hope this is the correct list to email, else I=E2=80=99m eager to =
hear which=20
>> route to take.
>>=20
>> Using netfilter-persistent package on ubuntu an iptables restart =
gives=20
>> error when reloading iptables and a ipset already exists. Afaics =
-exist=20
>> ought to work, but it still returns error code 1 and systemctl =
perceives=20
>> this as an error.
>>=20
>> /usr/share/netfilter-persistent/plugins.d/10-ipset start
>>=20
>> Which runs: ipset restore -exist < /etc/iptables/ipset=20
>> Still returns: ipset v7.15: Error in line 1: Set cannot be created: =
set=20
>> with the same name already exists
>>=20
>> ipset restore -exist < /etc/iptables/ipsets                           =
                                  =20
>> ipset v7.15: Error in line 1: Set cannot be created: set with the =
same=20
>> name already exists
>>=20
>> ipset create -exist vxs hash:ip family inet hashsize 1024 maxelem =
65536=20
>> bucketsize 12 initval 0x9bb42fcc
>> ipset v7.15: Set cannot be created: set with the same name already=20
>> exists
>=20
> What is the definition of the already existing set? If it differs from =
the=20
> one above, then the command fails even with the -exist flag specified: =
the=20
> set definitions must be identical.
>=20
> Best regards,
> Jozsef
> --=20
> E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, =
kadlecsik.jozsef@wigner.hu
> Address: Wigner Research Centre for Physics
>         H-1525 Budapest 114, POB. 49, Hungary


