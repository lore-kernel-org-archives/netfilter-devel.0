From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: problem with xtables-addons and CentOS 5.3
Date: Mon, 27 Apr 2009 12:25:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904271224480.6706@fbirervta.pbzchgretzou.qr>
References: <49F49944.3010800@solutti.com.br> <alpine.LSU.2.00.0904271110320.6706@fbirervta.pbzchgretzou.qr> <49F582F4.5080604@solutti.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ML netfilter-devel <netfilter-devel@vger.kernel.org>
To: Leonardo Rodrigues <leolistas@solutti.com.br>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40960 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZD0KZh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:25:37 -0400
In-Reply-To: <49F582F4.5080604@solutti.com.br>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-04-27 12:03, Leonardo Rodrigues wrote:
> Jan Engelhardt escreveu:
>> On Sunday 2009-04-26 19:26, Leonardo Rodrigues wrote:
>>
>>>  i'm having a hard time trying to compile xtables-addons 1.14 on a CentOS
>>> 5.3
>>> x86_64 box
>>
>> I added appropriate warning mechanisms to configure.ac for the next
>> release that this distro is unsupported.
>
>   hmmmm that's bad ..... is there any workaround, or it's simply unsupported ?
>   is it the shipped iptables that has problem ? is it some shipped lib that
> has problems ?

It is the RHEL/Centos kernel that's riddled with problematic backports 
as usual.
