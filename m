From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 21/27] Convert unfixated types to fixated ones
Date: Tue, 08 Jan 2008 16:52:38 +0100
Message-ID: <47839C46.5050905@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022130570.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63263 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYAHP4g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:56:36 -0500
In-Reply-To: <Pine.LNX.4.64.0801022130570.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 69855da1bb8257b215c83a72edd0c67bd7810fa5
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:30:30 2008 +0100
> 
>     [NETFILTER]: Convert unfixated types to fixated ones.
>     
>     The use of an unfixated type like "int" is dangerous, its size may
>     change in future (imagine 128-bit or ILP64 compilation) -- "long"
>     already has this problem which is differently-sized on x86_32 and
>     x86_64. Switch "int" to "int32_t" to prepare against future compiler
>     changes.


If that really happens a lot of things would break, so I don't
really see the point. It also changes types like char whose
size won't ever change.

