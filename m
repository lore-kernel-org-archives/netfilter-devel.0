From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Wed, 25 May 2011 09:32:18 +0100
Message-ID: <4DDCBE92.6070300@googlemail.com>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDC6240.7050701@googlemail.com> <alpine.DEB.2.00.1105250916260.5929@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42222 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab1EYIcX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 04:32:23 -0400
Received: by wwa36 with SMTP id 36so8208242wwa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2011 01:32:22 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1105250916260.5929@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> If you have got a restore file with an error in it, fix the file and 
> restore it again but with the '-!' flag. That way all already defined 
> sets, elements are ignored (technically: not raised the error due to the 
> clashing set/elements):
>
> # ipset restore < file
> <syntax error, fix the file>
> # ipset -! restore < file
>
> The "COMMIT" string is not required at all in ipset 6.x. It's just kept 
> for backward compatibility reasons.
>   
Didn't know that, thanks Jozsef - I'll remove all the COMMITs in the 
future as well.

