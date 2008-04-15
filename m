From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/10] Remove old functions, constants
Date: Tue, 15 Apr 2008 13:50:19 +0200
Message-ID: <4804967B.40104@trash.net>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de> <7c7d0eb43b7b4ca3711ae0dbe17ae7ef66fb02f8.1208255176.git.jengelh@computergmbh.de> <480495C1.9060509@trash.net> <alpine.LNX.1.10.0804151348470.13202@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34979 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbYDOLuY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:50:24 -0400
In-Reply-To: <alpine.LNX.1.10.0804151348470.13202@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-15 13:47, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> 	printf(
>>> -"LOG v%s options:\n"
>>> +"LOG target options:\n"
>>> " --log-level level		Level of logging (numeric or see
>>> syslog.conf)\n"
>>> -" --log-prefix prefix		Prefix log messages with this
>>> prefix.\n\n"
>>> -" --log-tcp-sequence		Log TCP sequence numbers.\n\n"
>>> -" --log-tcp-options		Log TCP options.\n\n"
>>> -" --log-ip-options		Log IP options.\n\n"
>>> -" --log-uid			Log UID owning the local socket.\n\n",
>>> -IPTABLES_VERSION);
>>> +" --log-prefix prefix		Prefix log messages with this
>>> prefix.\n"
>>> +" --log-tcp-sequence		Log TCP sequence numbers.\n"
>>> +" --log-tcp-options		Log TCP options.\n"
>>> +" --log-ip-options		Log IP options.\n"
>>> +" --log-uid			Log UID owning the local socket.\n");
>>>  }
>>
>> This doesn't match the patch description. Why are you
>> changing help texts?
>>
> These are just the newlines; to follow the style of the other extensions.
> 

OK, I'll apply it.
