From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 04 Dec 2007 15:18:46 +0100
Message-ID: <475561C6.4030704@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <4753B957.2000207@trash.net>	 <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>	 <47550D5C.8090004@trash.net>	 <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>	 <47551A83.80009@trash.net> <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org,
	Jesper Dangaard Brouer <hawk@diku.dk>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65471 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbXLDOSv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:18:51 -0500
In-Reply-To: <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
>
>> Salatiel, does this patch fix the problem?
>>
>> Index: libiptc/libiptc.c
>> ===================================================================
>> --- libiptc/libiptc.c   (Revision 7130)
>> +++ libiptc/libiptc.c   (Arbeitskopie)
>> @@ -866,10 +866,6 @@
>>         CHECK(h);
>>         return h;
>>  error:
>> -       if (--sockfd_use == 0) {
>> -               close(sockfd);
>> -               sockfd = -1;
>> -       }
>>         TC_FREE(&h);
>>         return NULL;
>>  }
>>
>>
> 
> I tried the patch but it didn`t work.
> 
> ~# iptables --version [patched now]
> iptables v1.3.8
> 
> ~# iptables -L
> iptables v1.3.8: can't initialize iptables table `filter': Invalid argument
> Perhaps iptables or your kernel needs to be upgraded.


Could you send another strace please?
