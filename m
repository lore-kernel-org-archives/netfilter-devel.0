Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774323128AC
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2025 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755881272; cv=none; b=FG/hG0LHaqhgasAkEacKUWKyhmIJrT0OgWTlIQVdicF0qcCut7CyaE/tHYBRVnUaX3qjIbup1BI/Pdyiyj+zI7ek3SW+0t9HNyn3lrPtC92Hbi6ijiRQnHvRWD5irPc2RwIMJ/DcFl2EYIN+muEPfQKrPO/LhT+KQaFlDEKA0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755881272; c=relaxed/simple;
	bh=/wEO3fsxu4RH/atqSnF/9QBt44QpLUU91kx0XoZL5Eg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JKVYtcj37Y7l9aq7lYkInbtJl6HBnkWToa7WTOZtC3gTTelCm47zhLxyGK7azhsm4mnzy3MloB977Z0ipZGSZgWxoW5EQpnVkujwETWZ/8ye6bR6ms7LmuC4Bm3shyUc0oFxiFq+ZR9MdRDaZnrHf+pvRDyBPyK5rgCT2zuOEU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 92B181003C4518; Fri, 22 Aug 2025 18:41:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 90CCE1100A8E89;
	Fri, 22 Aug 2025 18:41:51 +0200 (CEST)
Date: Fri, 22 Aug 2025 18:41:51 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: =?UTF-8?Q?Pierre_Mazi=C3=A8re?= <star+netfilterdevelml@paupiland.net>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [ipset] Can't resolve domain names containing an hyphen "-"
In-Reply-To: <20250822155239.GA30578@askadice.com>
Message-ID: <s8347r6q-q4rs-6038-pssq-5n423p22p487@vanv.qr>
References: <20250822155239.GA30578@askadice.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Friday 2025-08-22 17:52, Pierre Mazière wrote:
>--------------------------------------------------------------
># ipset create testset hash:ip
># ipset add testset hyphen-containing.example.com
>ipset v7.2x: Syntax error: cannot parse hyphen: resolving to IPv4 address failed
>----------------------------------------------------------------
>
>The issue seems to be located in the parse_ipaddr function of
>lib/parse.c: the function attempts to find if the string pointed by the str 
>argument is a range of IPs containing IPSET_RANGE_SEPARATOR defined in 
>include/libipset/parse.h as "-".
>If IPSET_RANGE_SEPARATOR is found, it is replaced by '\0' which results
>in the truncation of the string pointed by the str argument.

And this is well documented in the manpage.

       If host names or service names with dash in the name are used instead of
       IP addresses or service numbers, then the host name or service name must
       be enclosed in square brackets.
