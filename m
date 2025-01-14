Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B590C2595
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736823381; cv=none; b=b7o76NL/dNZKikmzKlFnA6vl/SX+nK52yhoordDP+Nrjt6cmSHP3t3KzstdgrJLZ2sTUEmLqQrmLoatfPB1GH2+/WziVjID4q9AGFh7CnVJRe/Bq+7WvIEb20mFaCYXwSFzuYAfItsDl85H+1t+bpZl6v4mjbaJ1+L5foDDJ2X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736823381; c=relaxed/simple;
	bh=9697Ij70DTAdpuAWRb4ls1aOFv8N5xgCcq5Z4N3sfIE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=TQN1Xh2UGneCaJNIY7aB8R34Xf2pGfj3Zyo4bP8o91sCoMdK40Rxmv7JsV6ep+uwNDIgtlQnbA8Jv6/TBNna95YffTcT/QHscVleoaOFLG6YsD5ZhMfl+5oiVu9CPxLH9yZ71rxYJTjwmEnlFV6DBRPCz+9qaFEyu/2Py1btSBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=cna+Q7TM; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="cna+Q7TM"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 393817D2E3;
	Tue, 14 Jan 2025 03:56:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1736823376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9697Ij70DTAdpuAWRb4ls1aOFv8N5xgCcq5Z4N3sfIE=;
	b=cna+Q7TMUuRNkERZYxA5UUy3nxyXId3EM4fWrHfH3ng69F9IMWTLWgOkGKHG/3iDh7PmFy
	6JrbB4/t//RP2JAgT54diLjs5geAcx3mPkx60MVo64S8sMWxRaGjq2NaoXnqRGlJfij6E9
	b4EOZbkf8zkMkaJMb+ZYFcIkMvjW7X8=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jan 2025 03:56:13 +0100
Message-Id: <D71GI2NB7TP9.20P2VR1XEPU11@pwned.life>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] configure: Avoid addition assignment operators
From: "fossdd" <fossdd@pwned.life>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.18.2-0-ge037c095a049
References: <D711RJX8FZM8.1ZZRJ5PYBRMID@pwned.life>
 <Z4WSxlAq0_Ja2o44@calendula>
In-Reply-To: <Z4WSxlAq0_Ja2o44@calendula>

> Unfortunately, we don't take patches that abuse DCO via Signed-off-by:
> that looks clearly made up.

I can resend a v2 with my full name as commit author and Signed-off-by,
if thats what you're asking.
