From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [PATCH] xt_log.h: don't use xchg() for simple assignment
Date: Fri, 23 Mar 2012 10:14:11 +0000
Message-ID: <4F6C5B03020000780007A7ED@nat28.tlf.novell.com>
References: <4F588DD8020000780007711C@nat28.tlf.novell.com>
 <20120323100705.GA22309@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: <kaber@trash.net>, <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nat28.tlf.novell.com ([130.57.49.28]:15379 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab2CWKNQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-netfilter-devel@vger.kernel.org:3:1>);
	Fri, 23 Mar 2012 06:13:16 -0400
In-Reply-To: <20120323100705.GA22309@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>> On 23.03.12 at 11:07, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 08, 2012 at 09:45:44AM +0000, Jan Beulich wrote:
>> At least on ia64 the (bogus) use of xchg() here results in the compiler
>> warning about an unused expression result. As only an assignment is
>> intended here, convert it to such.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> 
>> ---
>>  include/net/netfilter/xt_log.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> --- 3.3-rc6/include/net/netfilter/xt_log.h
>> +++ 3.3-rc6-netfilter-xt_log-no-xchg/include/net/netfilter/xt_log.h
>> @@ -47,7 +47,7 @@ static void sb_close(struct sbuff *m)
>>  	if (likely(m != &emergency))
>>  		kfree(m);
>>  	else {
>> -		xchg(&emergency_ptr, m);
>> +		emergency_ptr = m;
> 
> That xchg is there for some reason. I think it's better if you just
> cast it to void.

If I knew the reason, I wouldn't mind doing so. But with no code
comment and nothing said in the corresponding commit message
I'm of the opinion that it is there just as a copy-and-paste result.

Jan

