Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119525A652
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Jan 2025 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737912007; cv=none; b=j0gXcPDqZR0nI7DwyBMrdl7COc4xRj3HihDaG+ZJpbmHd9kqUETqnDBoz9nbaMa52eYpx6Qv2EnLUw6+lv1qMWdYKGxXMmoXQgQXnyIJjbLh52cb2/ifrwkOtOwn+1hkbeafy0J3zksXx5RjraKIeVNT7JSk1UlxmxxeCQpGNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737912007; c=relaxed/simple;
	bh=3/Ou+Cfb6XM9QGTLNOCc6e3N/YWOh/8DofQc9eZAge4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=SnvDgGDfzMUcL+QH2fFUkZHoHu3Vzxlc7jPILI+3v0kn9amvwuMJukioHTmHfct4muFgstPo/WCR4BQEMhpqbKGeCiWXKw18Q80MxPlgfDMwEPFzIdlmW/GxOS9Mf4NbhmOzNYDVFX+ieNo41OR4XYlg1fKBpmyiFgMZ5C+dx3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=Xfu9JP4Z; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="Xfu9JP4Z"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id C70E47D3B3;
	Sun, 26 Jan 2025 18:14:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1737911641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3/Ou+Cfb6XM9QGTLNOCc6e3N/YWOh/8DofQc9eZAge4=;
	b=Xfu9JP4ZqPh+zt/9oPeukSTfwyd6/mqpNVuulfG2GDSqgAAcpDVP4EXB+5DaEP6HWvu227
	D+mUNqLUcN0Fh3t78XbQ7NvpaignJV+fs2FMfEVnVUKEPoN7MgF5W0SNyW0DiRUkhW+qgZ
	xPDF6iU6yiIx+S4mpetBlg5VBJ/aD7I=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 26 Jan 2025 18:13:59 +0100
Message-Id: <D7C69D5AU3UF.3RUIITULHRHAZ@pwned.life>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] configure: Avoid addition assignment operators
From: "fossdd" <fossdd@pwned.life>
To: "fossdd" <fossdd@pwned.life>, "Pablo Neira Ayuso" <pablo@netfilter.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.19.0-0-gadd9e15e475d
References: <D711RJX8FZM8.1ZZRJ5PYBRMID@pwned.life>
 <Z4WSxlAq0_Ja2o44@calendula> <D71GI2NB7TP9.20P2VR1XEPU11@pwned.life>
In-Reply-To: <D71GI2NB7TP9.20P2VR1XEPU11@pwned.life>

On Tue Jan 14, 2025 at 3:56 AM CET, fossdd wrote:
>> Unfortunately, we don't take patches that abuse DCO via Signed-off-by:
>> that looks clearly made up.
>
> I can resend a v2 with my full name as commit author and Signed-off-by,
> if thats what you're asking.

Ping
