From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] ulogd2: raw2packet_BASE changes
Date: Sun, 17 Mar 2013 11:06:05 +0100
Message-ID: <1363514765.10781.11.camel@tiger2>
References: <5135E98B.20409@googlemail.com>
	 <1362643095.6485.24.camel@tiger2> <51447E4F.1020401@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:40363 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3CQKGO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Mar 2013 06:06:14 -0400
In-Reply-To: <51447E4F.1020401@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Sat, 2013-03-16 at 14:14 +0000, Mr Dash Four wrote:
> > I'm wondering if it is not more convenient to simply pass a field with raw
> > data to the stack and have it used as binary in output plugins.
> > This way, we will treat all cases (I mean all protocols, ipsec or gre
> > are not supported in your patch) and the impact on the rest of the
> > plugins will be smaller.
> >   
> I don't think so.
> 
> The very nature of the information contained within strictly depends on 
> the protocol used in the original connection. If that was udp for 
> example, then the only "additional information" (in other words, what my 
> patch can extract from the secondary header) available to the plugins 
> would be the KEY_O_UDP_* keys and nothing else.
> 
> Besides, if a binary data is passed to the plugins, that data also needs 
> to be processed - by *all* plugins connected to the chain, so I don't 
> see this as a benefit at all.
> 
> > I really fear changes on all output plugins will be huge without
> > handling all cases.
> >   
> Have you done a performance analysis to make that assumption? If so, 
> could you post the results for all of us to see what that impact really is?

Do I ever use the word "performance" ? I'm talking about developing
work 

> > This will put work on interface and maybe it is a bit too much for them.
> >   
> Same question as above?

And same answer, I'm talking here about user interface that use ulogd
provided data to give information to user. They will have to decode all
these fields.

> > If we consider the problem from an admin point of view the most
> > meaningful information is the tuple (IP src and dest, proto, src and dst
> > port) the rest is a bit too much.
> >   
> I have been using this addition for over 7 months now (mainly as an 
> extension to the PGSQL and GPRINT plugins as they are most-widely 
> deployed on my servers here) and from experience I can tell you that, at 
> least for the TCP part of the original connection, I need the TCP flags 
> (in addition to everything else), simply because a connection can be 
> rejected with icmp unreachable because of illegal flags combination. So 
> in that particular case, I need to have all TCP flags available as keys.

This information is also available in the binary data I suggest to add.
And you could get it from there if needed.

> > Considering this, I will not accept this patch but I will be happy with
> > a version exporting the binary information and some selected fields.
> >   
> I am not convinced making binary data available (which will be different 
> depending on the underlying protocol of the original connection used), 
> which needs to be processed by the plugins in the whole chain, as oppose 
> to having the *relevant* keys already available to them, will add any 
> benefit - both performance-wise, as well as feature-wise.

I'm talking about information loss. Storing binary format allows you to
get back to the correct information at any time.

> On a separate note, care to answer the questions I asked you on this 
> list over 4 months ago (which are still to be addressed by yourself) [1] 
> with regards to the patch I submitted over 6 months ago [2] and do you 
> think that it is acceptable for you as a current maintainer of the 
> ulogd2 project to ignore addressing such requests? Thanks.
> 
> [1] - http://www.spinics.net/lists/netfilter-devel/msg23982.html

Can you rebase it to current tree and resubmit with white space fixed as
discussed before ?

> [2] - http://www.spinics.net/lists/netfilter-devel/msg23120.html

Do you have provided a patchset containing the Null dereference fix and
the SSL feature as asked by Pablo Neira Ayuso ?

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

