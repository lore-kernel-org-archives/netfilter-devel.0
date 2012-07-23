From: Arif <aftnix@gmail.com>
Subject: Re: Hash table implementation
Date: Tue, 24 Jul 2012 03:06:45 +0700
Message-ID: <F3C0D461-9E04-4605-A681-10D681A5E85C@gmail.com>
References: <1f2ikbu.dcd9f8508a506924131bf976a787522f@obelix.schillstrom.com>
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: "kernelnewbies" <kernelnewbies@kernelnewbies.org>,
	"netfilter-devel" <netfilter-devel@vger.kernel.org>
To: "Hans Schillstrom" <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37237 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2GWVGs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:06:48 -0400
Received: by yenl2 with SMTP id l2so5977773yen.19
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jul 2012 14:06:48 -0700 (PDT)
In-Reply-To: <1f2ikbu.dcd9f8508a506924131bf976a787522f@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jul 23, 2012, at 11:31 PM, Hans Schillstrom wrote:

>> Subject: Hash table implementation
>>
>> Hi,
>>
>> This commit shows that jenkins hash
>> function(http://en.wikipedia.org/wiki/Jenkins_hash_function) is
>> implemented in kernel :
>>
>> commit 60d509c823cca21e77d537bd356785f7cfe8f0d1
>> Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>> Date:   Fri Dec 3 02:39:01 2010 +0000
>>
>>   The new jhash implementation
>> <snip>
>>
>> I could not find any good documentation describing how to use it.  
>> Only
>> thing i could do is to read codes which uses it, like
>
> Have a look in the include file it self  linux-3.5.0/include/linux/ 
> jhash.h
> every function is well documented there.
>

Thanks for the reply. I have looked through it. I guess the file  
serves well. I should pay attentions to comments more. Its just the  
guys i develop with, they put horrible comments, and i developed a  
habit of overlooking them.




> /Hans
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter- 
> devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

