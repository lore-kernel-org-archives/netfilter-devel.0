From: Stephen Clark <Stephen.Clark@seclark.us>
Subject: Re: iptables logging
Date: Fri, 16 Nov 2007 07:24:38 -0500
Message-ID: <473D8C06.9050607@seclark.us>
References: <473CAC9E.6060109@seclark.us> <Pine.LNX.4.64.0711152215190.3340@fbirervta.pbzchgretzou.qr>
Reply-To: Stephen.Clark@seclark.us
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpauth13.prod.mesa1.secureserver.net ([64.202.165.37]:56059
	"HELO smtpauth13.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755190AbXKPMYl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:24:41 -0500
In-Reply-To: <Pine.LNX.4.64.0711152215190.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:

>On Nov 15 2007 15:31, Stephen Clark wrote:
>  
>
>>Hello,
>>
>>Is there a way to have iptables LOG using a facility other than "kern".
>>I would like to
>>segregate out the messages from iptables into a file separate from
>>/var/log/messages.
>>
>>Any advice would be appreciated.
>>    
>>
>
>You should use syslog-ng, which allows text matching and filtering.
>This is from a regular openSUSE install:
>
>	filter f_iptables   { facility(kern) and match("IN=") and match("OUT="); };
>
>Or, you can use the ULOG target together with ulogd2.
>
>
>  
>
Hi Jan,

Thanks for taking the time to reply. I'll check them both out.

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



