From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] ulogd2: raw2packet_BASE changes
Date: Sat, 16 Mar 2013 14:14:39 +0000
Message-ID: <51447E4F.1020401@googlemail.com>
References: <5135E98B.20409@googlemail.com> <1362643095.6485.24.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46297 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3CPOOv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:14:51 -0400
Received: by mail-wi0-f182.google.com with SMTP id hi18so1338291wib.9
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Mar 2013 07:14:50 -0700 (PDT)
In-Reply-To: <1362643095.6485.24.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I'm wondering if it is not more convenient to simply pass a field with raw
> data to the stack and have it used as binary in output plugins.
> This way, we will treat all cases (I mean all protocols, ipsec or gre
> are not supported in your patch) and the impact on the rest of the
> plugins will be smaller.
>   
I don't think so.

The very nature of the information contained within strictly depends on 
the protocol used in the original connection. If that was udp for 
example, then the only "additional information" (in other words, what my 
patch can extract from the secondary header) available to the plugins 
would be the KEY_O_UDP_* keys and nothing else.

Besides, if a binary data is passed to the plugins, that data also needs 
to be processed - by *all* plugins connected to the chain, so I don't 
see this as a benefit at all.

> I really fear changes on all output plugins will be huge without
> handling all cases.
>   
Have you done a performance analysis to make that assumption? If so, 
could you post the results for all of us to see what that impact really is?

> This will put work on interface and maybe it is a bit too much for them.
>   
Same question as above?

> If we consider the problem from an admin point of view the most
> meaningful information is the tuple (IP src and dest, proto, src and dst
> port) the rest is a bit too much.
>   
I have been using this addition for over 7 months now (mainly as an 
extension to the PGSQL and GPRINT plugins as they are most-widely 
deployed on my servers here) and from experience I can tell you that, at 
least for the TCP part of the original connection, I need the TCP flags 
(in addition to everything else), simply because a connection can be 
rejected with icmp unreachable because of illegal flags combination. So 
in that particular case, I need to have all TCP flags available as keys.

Besides, I don't see how cutting a few extra keys will add, 
significantly, to the processing time, but if you have done the analysis 
and have it available, please post it here for all of us to see and 
prove me wrong.

> Considering this, I will not accept this patch but I will be happy with
> a version exporting the binary information and some selected fields.
>   
I am not convinced making binary data available (which will be different 
depending on the underlying protocol of the original connection used), 
which needs to be processed by the plugins in the whole chain, as oppose 
to having the *relevant* keys already available to them, will add any 
benefit - both performance-wise, as well as feature-wise.

On a separate note, care to answer the questions I asked you on this 
list over 4 months ago (which are still to be addressed by yourself) [1] 
with regards to the patch I submitted over 6 months ago [2] and do you 
think that it is acceptable for you as a current maintainer of the 
ulogd2 project to ignore addressing such requests? Thanks.

[1] - http://www.spinics.net/lists/netfilter-devel/msg23982.html
[2] - http://www.spinics.net/lists/netfilter-devel/msg23120.html
