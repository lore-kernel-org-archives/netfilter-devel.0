From: "Eric Leblond" <eric@inl.fr>
Subject: Re: [ULOGD PATCH 2/4] Convert SQL procedure to function in MySQL  
     plugins.
Date: Wed, 9 Apr 2008 18:29:09 +0200 (CEST)
Message-ID: <47390.62.160.220.138.1207758549.squirrel@mail.inl.fr>
References: <1207004990315-git-send-email-eric@inl.fr>
    <1207004990860-git-send-email-eric@inl.fr>
    <47FCC654.7080900@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Eric Leblond" <eric@inl.fr>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:54805 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbYDMHFN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:05:13 -0400
Received: from bayen.regit.org ([81.57.69.189])
	by fydelkass.inl.fr with esmtpsa (TLS-1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63)
	(envelope-from <eric@inl.fr>)
	id 1JkwH2-0008K7-8q
	for netfilter-devel@vger.kernel.org; Sun, 13 Apr 2008 09:05:12 +0200
In-Reply-To: <47FCC654.7080900@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

> Eric Leblond wrote:
>> DB output plugins have been modified to use function instead of
>> procedure.
>> This patch convert the conntrack insertion procedure to function.
>
> Where is the client code that uses the returned value of the INSERT_CT
> function?

It's not yet developed ;)

In fact, this change has been done to be in sync with a modification in
the packet logging infrastructure which uses a function. If we have a
function and a procedure we could not use the same SQL request prefix. We
should have add an option to be able to set the correct prefix. This is
quiet painfull if you consider that having a function can be useful :
as it returns the ID of the packet if could be used by a third party
application which use the same database. For example, it could use it to
log packet :
 - Call to the function INSERT_CT
 - Do other treatment

Furthermore, it seems that PROCEDURE is not trully a SQL thing only
FUNCTION are defined.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)
