Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403B528F4
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 20:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.253
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746477; cv=pass; b=bmfab7tzZzePUuymvB7IXvxuG79YvAVDCmiQRSbN3/6DlYJHvdM8YFAgXaLP9EeB2+ThaSSH6MrnK+8q9CoN6iV8mJl1ClAIxVxWEORbxwUymtSduraPqqJG8U+WNlIFeiwQEkYUEXQjF3RH+QIBCfTfTjDnxQ+JhIAn0shYY78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746477; c=relaxed/simple;
	bh=wStOjWciL/Kun2luTkB5vWpZcw/Fu4pWOmYDnDLAtU4=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=EnJ4v39DiqGNzESyoeP8cwIl0k6PL0S+wYDmktkkVcaee60TbdUiWvMTfgnF3rcSWlhc5ezlw32aHJ27H0q59ZkQ8yplRFEbecviEIyLkAjjL9nlvspGnXRt/y7GeQ1z7/FHhbd4jEcOcsrYL8BdmVaV6dBTjOZIQQlcUTExpVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 88A853A27DC
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 20:23:15 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-108-153-55.trex-nlb.outbound.svc.cluster.local [100.108.153.55])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9A1173A274F
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2025 20:23:14 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758745394; a=rsa-sha256;
	cv=none;
	b=LmhMh0uVPkjvzLOwPGzSZyG01QGwhTklbX3beZJDwUJQp7J0PC6OCQ4tuMlko/PGFLn+i1
	8krceR0CpJkw6wi8LNax0OYziaRuJ880Oqj5lOZil+T3jxT09z0fEdv2zbervBaBsTcRzf
	jBdLQ2FkfuGEljUiKZ7juzdHjSzJqdj7lPWkI+uv9Im+N399Icxk/JYtkCU8ux2Io5HdTe
	BZHygH8QwI9Ns3Av/SqyOlkGCkaNJv2LmBR14Kdhh89zJYjZ/Sferdbl4ggBckooDfqtrb
	b1RngpTwcksYneopKfrVmOEHQ5QlKR+HjiqKcb33bUI8eGqwS4O0+/92cWyYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758745394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gv+c3RjDn6ceUGr43VoSOg0dGZtNQ48HhxeTb7u6HUE=;
	b=xr4iZTW1RpeyFoZ0twhgnCHuJgkHyiJmTjLuQaDlcssJqzQh4RLZZpP46lzsEM/Ti2aKSW
	SWdyoAyf90yOEx/G2ulcsYwsJw1JD5HDt3+hswJ+ObVqxweWSXVh6t+a8dPfeSJdy5D2hB
	7J9iNQB4qFIaCJp7Cnho1Z/6iGjmAFDPIT0aun6m3sHUgiqEjfyrwXn5clyBF0JwHETZ3X
	QuwVFBFmvZ9j0m69OGCnTmzev2hXII78Mghxhnw5zBggR3zUFv1KMUH+CvqbNgruZi0/8E
	otzCiHg7l8xn2zIP+/LZ78es978qBTbCviccVCnXhtLSClfz2GiU+DeUku2VLw==
ARC-Authentication-Results: i=1;
	rspamd-55b8bfbc7f-6jb8l;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Shrill-Lyrical: 49055d7b7cd7dbee_1758745395148_1417285753
X-MC-Loop-Signature: 1758745395147:1088057639
X-MC-Ingress-Time: 1758745395147
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.153.55 (trex/7.1.3);
	Wed, 24 Sep 2025 20:23:15 +0000
Received: from [79.127.207.171] (port=1664 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1W1C-00000003RbU-3oVz
	for netfilter-devel@vger.kernel.org;
	Wed, 24 Sep 2025 20:23:12 +0000
Message-ID: <500beefd7481a43c4068469300e07ca3769a064e.camel@scientia.org>
Subject: bug: nft include with includedir path with globs loads files twice
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: netfilter-devel@vger.kernel.org
Date: Wed, 24 Sep 2025 22:23:11 +0200
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

With:
   # nft -v
   nftables v1.1.5 (Commodore Bullmoose #6)
from Debian sid which uses a default include dir of:
   # nft -h | grep includepath
     -I, --includepath <directory>   Add <directory> to the paths searched =
for include files. Default is: /etc


And e.g.:
/etc/nftables.conf
   #!/usr/sbin/nft -f
  =20
   flush ruleset
  =20
   table inet filter {
   	chain input {
   		type filter hook input priority filter
   		ct state {established,related} accept
   	}
   }
  =20
   include "nftables/rules.d/*.nft"

and:
/etc/nftables/rules.d/x.nft:
   table inet filter {
           chain bla {
                   type filter hook input priority filter
                   ip daddr 1.1.1.1 drop
           }
   }
and no other files in rules.d... nft seem to somehow include x.nft
twice:

# nft -f /etc/nftables.conf; nft list ruleset
table inet filter {
	chain input {
		type filter hook input priority filter; policy accept;
		ct state { established, related } accept
	}

	chain bla {
		type filter hook input priority filter; policy accept;
		ip daddr 1.1.1.1 drop
		ip daddr 1.1.1.1 drop
	}
}

If I change the include to "nftables/rules.d/x.nft" or to
"/etc/nftables/rules.d/*.nft"... it works (i.e. only one ip daddr
1.1.1.1 drop).


Thanks,
Chris.
