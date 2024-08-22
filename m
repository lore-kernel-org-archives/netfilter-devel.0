Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0365015F41F
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 09:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724317287; cv=none; b=IUIdTJtp3W1PXeS/FdeigtHC/oUHBdv6TDpMhjtfVJAr8QIs/+Z71OwyoHxXkuHds2tD104qmZtybBAf8B1evjMAkGMkkyhyo3whmdxN4arciwadjYGzm2ZZ635FNqtgOLzG//UTOUe1O13racXLd7dZYRuMqrGWMC7eB+pnfHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724317287; c=relaxed/simple;
	bh=ZEcJ/T7ioihoo/lFatA2i2AcN+fDi6NDslFXU001pqk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gOs/wGDWWKZGa10DwT90SpzgYSbi7nCovsktWtyzxMa0cEFbc1z3mrp4X7LnsEJWLzahtYjybv+se/sKly7mNi+xCDpL6sCcvZDBpnQjOOPjEGNXFdQbgzh30Dgdnm/OvAORDZi1H2E3hybPKlf2MFF/jlDTMADF8n53ep/fV6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efdf02d13so685930e87.2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 02:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724317284; x=1724922084;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEcJ/T7ioihoo/lFatA2i2AcN+fDi6NDslFXU001pqk=;
        b=ZzHEdNH16Rslkke0EWIY2DEkdYKU58yTM1RS6BEGfQB/jEw4oBwzyZnubjlRsO904Q
         BgZjG7bmAj2B9MKoTDiO5SWFiENKdn4uzBRi+PlVWCdwjQf/8TozvabHcdbbrZq3tskx
         ZrjnbeLHS03dTZwYky50nsP1U1j2gBA1UAtkCdoyg5EOLcIHS5gCCilIa1usi6oFHfRg
         ZxxAr5xgyfJLGRPhcHUWj38cVliaFMqM5At4U43GZBA3R6FFrekrYacNseyZ76OVd5LN
         vNl9nNpLir+cynowGhZqQlrwveKLKt5bF+YgILsTwhi4rCWCyagp/5PkhEMJfKuZGRJ5
         79Bg==
X-Forwarded-Encrypted: i=1; AJvYcCU32OR7YnY24FFxqySBHDP3lHIhpwkjYpk1Ur5V+gnPW9/CIZ4iTOyaPga/DI/HkMsIOgvVpD47KkUTf3BJkDw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2ZCX6/YLHOkhbFt0CL9dqCBplcrjMkSbHjNVj1Vn2rMdzhCFi
	867pl0XVctzpu9oYxtxPq0Q6bkic+Hs43du97npnBTMjhv9M6IsX4TgB5w==
X-Google-Smtp-Source: AGHT+IFBuV5DNDGs0cxPzAafnpiwDPtItX2Ao+usW0FUYyynBLAWqKzRi9fGevVgAeoGuLKVBPJWFg==
X-Received: by 2002:a05:6512:39d6:b0:533:324a:9df6 with SMTP id 2adb3069b0e04-5334fcfa277mr1060624e87.29.1724317283251;
        Thu, 22 Aug 2024 02:01:23 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-004.fbsv.net. [2a03:2880:30ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4f5c3csm87548366b.205.2024.08.22.02.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 02:01:22 -0700 (PDT)
Date: Thu, 22 Aug 2024 02:01:20 -0700
From: Breno Leitao <leitao@debian.org>
To: fw@strlen.de
Cc: rbc@meta.com, netfilter-devel@vger.kernel.org
Subject: netfilter: Kconfig: IP6_NF_IPTABLES_LEGACY old =y behaviour question
Message-ID: <Zsb+YHrLklrTCrly@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Florian,

I am rebasing my workflow in into a new kernel, and I have a question
that you might be able to help me. It is related to
IP6_NF_IPTABLES_LEGACY Kconfig, and the change in a9525c7f6219cee9
("netfilter: xtables: allow xtables-nft only builds").

In my kernel before this change, I used to have ip6_tables "module" as
builtin (CONFIG_IP6_NF_IPTABLES=y), and all the other dependencies as
modules, such as IP6_NF_FILTER=m, IP6_NF_MANGLE=m, IP6_NF_RAW=m.

After the mentioned commit above, I am not able to have ip6_tables set
as a builtin (=y) anymore, give that it is a "hidden" configuration, and
the only way is to change some of the selectable dependencies
(IP6_NF_RAW for insntance) to be a built-in (=y).

That said, do you know if I can keep the ip6_tables as builtin without
changing any of the selectable dependencies configuration. In other
words, is it possible to keep the old behaviour (ip6_table builtin and
the dependenceis as modules) with the new IP6_NF_IPTABLES_LEGACY
configuration?

Thank you!
--breno
