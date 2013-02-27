From: Nicole <nicole@cats-muvva.net>
Subject: Re: Help on error message
Date: Wed, 27 Feb 2013 20:22:12 +0000
Message-ID: <512E6AF4.40008@cats-muvva.net>
References: <512E49C8.30602@cats-muvva.net> <alpine.LNX.2.01.1302272040020.31630@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.cats-muvva.net ([195.69.92.234]:42529 "EHLO
	hosting.cats-muvva.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754529Ab3B0UVn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:21:43 -0500
In-Reply-To: <alpine.LNX.2.01.1302272040020.31630@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've been reading Linus Torval's latest rants, so I don't feel confident 
enough about my own code to subject it to the cold scrutiny of this list.

On 27/02/13 19:43, Jan Engelhardt wrote:
> On Wednesday 2013-02-27 19:00, Nicole wrote:
>
>> Hi Guys,
>>
>> Call me lazy if you wish, but I thought I'd get a clear answer here.
>> I have written a extension using xtables. It spits out the error message
>> Extension xxxx uses invalid ID nn.
>> What does this mean?
>
> Usually hints towards the fact that your extension uses more than 256
> command-line options.
>
> Our magic glass spheres are, unfortunately, under maintenance until
> further notice. You will have to post more details - such as full
> unabridged source code - before a satisfying assessment can be made as
> to where in your extension the problem lies.
>
