From: Ana Rey <anarey@gmail.com>
Subject: Re: cannot stat 'doc/nftables.8': No such file or directory
Date: Mon, 14 Apr 2014 12:14:12 +0200
Message-ID: <CAD7o0sh30hgNpkoUZZmq8NW2i5oX7Dkf=rVzP4TzPDsDDGTK7w@mail.gmail.com>
References: <CAD7o0sja_p2BhAuDMBEqR7Y6oprGs+nViDTC66Xr9-RU0H54LQ@mail.gmail.com>
 <20140414100656.GA3661@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61286 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDNKOe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:14:34 -0400
Received: by mail-ve0-f172.google.com with SMTP id jx11so7180673veb.17
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Apr 2014 03:14:33 -0700 (PDT)
In-Reply-To: <20140414100656.GA3661@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-04-14 12:06 GMT+02:00 Patrick McHardy <kaber@trash.net>:
> On Mon, Apr 14, 2014 at 11:37:36AM +0200, Ana Rey wrote:
>> Hello,
>>
>> With the last changes in nftable (last commit 'doc: change
>> documentation license to CC BY-SA 4.0')
>>
>> $ sudo make install
>> -e   SUBDIR src/
>> -e   INSTALL nft
>> -e   SUBDIR files/
>> -e   INSTALL files
>> -e   SUBDIR doc/
>> -e   MAN doc/nftables.8
>> -e   INSTALL doc
>> /usr/bin/install: cannot stat 'doc/nftables.8': No such file or directory
>> make[1]: *** [install] Error 1
>> make: *** [doc] Error 2
>>
>> I have docbook in my system, and I try to install it before a 'make
>> clean'  and './autogen.sh'
>
> I just pushed out a fix, could you please retry?

Yes, I've just retried it. All is ok

Thank you!



-- 
Ana Rey (@anaRB)
http://about.me/anarey
