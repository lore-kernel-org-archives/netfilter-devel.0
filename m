From: Anders Fugmann <afu@fugmann.net>
Subject: Re: v2.6.8.1 breaks tspc
Date: Mon, 23 Aug 2004 12:48:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <4129E782.3040409@fugmann.net>
References: <200408212303.05143.mail@earthworm.de> <200408221506.07883.mail@earthworm.de> <200408221743.22561.vda@port.imtp.ilyichevsk.odessa.ua> <200408221826.41842.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
	linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S263772AbUHWMsN@vger.kernel.org>
To: Christian Hesse <mail@earthworm.de>
In-Reply-To: <200408221826.41842.mail@earthworm.de>
List-Id: netfilter-devel.vger.kernel.org

Christian Hesse wrote:
> On Sunday 22 August 2004 16:43, Denis Vlasenko wrote:
> 
>>Please try whether it works whan you do
>>"echo 0 > /proc/sys/net/ipv4/tcp_window_scaling"
> 
> 
> That helps. Thanks so far.
Any explanation of why this solution works?

I hate to blindly just disable window_scaling, just to make tspc work on 
2.6.8.1.

Is this a bug in the tscp program, netfilter or the tcp stack (or none 
of the mentioned)? One easy conclution is that some change were made 
between 2.6.7 and 2.6.8.1 which made tspc break - The question is which 
change and what other effect this change has.

Regards
Anders Fugmann
