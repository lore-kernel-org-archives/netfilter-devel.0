From: pud <pud@subnet666.de>
Subject: Re: libxt_string: fix undefined behavior/incorrect patlen
	calculation
Date: Sun, 1 Mar 2009 23:37:35 +0100
Message-ID: <20090301223735.GA25389@safeTpin.homeunix.org>
Reply-To: pud@subnet666.de
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx01.qsc.de ([213.148.129.14]:41539 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbZCAWsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:48:12 -0500
Received: from safetpin.homeunix.org (port-87-234-80-215.dynamic.qsc.de [87.234.80.215])
	by mx01.qsc.de (Postfix) with ESMTP id E7EEC3CF72
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Mar 2009 23:37:44 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(sorry, msg-id lost)

> commit 19b0cd770d1e042c85bf0b278261a61d4cea8193
> Author: Jan Engelhardt <jeng...@medozas.de>
> Date: Thu Feb 12 01:18:35 2009 +0100
...
> - stringinfo->patlen=strlen((char *)&stringinfo->pattern);
> + stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
> +                           sizeof(stringinfo->patlen));

sorry, this doesn't work here, did you mean
sizeof(stringinfo->pattern)?


=;p/ud aka nerdpunk

-- 
gpg-key #C3B04767
