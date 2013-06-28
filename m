From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Fri, 28 Jun 2013 21:27:19 +0100
Message-ID: <51CDF1A7.1060602@googlemail.com>
References: <cover.1371423775.git.mr.dash.four@googlemail.com> <51BE49D4.1010901@googlemail.com> <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu> <51CCBE8A.3080305@googlemail.com> <4E5779AD88B2F040B8A7E83ECF544D1A01AD5B@SJCPEX01CL02.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jeff Haran <Jeff.Haran@citrix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64153 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3F1U13 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:27:29 -0400
Received: by mail-wg0-f54.google.com with SMTP id n11so2049867wgh.9
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 13:27:28 -0700 (PDT)
In-Reply-To: <4E5779AD88B2F040B8A7E83ECF544D1A01AD5B@SJCPEX01CL02.citrite.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jeff Haran wrote:
> I suppose as an alternative you could go way against the usual practice and put some text in a function header comment block indicating what the return code means. I know it doesn't get used much but C has had this /* comment */ thing for a long time. I've never understood why more people don't use it.
>   
All true. I guess I could go the full hog and document the entire 
function, then use "return false" as Jozsef suggested, but this will 
stick out as a sore thumb as it will be the only function documented in 
the entire module.

Jozsef, I don't mind doing either of the suggested alternatives: keep 
"goto err" or document the entire function and use "return false" - let 
me know what your preference is.
