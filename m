From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH] Fix a couple of problems with xt_SYSRQ
Date: Tue, 15 Jun 2010 10:40:40 +0100
Message-ID: <4C174A98.6060202@oracle.com>
References: <1276097815-10116-1-git-send-email-john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:58562 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0FOJmN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:42:13 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o5F9g4OF031725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2010 09:42:07 GMT
Received: from acsmt353.oracle.com (acsmt353.oracle.com [141.146.40.153])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o5F9ftxh000930
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2010 09:41:56 GMT
In-Reply-To: <1276097815-10116-1-git-send-email-john.haxby@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/06/10 16:36, John Haxby wrote:
> The first problem is that the error response from crypto_alloc_hash()
> should be extracted from the pointer before setting the pointer to NULL.
>
> The second error is that only the first half of the password hash is
> checked which slightly weakens the password checking.
>
> Signed-off-by: John Haxby<john.haxby@oracle.com>
> ---
>   extensions/xt_SYSRQ.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>    

Did this get lost?  Should I resend it?

jch
