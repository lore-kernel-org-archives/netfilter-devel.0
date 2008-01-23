From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCH] Introducing socket mark socket option
Date: Wed, 23 Jan 2008 10:05:54 +0100
Message-ID: <47970372.90509@balabit.hu>
References: <12010124971855-git-send-email-> <4795FFEE.8070400@trash.net>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:54527 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYAWJF7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:05:59 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id F28B0C14B6
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jan 2008 10:05:56 +0100 (CET)
In-Reply-To: <4795FFEE.8070400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 9023244..8e88a0e 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -252,6 +252,9 @@ struct sock {
>>      long            sk_rcvtimeo;
>>      long            sk_sndtimeo;
>>      struct sk_filter          *sk_filter;
>> +#ifdef CONFIG_NETFILTER
>> +    __u32            sk_mark;
>> +#endif
> 
> Please find a spot that doesn't add holes on 64 bit.
> 

It adds if I insert the member before the function pointers. If I add it 
at the end of struct sock, it is ugly but there is no hole. Pahole's output:

        /* --- cacheline 8 boundary (512 bytes) --- */
         void                       (*sk_destruct)(struct sock *); /* 
512     8 */
         __u32                      sk_mark;              /*   520     4 */

         /* size: 528, cachelines: 9 */
         /* padding: 4 */
         /* paddings: 4, sum paddings: 16 */
         /* last cacheline: 16 bytes */
};      /* definitions: 80 */



I'd prefer the following:

diff --git a/include/net/sock.h b/include/net/sock.h
index 9023244..67de401 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -262,6 +262,8 @@ struct sock {
         __u32                   sk_sndmsg_off;
         int                     sk_write_pending;
         void                    *sk_security;
+       __u32                   sk_mark;
+       /* XXX 4 bytes hole on 64 bit */
         void                    (*sk_state_change)(struct sock *sk);
         void                    (*sk_data_ready)(struct sock *sk, int 
bytes);
         void                    (*sk_write_space)(struct sock *sk);


--
Attila
