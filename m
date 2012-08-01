From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: Re: ulogd - long living connections
Date: Wed, 1 Aug 2012 11:14:44 -0700
Message-ID: <CAAJpzgZObQP=ngyFL854RxdbU3VA5BzAC-MyUwCT2Nb6=hzJCg@mail.gmail.com>
References: <CAAJpzgYSo5_sXunijxBBdWrJET1hLJ8gPw0WLZod-m4jxZHosw@mail.gmail.com>
 <20120801165402.GA19512@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55302 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2HASPF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:15:05 -0400
Received: by obbuo13 with SMTP id uo13so12539188obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Aug 2012 11:15:04 -0700 (PDT)
In-Reply-To: <20120801165402.GA19512@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apologize, I did not understand your answer.

The problem that I'm facing is, say if I set a polling interval of 60s
and in some cases I may lose the data. For example,
net.netfilter.nf_conntrack_tcp_timeout_close has a timeout value of
10s. In this case, if the close event happens and with polling
interval of 60s I might miss the no of packets and size.

So I have to combine polling based + event based logging. If I
generate both the files separately, I have to combine them like going
through each file, and find out order of events and then I have to
intelligently combine them. This will take considerable cpu usage in
case of large network traffic system.

My idea is through a single stack, I would like to combine polling
based(logs update events) + event based(Create & Destroy events). In
this scheme, from single NFCT plugin I will be registering two
callbacks one is for getting update events using polling, and another
one is for getting create and destroy events using event based(no
hashtable). Is that possible?

Sorry for long mail, I am not good at describing things precisely.


Thanks & Regards,




On Wed, Aug 1, 2012 at 9:54 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jul 31, 2012 at 08:27:29PM -0700, Gomathivinayagam Muthuvinayagam wrote:
>> Hi,
>>
>> I feel current ulogd based accounting has some issues. It provides the
>> account usage during the destroy event. This is an issue for long
>> living connections, like alerting the user when he exceeds the quota.
>> I read the solution from the pdf published by Herald, 2005.
>>
>> Snippet is given below
>>
>> To overcome limitation number one, the accounting process can use a
>> combined event and polling scheme. The granularity of accounting can
>> therefore be configured by the polling interval,
>> and a compromise between performance and accuracy can be made.
>>
>> Current ulogd2 has not yet have the functionality. The reason is,
>> polling based accounting does not provide any unique id for a
>> particular connection. So even if we generate polling based data and
>> event based data, there is no way to combine the data. If you guys
>> already thought about solution for this problem, can you share it?
>
> You can combine that data using the hashtable that ulogd2 uses. You
> only has to pass the ct object that you receive from the dump to look
> for any existing matching.
