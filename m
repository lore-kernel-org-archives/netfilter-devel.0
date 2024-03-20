Received: from amt.ru (msk-hq-mr1.amt.ru [212.233.68.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D3F3B185
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 11:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.233.68.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710932457; cv=none; b=QceNqZZ0iQxWId7/KpqXNd/mjaNKuRYXdCpxzf0kubFOiUsyxlC7+6tA7F2CpqUazU1H39w2N3iyGh3P37EIfWDVl3YNtlRndUERt1VO+/VkNlYb2BuxlwptaYCpeXV1Mz/IinOBNeMKbGLq7xpnYQGN5kJ909tXyZWSbLP3V+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710932457; c=relaxed/simple;
	bh=lJIHsWLqMl4KWydzixoLeWLXnQELiPonm2DPKkjJVlE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qQID2VPLQtTgfmmI3eUm8n618QTpUUjBYQTrBOuHFWXAdmdTH7lCoG9vWRCck2YCgtvet+CoaFc76mcKnbTzncEf9e9ZTMrwNAep0W2YtMAQaElyY+Fj57jwwinef1CzCfmZncHWpm41wRTUKrYhsrANXhMWVtPTLdu5eGceTUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=amt.ru; spf=pass smtp.mailfrom=amt.ru; arc=none smtp.client-ip=212.233.68.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=amt.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amt.ru
Received: from Internal Mail-Server by msk-hq-mr1 (envelope-from esagatov@amt.ru)
	with SMTP; 20 Mar 2024 14:00:34 +0300
From: "Sagatov, Evgeniy" <esagatov@amt.ru>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: xtables-addons RAWDNAT bug
Thread-Topic: xtables-addons RAWDNAT bug
Thread-Index: Adp6tZeLFNUXTNQ7TeODl+CUYwKnHQ==
Date: Wed, 20 Mar 2024 11:00:47 +0000
Message-ID: <cbed66aa10f243278a8449c59f27eb44@amt.ru>
Accept-Language: en-US
Content-Language: ru-RU
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello.
=20
I found a bug and want to add it to bugzilla, but I don't have an account.
I requested the creation of an account via bugzilla-account@netfilter.org, =
but did not receive a response.
=20
After commit "libxtables: Unexport init_extensions*() declarations" (ef1089=
43f69a6e20533d58823740d3f0534ea8ec) in iptables, the module RAWDNAT from th=
e xtables-addons stopped working propertly.
=20
command line:
iptables -t raw -A PREROUTING-TUNNELING-UDP -p udp -s 0.0.0.0/0 -d 10.0.0.1=
/1234 --dport 4567:4567 -j RAWDNAT --to-destination 192.168.1.2:4567
=20
stdout:
iptables v1.8.8 (legacy): unknown option "--to-destination"
Try `iptables -h' or 'iptables --help' for more information.
=20
exit code:
2
=20
----
Sincerely, Evgeny Sagatov
