From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 13:22:51 +0100
Message-ID: <4DDBA31B.4040406@googlemail.com>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDB91CD.3080003@googlemail.com> <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu> <4DDB9C6A.9040308@googlemail.com> <alpine.DEB.2.00.1105241404390.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41215 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1EXMWz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:22:55 -0400
Received: by wwa36 with SMTP id 36so7259351wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 05:22:54 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241404390.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Currently I can suggest you that tune both the hashsize and maxelem 
> parameters: the hashsize tells the system the initial hash size (and thus 
> the used memory resource) while maxelem tells up to what number of 
> elements can be added to the set. You are free to enter quite high maxelem 
> values, it does not waste memory. As you add more and more elements, the 
> hash size is increased from the one specified by 'hashsize'. But you (or 
> the SET targets) can't add more elements than "maxelem".
>
> When you save a set, the current hashsize is saved and not the one 
> specified at set creation time.
>   
Ah, I see! So maxelem does not have an impact on system resources as 
hashsize has, is that right? If that is the case, then I may as well 
leave the default (64k) as I'd never exceed this value. Thanks for your 
input, as always!

