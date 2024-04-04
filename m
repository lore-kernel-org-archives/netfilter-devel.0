Received: from forward201b.mail.yandex.net (forward201b.mail.yandex.net [178.154.239.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0D56BB29
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 10:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712225193; cv=none; b=QiJS1R++9YT+bYRG/t/Xa3Nw7EjGQ2oHe5eArpnXXYT56yPXyjw7/UOtxeTPtYDAwQsxIVP/z22IbWB2KicG/RnEQQWduRiyK1pmFTaaF4wulHDq0Ao3RlIlEnGtZGV4v7kppOItWu318TIZIc7y40Fn/n3VWBYxQ+mb06vx7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712225193; c=relaxed/simple;
	bh=RU0M5S6aI3ocyQQ03SP4iqgaKAF+8P6Hv8woAwkMIY4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=g6MMQ0de3UP5n8KSkpCgh8k+FF3CZmIJtQHLAaSCpd4LXaX2mHqFmIPJgJkNAVdjEwqZnb39tAZfIh4yrpQxO50S74lRMxgP/mJOyhNjxElufZBAOQ4sjl0dTv1ycfVvbxPEi5sFqOg0BpOn9JFEtcRtGUSY9TlYeUuCJbJ/wWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=itb.spb.ru; spf=pass smtp.mailfrom=itb.spb.ru; dkim=pass (1024-bit key) header.d=itb.spb.ru header.i=@itb.spb.ru header.b=shLn96ML; arc=none smtp.client-ip=178.154.239.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=itb.spb.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itb.spb.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itb.spb.ru header.i=@itb.spb.ru header.b="shLn96ML"
Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d102])
	by forward201b.mail.yandex.net (Yandex) with ESMTPS id DCF2B67116
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 12:59:31 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-45.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-45.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:5003:0:640:89b0:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTPS id 8698660993
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 12:59:23 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-45.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id MxQ2k494O8c0-hVgqOBVI;
	Thu, 04 Apr 2024 12:59:23 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itb.spb.ru; s=mail;
	t=1712224763; bh=vMw45rfbAWVUDcahYlHr5PpG11xUu+Rcyonjzku5iyo=;
	h=Subject:From:To:Date:Message-ID;
	b=shLn96MLjB7eH0hK95GUEvtKFDz59WIVCXebwhU+I2HWJKjby9ghtQ6Tksyht0u/a
	 9BlC3A7j//wwk51Yk01yyLUqP3aLStErdVJjKTzbbWNQy6SOBY9uiQ2wgmkhiEirIO
	 EeVoAGMF3RPJXBixO1+shdWPt/H/jwZZfUgVepZg=
Authentication-Results: mail-nwsmtp-smtp-production-main-45.myt.yp-c.yandex.net; dkim=pass header.i=@itb.spb.ru
Message-ID: <bdf12102-e4ab-427d-a3f5-1f6f00622477@itb.spb.ru>
Date: Thu, 4 Apr 2024 12:59:22 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: netfilter-devel@vger.kernel.org
From: Ivan Stepchenko <sid@itb.spb.ru>
Subject: static analysis results
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello!
I used a static analyzer to check iptables project and would like to 
share with you some of my notes. I have received several warnings from 
the analyzer, which I decided to inform you about.

1. libiptc/libiptc.c file, 499 line.
memset(h->chain_index, 0, array_mem) can lead to UB if "h->chain_index" 
is NULL. A few lines above there is a check "if (h->chain_index == NULL 
&& array_mem > 0)" but it may not work if the first condition is true 
and the second is false.
2. extensions/libip6t_mh.c file, 111 line.
3. extentions/libxt_tcp.c file, 47 line.
4. extensions/libxt_sctp.c file, 74 and 171 lines.
It is possible to dereference a potentially null pointer "buffer". I 
noticed this because other files have checks in similar places.
5. iptables/iptables-save.c file, 62 line.
Array overrun is possible if strlen(tablename) == 0. Maybe it's actually 
safe, and a dangerous string can't be found in this file, but I couldn't 
figure it out and decided to mention it just in case.

Thank you in advance for your answer,
Ivan Stepchenko
email: sid@itb.spb.ru
