From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] xt_AUDIT.c: remove ipv6 dependencies
Date: Sun, 22 May 2011 12:44:19 +0100
Message-ID: <4DD8F713.1020902@googlemail.com>
References: <4DD83EB4.5040800@googlemail.com>	 <1306057384.12435.5.camel@edumazet-laptop> <1306058500.4840.130.camel@lsx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: tgraf@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48706 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1EVLoc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 May 2011 07:44:32 -0400
Received: by wwa36 with SMTP id 36so5329816wwa.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 May 2011 04:44:31 -0700 (PDT)
In-Reply-To: <1306058500.4840.130.camel@lsx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Its not clear why you beliebe this patch is needed.
>>
>> I have a kernel without IPV6, and xt_AUDIT compiles fine here, it even
>> loads properly.
>>     
>
> The patch is not required. The protocol definitions and header parsing
> functions are available even if IPv6 is not selected.
>   
I had errors when I tried to compile it in (I do not have ipv6 at all), 
hence I introduced the latest patch - with that patch everything 
compiles and runs without problems.
