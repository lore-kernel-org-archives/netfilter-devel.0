Received: from earwig.ash.relay.mailchannels.net (earwig.ash.relay.mailchannels.net [23.83.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892201E5206
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752776; cv=pass; b=bH9I5CVzMnW9D8xMfiqWR52CFk7wMe0avPswM0iZHfSfrwdWQiNveiZUzzrgU+tfw8Sc6NB/m6+qWt26dCB0UuR5X4TaLNdsNiyc7ni7iKcPE+u6IOznE8CtdcrnmdOJ2N2LD6S3K8XMrxzb7B58D3VCmDS9aI2ZhaQXu1BFSL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752776; c=relaxed/simple;
	bh=LfHyMzwBlQRi8HQanbkrQdYLCySy10E1S3KrGw3phgw=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=VtnVQNFqCX0tGw96HDLNK3hd7IH2ueiZFLH1h868OMBCcj9sW2MrcjH1vJAh+y+2PQL9pKu5OtM60xMvZ5zQLYDGXrBA0q8gz+LVypThx1U44w2lYatSDUF0s9aP/uKHrfGMqChH8DCTV7nSy8aTRxdCumOC5gKeT8tmeObFt+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id BB4FB8E1B5F;
	Wed, 24 Sep 2025 21:48:22 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-6.trex.outbound.svc.cluster.local [100.109.34.94])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 08E1A8E1D42
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 21:48:21 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758750502; a=rsa-sha256;
	cv=none;
	b=wS+zNI2Uy0g/f96OOEauAyCnmh8Yde38U+FK4QwhrIqSytUxUWsFNeRxafGJCV0Q+rDbHN
	jD7CbnMyQ6HVNwZuf/sWqByOulO0rq2MCnV4ciAAqKuYnvBFLU0fXAT4eRuGXAHe4V52Pl
	iCetlggpfG6KcHW1OjXM/K2vMH3mfms9VRs8AviDmfX5QY47pfnsWxws/S8HdoPgCKycNL
	3j57cGEpiMsR5U+Q4f3r1h8f/Uj4oFXWT/4oZwBiQa1Hu8H0FL7va7NBnKj51soLpbMUI8
	Ct9Z1yRkQBq6SHIKrplaqjsWWN1vAXCsOD8uSCTb9V9hX5+HwMnQoIRpBPSw8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758750502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ngbmeMsG6QAzafLvkiyJ3mOgwhbPScZZjjV0J7XKGn4=;
	b=w/S5eUTbBTwf6liJMjgDstHe01jYEtPRc2lxBVfXv7O0Z7g5UE1cv4wKpmClkkULsCc/3w
	I7xfE5urA0FGGmRw8NU/Dkaz6bs3qLd3D/lVg10T8IcrZzmZocVXoMmRXmnavmjRSqsHws
	UlovNMWd0IXbw3WMAK1o/0T4DgTLDpcMaL5sJ4xFyC+EVZOPsRhnvtnrhRlp/lupQNv3Fs
	4hkKz1Y1J/C/No+QIvTBi3RPXuCmA4HoNuxpE4mr8LaO1/u73jfrAzQbwbqMyk5tFxgZrF
	GqFVpIlo0xzoGmeWrieZIYcEw3MAQDubnHAQkh/vf8x/jS++FXCc765RRfR+VA==
ARC-Authentication-Results: i=1;
	rspamd-b66946488-x9tgd;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Shoe-Tart: 770e3049528fb3f0_1758750502542_3941152151
X-MC-Loop-Signature: 1758750502542:1920241618
X-MC-Ingress-Time: 1758750502542
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.34.94 (trex/7.1.3);
	Wed, 24 Sep 2025 21:48:22 +0000
Received: from [79.127.207.171] (port=45580 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1XLa-00000004GGZ-0jXi
	for netfilter-devel@vger.kernel.org;
	Wed, 24 Sep 2025 21:48:20 +0000
Message-ID: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
Subject: bug: nft -n still shows "resolved" values for iif and oif
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: netfilter-devel@vger.kernel.org
Date: Wed, 24 Sep 2025 23:48:19 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey.

E.g.:
# nft list ruleset
table inet filter {
	chain input {
		type filter hook input priority filter; policy drop;
		ct state { established, related } accept
		iif "eth0" accept
	}
}
#  nft -n list ruleset
table inet filter {
	chain input {
		type filter hook input priority 0; policy drop;
		ct state { 0x2, 0x4 } accept
		iif "eth0" accept
	}
}


IMO especially for iif/oif, which hardcode the iface ID rather than
name, it would IMO be rather important to show the real value (that is
the ID) and not the resolved one... so that users aren't tricked into
some false sense (when they should actually use [io]ifname.

Maybe one could however always resolv it for lo, if that is truly
always ID 1, as I've been told.


Thanks,
Chris.


[0] https://lore.kernel.org/netfilter/aNPhP63SyX2ofE92@strlen.de/T/#m15841d=
b7bf5bb588483fdd3576d70af7a71f5555
