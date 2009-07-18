From: Stefan Hellkvist <hellkvist@gmail.com>
Subject: Re: Understanding execution context of netfilter hooks
Date: Sat, 18 Jul 2009 09:39:11 +0200
Message-ID: <8873666D-CAF7-493C-BF1D-8D90F86066EA@gmail.com>
References: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com> <20090717155703.0a70a8ae@nehalam>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:63124 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZGRHjQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:39:16 -0400
Received: by bwz28 with SMTP id 28so1114913bwz.37
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jul 2009 00:39:15 -0700 (PDT)
In-Reply-To: <20090717155703.0a70a8ae@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jul 18, 2009, at 12:57 AM, Stephen Hemminger wrote:

>>
>>     buf[20] = '\0';
>>     printk("first 20 chars: \"%s\"\n", buf);
>>     filp_close(fp, 0);
>>   }
>> }
>
>
> One of the repeating mantra's of kernel development is:
> "Don't do file i/o in kernel code."
>
> Your code is wrong not just because kernel i/o can sleep,
> but also because there really is not just one namespace,
> so what is /etc/shadow!
>
> The right way to do something like this is to read/parse
> the file in a utility and pass the necessary data into the
> kernel module through other mechanisms (/proc,netlink, debugfs, ...)

Yes, I am well aware of the actual "badness" of the code in question.  
I was more curious and wondering why it behaved differently in  
different parts of the kernel but I kind of understand that now. The  
real code I'm working on is doing something similar as to what you  
describe with a utility in user space. I was also using  
netfilter_queue at one stage but for some reason I could not make that  
stable. With high traffic the netfilter_queue just stopped working for  
some reason and not because of buffer overrun (as far as I could tell)  
but due to something else that I never understood (probably some error  
in my code) so I went for something similar but simpler and more  
targeted for my needs.

/Stefan


