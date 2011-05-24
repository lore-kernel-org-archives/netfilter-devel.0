From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 12:54:18 +0100
Message-ID: <4DDB9C6A.9040308@googlemail.com>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDB91CD.3080003@googlemail.com> <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64727 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1EXLyW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 07:54:22 -0400
Received: by wya21 with SMTP id 21so4904580wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 04:54:21 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Hm, 2.6.35 can lessen the maintenance burden compared to the currently 
> minimal supported version 2.6.34, because the main trouble comes from the 
> differences between .34 and .35. So I think I can remove the older kernel
> supports gradually and keep supporting 2.6.35 for a while.
>   
That would be appreciated as I think .35 is a pretty stable kernel and 
will be in use for a while yet (though I have to admit, I have patched 
this kernel extensively).

> The problem with it that the reported number can be inaccurate, at least 
> in two cases:
>
> - Elements can time out, so even if whatever number reported, by the
>   time it's displayed, the set can even be completely empty. In the case
>   of a huge set, it can even occur that the number of elements reported
>   does not match the actual number of elements listed.
> - Sets can be updated by the SET target
>
> The first one is the main reason I dropped reporting the number of 
> elements (the initial design of the new ipset included it).
>   
I see, reasonable point.

OK, would it be possible then to get this figure when I use restore - I 
am asking for this because, as you already know, ip ranges may mean 
inserting more elements than the range itself and the indicator I used 
up until now to determine how many set members I would have (the number 
of lines in my restore file) is no longer a reliable indicator, so I 
would need to know how many members I have inserted as a result of 
restore in order to determine the maxelem value, adjust it and thus save 
system resources. Do you see my point?

