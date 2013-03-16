From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] libnetfilter_acct: use PRIu64 and remove unnecessary
 cast
Date: Sat, 16 Mar 2013 14:06:03 +0000
Message-ID: <51447C4B.3030308@googlemail.com>
References: <20130305135943.GA4369@localhost> <51363C27.3020305@googlemail.com> <20130315114727.GA8329@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter developer mailing list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33788 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3CPOGR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:06:17 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so1357071wib.9
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Mar 2013 07:06:15 -0700 (PDT)
In-Reply-To: <20130315114727.GA8329@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Pablo Neira Ayuso wrote:
> On Tue, Mar 05, 2013 at 06:40:39PM +0000, Mr Dash Four wrote:
>   
>> This patch corrects all nfacct_snprintf_* functions to use PRIu64,
>> given that we are using uint64_t type variables and also removes
>> the unnecessary casts.
>>     
>
> Applied, thanks.
>   
Applied where Pablo? I can't see any commits done on the main 
libnetfilter_acct tree for 13 days?
