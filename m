From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Wed, 25 May 2011 03:33:17 +0100
Message-ID: <4DDC6A6D.7060605@googlemail.com>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDB91CD.3080003@googlemail.com> <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu> <4DDB9C6A.9040308@googlemail.com> <alpine.DEB.2.00.1105241404390.1846@blackhole.kfki.hu> <4DDBA31B.4040406@googlemail.com> <alpine.DEB.2.00.1105241425240.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45141 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1EYCdV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 22:33:21 -0400
Received: by wya21 with SMTP id 21so5442923wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 19:33:19 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241425240.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Yes, exactly. With the hashsize parameter, you tell the system how much 
> memory is allocated for the set when created. With maxelem it is 
> instructed at what point to stop increasing the set and refuse adding more 
> elements.
>   
It turns out that ipset is more efficient in that respect as well. Over 
15k members take about 0.6MB of RAM, which isn't that bad!

I have one suggestion though: it would be nice if you could implement a 
"check" option to accompany restore so that ipset doesn't actually do 
anything, but just checks the syntax of that file (a dummy run, if you 
like) and reports any errors or omissions (it could be more than one!). 
It would be nice to have that feature and help in avoiding errors (see 
also my other post with regards to that).
