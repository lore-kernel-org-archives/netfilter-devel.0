From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_request_find_match
Date: Wed, 20 Dec 2006 10:17:06 +0100
Message-ID: <4588FF92.9050607@trash.net>
References: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr> <4587D227.1000003@trash.net> <Pine.LNX.4.61.0612191405160.24179@yvahk01.tjqt.qr> <4587E91A.2020903@trash.net> <Pine.LNX.4.61.0612191623490.10396@yvahk01.tjqt.qr> <4588F175.8060109@trash.net> <Pine.LNX.4.61.0612201009540.26276@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964946AbWLTJRL@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0612201009540.26276@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
>>Make sure the user specifies the match on the command line before
>>your match. Look at the TCPMSS or REJECT targets for examples for
>>this.
> 
> 
> That would mean I'd have to
> 
>   -p tcp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
> lotsofothers -j TARGET
>   -p udp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
> lotsofothers -j TARGET

I don't see any match that would depend on an other match in
your example. How about your start explaining what you would
like to do, ideally with some code.
