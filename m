From: Andrew Beverley <andy@andybev.com>
Subject: Re: question about libfilter_conntrack
Date: Tue, 27 Jul 2010 09:52:24 +0100
Message-ID: <20100727095224.134553gv7kfpneiw@www.simplelists.com>
References: <AANLkTinSbAJfzTyxJRawHzA05u73fZpgoUXDABNQ+v=y@mail.gmail.com>
 <1280211159.1462.54.camel@andybev>
 <AANLkTi=xLxmMeKz2kuz1myZY4dg4_Go=1spLJ1H8dQO7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pete Kay <petedao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:53584 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0G0Iw0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:52:26 -0400
In-Reply-To: <AANLkTi=xLxmMeKz2kuz1myZY4dg4_Go=1spLJ1H8dQO7@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>> I would like to use libfilter_conntrack to remove an entry in the
>>> conntrack table.
>>>
>>> Does anyone have an example showing how to do that programmatically?
>>
>> There's an example in the source code, in utils/conntrack_delete.c
>>
> I am using the conntrack_delete example to try to delete this entry:
> udp      17 29 src=192.168.1.56 dst=192.168.1.114 sport=16385
> dport=26956 packets=28149 bytes=7881720 [UNREPLIED] src=192.168.1.114
> dst=192.168.1.56 sport=26956 dport=16385 packets=0 bytes=0 mark=0
> secmark=0 use=2
>
> But I am having problem doing so with the lines of code below:
>
>       ct = nfct_new();
>         if (!ct) {
>                 perror("nfct_new");
>               return 0;
>
>         }
>         nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
>         nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_SRC, inet_addr("192.168.1.56"));
>
>         nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
>       nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, htons(16385));
>

You need to also specify the destination IP address and port number. I  
think that as a minumum you must specify all 6 peices of information:  
source/dest IP address and port number, and the layer 3 and layer 4  
protocol.

Regards,

Andy


