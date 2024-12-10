Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0C62AE93
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 02:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796253; cv=none; b=ovXbhucKS6PFIUswR4xZCXTKJ7sypM1+VSMxic8cxkEoqwB4MhKFR7NUx6f85eqEK9CmNRLcry0xICxq4wYws/5mZzK5YBgCDT8bOcPgU2cTrwNpqVRrFjg75WShUhGPRdnB2oGPOCzCz+Cl7jQH92E//b679jhjI1AJuj7CgnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796253; c=relaxed/simple;
	bh=Qsust4wfqX0Rr4LR7C12dwlbbdUCyopBGDifWrMpxqQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=dn0Or4c4BWac/YnhxAT2RqJ2UiUk6vr3pVPP8Gd7D5aMmPE6UlZiiGDyfwRaN3gF4S8g9P8WM0zPyN+Bf9O1GeUfqjZcwX28795hGESx2oPAXyZ5uFzkjsVol5YvdkiVObad4KPRpUlheZKoCGras63ayVMXl7PoHkMQBKowhyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 519791004409C1; Tue, 10 Dec 2024 02:55:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 4FBC111006FBCA;
	Tue, 10 Dec 2024 02:55:44 +0100 (CET)
Date: Tue, 10 Dec 2024 02:55:44 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Christopher Buckley <cpmbmail@yahoo.com>
cc: netfilter-devel@vger.kernel.org
Subject: Re: Help Building IPT / NFT Extension
In-Reply-To: <70938534.378100.1733605713150@mail.yahoo.com>
Message-ID: <78569qnr-qs72-n683-q2p1-608053141428@vanv.qr>
References: <70938534.378100.1733605713150.ref@mail.yahoo.com> <70938534.378100.1733605713150@mail.yahoo.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Saturday 2024-12-07 22:08, Christopher Buckley wrote:
>
>I have an application called 'LANDrive' on my Android G7 Play phone. The tool
>should allow me to establish a network connection between my phone and
>computer.
>
>I have an application on my computer called 'Backer' which allows me to backup
>my computer to external drives. I want to network to my phone so I can backup
>or transfer files directly to my phone.
>
>The 'LANDrive' app has a strange configurtion. It uses ports 137, 138, and 445
>for 'smb/sharing/tcp' but only for a rooted phone. It will use ports 1137,
>1138, and 1445 for non-rooted (standard) phones.
>
>After extensive research, including the Netfilter 'HowTo' list, I found
>information on 'TEE' which seemed to indicate IPT could solve my problem.

If all you want/need is rewrite the port number, then why do you make clones
of packets? That seems unnecessary.
