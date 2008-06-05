From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Thu, 05 Jun 2008 13:55:10 +0100
Message-ID: <4847E22E.8010701@gmx.ch>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch> <484541E0.3020900@trash.net> <48465802.2010005@gmx.ch> <48470C52.1080306@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757161AbYFEMzO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:55:14 -0400
In-Reply-To: <48470C52.1080306@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Fabian Hugelshofer wrote:
>>>> Aligns buffers to maximum alignment of architecture to make the cast of
>>>> char pointers to struct pointers more portable.
>>>>
>>>> Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
>>> They all seem fine to me, but a union might make it look
>>> a bit nicer :)
[...]
> Please, use union wherever it is possible. BTW, it seems to me that the
> conntrack-tools may suffer from the same portability problem. The
> (supposed) fix, which is attached, is ugly but union does not help since
> the size of struct nf_conntrack is not known. I do not find a way to do
> this cleanly without removing the use of the stack for temporary object
> allocation.

As you noted, conntrack-tools can be affected as well. I did not have a 
look at it before, beacause I don't use it.

I don't see another way with the stack either. Dynamic memory allocation 
would help, but is not nicer either.

Do you want me to rewrite the patches for libnetfilter-(log|contrack) in 
the union style? I probably would put the union declaration in the file 
scope rather than anonymous declarations in the function scope, because 
it is the same everywhere.

