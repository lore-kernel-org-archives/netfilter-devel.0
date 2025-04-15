Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCBF1D7E4A
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.77.79.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744726449; cv=none; b=gd6AVrgCQoT0Lf7l6trCB9wIrJI0rxR43Kam6Zey3ARUiNb4YspzMsy3KZYYMvWJEy6O22ZrbC2zaMAXRrCk9jpXfQmkcPAapSbm+RRXaZgbnJxHSOBLN9ridhhX5Ks9wgHMA1WUkOuiBBoY8RUo1BNqyy1YODvwmAn0iZliNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744726449; c=relaxed/simple;
	bh=bYkqmEGcBQHD1mY43pSlVAdYsvYudl7ucejvfO2nNug=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ksPyFKL4Fdp/F/FfiE3oAHXX9B6iOzR9dzpbO2RhmoENSD5awUtQuLNjyM9uYInEPqADlXNbShndR9STsXjZf/J+wpTZqGsmDvAwex71TOijc8zR2CaFr1ucUSS7D9DVm94yY1FUCZtvv90v/5PGuJB2dIQzWQyTnWK1xnaucPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=cPJqzZuY; arc=none smtp.client-ip=51.77.79.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="cPJqzZuY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1744726432; x=1744985632;
	bh=bYkqmEGcBQHD1mY43pSlVAdYsvYudl7ucejvfO2nNug=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=cPJqzZuYSLq/bZmKvzPGchJdgD8KC+9uz+Bs1Un7Tzy1MfiN4mpc6KL8LZekmiHSr
	 /2gLrdt0Rsa+mOWinzVjeCcvRjZjpfE0yzTZtRGEDolgkyEdFoaTuu+n1VwdJBv7cf
	 ShZrSatFpzA/KHTrJA+xN8ZZgcw8eK2PnmTXzIBx08itCq9MkJtTS3fyKUOUGwk5Fr
	 Vxv1ibPzbAwa/vZyewcNL2adE8c1tN8ydyR3BtAaqi5eZbnjPapis8He8tXPeccUz/
	 gzxQKBiWZYR+LTbftWXf3IwGfQ+Vz+YvQyOkpP6rLLjjFzb73tkFzQuqAPSFWGCVQF
	 xRm+l8BILHRzA==
Date: Tue, 15 Apr 2025 14:13:46 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: Are Palo Alto and Check Point Firewalls using netfilter iptables?
Message-ID: <3B9N9AvuovzViY865d-1WFTrY0qFdZbVVNejNthiBzLi5eNlPWf2hgoKfRpmQ5K1nc_KKDOEpThKnD1tOkhdCGWlygBB1X_jnFrSGtPpGM8=@protonmail.com>
Feedback-ID: 39510961:user:proton
X-Pm-Message-ID: 5f5e62f7fcf349a7fd1a8003fb61eda0735a45eb
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Subject: Are Palo Alto and Check Point Firewalls using netfilter iptables?

Good day from Singapore,

As far as I know, Palo Alto VM-Series Software Firewall 10.0.4 is based on =
CentOS Linux.

And Check Point Firewall R81.20 is based on Red Hat Enterprise Linux (RHEL)=
.

Are Palo Alto and Check Point Firewalls using netfilter iptables as the und=
erlying firewalling mechanism?

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individuals in Singapore
GIMP =3D Government-Induced Medical Problems
15 Apr 2025 Tuesday



