Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C1A21ABC3
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 14:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741356486; cv=none; b=P2q1oHcC/SUS4dFSGhJ10t4zywbzU7MBA4Ktfwru+Ztmas6zjzr9IXZtVHpDfZxYebtenql3+DtNiib+lMZ3+g3xWC6xAG1QMHSS62gOFcEAmN65jLPyvhfd78Hi0hn9sIhxenvy2nJ5WT/PSOpCwVjCOSto+l0HFiX7nxQZn1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741356486; c=relaxed/simple;
	bh=IUzzd13cJMgH0MBZ2hvm8lKJRaOgA5tEviqEEJSUVRs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=p87/aM+YLPIu1VO7w2i25y43edWxAgvlo0pHcWj04qOGJ95P1KBUIlnt4tfQzLpsnCyR4ZleXOcsOthI+cIpDweEHtcCkn3Pr1gbtHT8EoxBAoYnTfG47j2KsE/N3fh4PPx+sBgsMGS6MM5W54WQQQr/P3hGTbTFdnX+Cw5W3RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id E017E1003BB15A; Fri,  7 Mar 2025 15:07:58 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id DFEA51100AD650;
	Fri,  7 Mar 2025 15:07:58 +0100 (CET)
Date: Fri, 7 Mar 2025 15:07:58 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Guido Trentalancia <guido@trentalancia.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
In-Reply-To: <1741354928.22595.4.camel@trentalancia.com>
Message-ID: <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Friday 2025-03-07 14:42, Guido Trentalancia wrote:

>libxtables: tolerate DNS lookup failures
>
>Do not abort on DNS lookup failure, just skip the
>rule and keep processing the rest of the rules.
>
>This is particularly useful, for example, when
>iptables-restore is called at system bootup
>before the network is up and the DNS can be
>reached.

Not a good idea. Given

	-F INPUT
	-P INPUT ACCEPT
	-A INPUT -s evil.hacker.com -j REJECT
	-A INPUT -j ACCEPT

if you skip the rule, you now have a questionable hole in your security.
