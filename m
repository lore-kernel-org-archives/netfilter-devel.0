From: Pete Kay <petedao@gmail.com>
Subject: Re: question about libfilter_conntrack
Date: Tue, 27 Jul 2010 15:17:25 +0800
Message-ID: <AANLkTi=xLxmMeKz2kuz1myZY4dg4_Go=1spLJ1H8dQO7@mail.gmail.com>
References: <AANLkTinSbAJfzTyxJRawHzA05u73fZpgoUXDABNQ+v=y@mail.gmail.com>
	<1280211159.1462.54.camel@andybev>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:38270 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0G0HR0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:17:26 -0400
Received: by pxi14 with SMTP id 14so338186pxi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2010 00:17:25 -0700 (PDT)
In-Reply-To: <1280211159.1462.54.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andy,

Thanks alot for your help.

I am using the conntrack_delete example to try to delete this entry:
udp      17 29 src=192.168.1.56 dst=192.168.1.114 sport=16385
dport=26956 packets=28149 bytes=7881720 [UNREPLIED] src=192.168.1.114
dst=192.168.1.56 sport=26956 dport=16385 packets=0 bytes=0 mark=0
secmark=0 use=2

But I am having problem doing so with the lines of code below:

      ct = nfct_new();
        if (!ct) {
                perror("nfct_new");
              return 0;

        }
        nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
        nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_SRC, inet_addr("192.168.1.56"));

        nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
      nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, htons(16385));

        h = nfct_open(CONNTRACK, 0);
        if (!h) {
                perror("nfct_open");

        }

        ret = nfct_query(h, NFCT_Q_DESTROY, ct);


Does anyone know why?

Thank you so much in advance for your help.

P







On Tue, Jul 27, 2010 at 2:12 PM, Andrew Beverley <andy@andybev.com> wrote:
>> I would like to use libfilter_conntrack to remove an entry in the
>> conntrack table.
>>
>> Does anyone have an example showing how to do that programmatically?
>
> There's an example in the source code, in utils/conntrack_delete.c
>
> Andy
>
>
>
