From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xt_AUDIT additions
Date: Sat, 02 Jul 2011 03:25:22 +0100
Message-ID: <4E0E8192.1010406@googlemail.com>
References: <4E0CFBF2.9000500@googlemail.com> <alpine.LNX.2.01.1107011005060.7813@frira.zrqbmnf.qr> <4E0DB027.3000309@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, hch@infradead.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33498 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1GBCZd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 22:25:33 -0400
Received: by wwe5 with SMTP id 5so3702578wwe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Jul 2011 19:25:32 -0700 (PDT)
In-Reply-To: <4E0DB027.3000309@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> However, xt_owner did not held the tasklist [write] lock, just 
>> entered a RCU read section. hch: Was this RCU section also too long?
>>
>> xt_owner had the bonus that it only had to check whether the socket 
>> was owned by a particular user/group/pid/sid, which means it can stop 
>> looping the tasklist as soon as it found a match.
>>   
> I'll have a look at the xt_owner code later to see if there is 
> something I could use/learn.
Interesting, thanks for all the pointers!

xt_owner.c does have some answers. 
skb->sk->sk_socket->file->f_cred->fsuid and 
skb->sk->sk_socket->file->f_cred->fsgid seems to point to the socket 
user id/group id owner. That, to my understanding, may not always be the 
uid/gid responsible for sending a particular packet via this particular 
socket, or have I got this wrong?

Moving on to the process id, I take it skb->sk->pid (or is it 
skb->sk->sk_socket->sk->pid?) holds the pid list of the process(es) 
owning the socket, right? Should I assume that the process responsible 
for sending a particular packet could be found by traversing that list 
or do I have to look elsewhere?

Also, am I right in assuming that only one process is responsible for 
sending a particular packet? If that is the case, then there must only 
be a single, unique triple of uid/pid/gid for each packet. If that is 
so, how do I know which uid/pid/gid is responsible for that?

