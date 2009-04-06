From: Badalian Vyacheslav <slavon@bigtelecom.ru>
Subject: Re: ipset can't load -N and -A separately
Date: Mon, 06 Apr 2009 14:57:37 +0400
Message-ID: <49D9E021.6050900@bigtelecom.ru>
References: <49D9B571.7090802@bigtelecom.ru> <alpine.DEB.2.00.0904061112210.29852@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bigtelecom.ru ([87.255.0.61]:54133 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbZDFK5l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:57:41 -0400
In-Reply-To: <alpine.DEB.2.00.0904061112210.29852@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oh... Thanks!

> On Mon, 6 Apr 2009, Badalian Vyacheslav wrote:
>
>   
>> If i try generate restore file its can't load first all -N and then all
>> -A fileds.
>> If we do s/^/ipset / its normal load all rules.
>>     
>
> That's the normal and documented behaviour, see 'man ipset'. In a restore 
> script you must create a set, add all its elements, then create the next 
> set, add all of those elements and so on. 
>  
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
>
>   

