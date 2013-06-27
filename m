From: Jeff Haran <Jeff.Haran@citrix.com>
Subject: RE: [PATCH v2 2/5] ipset: add "inner" flag implementation
Date: Thu, 27 Jun 2013 22:45:16 +0000
Message-ID: <4E5779AD88B2F040B8A7E83ECF544D1A01AD5B@SJCPEX01CL02.citrite.net>
References: <cover.1371423775.git.mr.dash.four@googlemail.com>
 <51BE49D4.1010901@googlemail.com>
 <alpine.DEB.2.00.1306262149560.17378@blackhole.kfki.hu>
 <51CCBE8A.3080305@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.citrix.com ([66.165.176.89]:34349 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab3F0WpT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:45:19 -0400
In-Reply-To: <51CCBE8A.3080305@googlemail.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Dash Four
> Sent: Thursday, June 27, 2013 3:37 PM
> To: Jozsef Kadlecsik
> Cc: Pablo Neira Ayuso; Netfilter Core Team
> Subject: Re: [PATCH v2 2/5] ipset: add "inner" flag implementation
> 
...
> I disagree. By having "return false" (or "return 0", "return -1" and so
> on) instead of "goto err" it is not immediately apparent to someone who
> studies/reviews/uses the code that this is an error condition/path. I
> have been in that situation many times when I have to go back and look
> at a particular function call to see what "return false" or "return 0"
> actually means.
> 
> By including "goto err" instead of multiple "return false" statement,
> that makes it instantly obvious what the purpose of that statement is
> without having to look elsewhere.

I suppose as an alternative you could go way against the usual practice and put some text in a function header comment block indicating what the return code means. I know it doesn't get used much but C has had this /* comment */ thing for a long time. I've never understood why more people don't use it.

Jeff Haran

