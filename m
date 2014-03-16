From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: xt_CHAOS - PDE_DATA compilation error
Date: Sun, 16 Mar 2014 17:23:23 +0100
Message-ID: <5325CFFB.7030206@chello.at>
References: <1394985214.54868.YahooMailNeo@web121203.mail.ne1.yahoo.com>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "M.G." <mg887@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:42965 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaCPQWE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2014 12:22:04 -0400
In-Reply-To: <1394985214.54868.YahooMailNeo@web121203.mail.ne1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.03.2014 16:53, M.G. wrote:
>
> Today at 1:49 PM
> Hello Everyone,
>
>
> in Centos 6 x64 with kernel 2.6.32-431.3.1.el6.centos.plus.x86_64  I have compilation error with  conflicting types for PDE_DATA.
> How to fix it ?
> Is it possible to exclude this xt_CHAOS module from compilation ?

I think you can modify 'mconfig' to:

build_CHAOS=

so it won't be built.

Best regards

Mart
