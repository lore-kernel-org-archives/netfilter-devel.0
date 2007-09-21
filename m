From: laurent.brando@mindspeed.com
Subject: Re: skb_over_panic arround  __nfa_fill
Date: Fri, 21 Sep 2007 17:07:02 +0200
Message-ID: <OFCD822123.7049E9B3-ONC125735D.0052C391-C125735D.00530BE5@mindspeed.com>
References: <46F3BABD.6020500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail144.messagelabs.com ([216.82.254.51]:65502 "HELO
	mail144.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753655AbXIUPHJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:07:09 -0400
In-Reply-To: <46F3BABD.6020500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Thanks you for the feedback.

Yes I'm using some external netfilter patch (Openwrt distribution). I'll 
look at them in more details to see if 
the root cause of the crash come from there.


netfilter-devel-owner@vger.kernel.org wrote on 09/21/2007 02:36:13 PM:

> laurent.brando@mindspeed.com wrote:
> > Hi Patrick,
> > 
> > Here is the 'magical' line:
> > 
> > skb_over_panic: text:bf1981c0 len:48 put:8 head:c080d000 data:c080d01c 

> > tail:c080d014 end:c080df40 dev:<NULL>
> > Internal error: Oops: 817 [#1]
> 
> 
> skb_over_panic is only called when skb->tail > skb->end, in your case
> there's still room for 3884 bytes. Are you using any external patches/
> drivers/...? If so please try to reproduce without them, otherwise
> please post the full oops and disassembly of __nfa_fill.
> -
> To unsubscribe from this list: send the line "unsubscribe 
netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

