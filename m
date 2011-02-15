From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: any way to reset all marked connections when using CONNMARK?
Date: Tue, 15 Feb 2011 16:06:02 -0600
Message-ID: <4D5AF8CA.8080908@genband.com>
References: <4D55A927.7060703@genband.com> <1297510935.1770.38.camel@andybev>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter <netfilter@vger.kernel.org>
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:38281 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab1BOWH7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:07:59 -0500
In-Reply-To: <1297510935.1770.38.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/12/2011 05:42 AM, Andrew Beverley wrote:
> On Fri, 2011-02-11 at 15:24 -0600, Chris Friesen wrote:
>> It has been proposed to add a custom patch to clear the mark for all
>> marked connections--is there a better way of doing this?
>>
> 
> How about using the conntrack userspace command-line interface?
> 
> conntrack -U -m 0
> 
> looks like it should do what you want.

Oooh, that looks perfect.

For some reason the online man pages for conntrack don't seem to be up
to date...they don't have the -U option.  It's listed in the package
itself though.

Thanks,
Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
