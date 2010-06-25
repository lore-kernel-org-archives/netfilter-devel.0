From: John Haxby <john.haxby@oracle.com>
Subject: Re: [RESEND] [PATCH] Fix a couple of problems with xt_SYSRQ
Date: Fri, 25 Jun 2010 10:57:02 +0100
Message-ID: <4C247D6E.3090307@oracle.com>
References: <4C2478FB.5080602@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:63001 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0FYJ6Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:58:25 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id o5P9wNCE005641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jun 2010 09:58:24 GMT
Received: from acsmt353.oracle.com (acsmt353.oracle.com [141.146.40.153])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o5P565tA002119
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jun 2010 09:58:22 GMT
In-Reply-To: <4C2478FB.5080602@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25/06/10 10:38, John Haxby wrote:
> The first problem is that the error response from crypto_alloc_hash()
> should be extracted from the pointer before setting the pointer to NULL.
>
> The second error is that only the first half of the password hash is
> checked which slightly weakens the password checking.

My apologies, this patch was corrupted by my mailer.   The "[RESEND2]" 
following should be OK.

jch
