From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 09:23:50 -0400
Message-ID: <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>
	 <4833F119.7080206@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:36656 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbYEUNXv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 09:23:51 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2584417rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2008 06:23:50 -0700 (PDT)
In-Reply-To: <4833F119.7080206@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

thank you for your comments.
---

Pablo:

cc1: warnings being treated as errors
read_config_lex.l: In function 'yylex':
read_config_lex.l:113: warning: incompatible implicit declaration of
built-in function 'strdup'
read_config_lex.l:114: warning: incompatible implicit declaration of
built-in function 'strdup'
read_config_lex.l:115: warning: incompatible implicit declaration of
built-in function 'strdup'
read_config_lex.l:126: warning: incompatible implicit declaration of
built-in function 'strdup'
read_config_lex.c:3845: warning: label 'find_rule' defined but not used
make[1]: *** [read_config_lex.o] Error 1

I get this while compiling the last git snapshot
probably string.h is missing ?

Thank you


On Wed, May 21, 2008 at 5:53 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> NICOLAS BOULIANE wrote:
>> Since ppp0 always come up first, then these connections begin to flow
>> via ppp0 and with the MASQ IP of ppp0...
>>
>> Later, when the mangle-rules kick-in, these connections are being
>> router via ppp4 (which is what I want)...
>> So far no problem..
>>
>>
>> The only problem is that these packets now exit via ppp4 but they
>> continue to keep the source IP of ppp0
>>
>>
>> Ok, I tried to use the userspace conntrack-tool to search and remove
>> these entries, but this tool doesn't allow me to do something like this
>>
>> $> conntrack -L conntrack -d IP
>
> Check Git, next version (0.9.7) allows it.
>
> --
> "Los honestos son inadaptados sociales" -- Les Luthiers
>
