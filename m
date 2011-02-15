From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: any way to reset all marked connections when using CONNMARK?
Date: Tue, 15 Feb 2011 23:42:49 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102152342380.18599@obet.zrqbmnf.qr>
References: <4D55A927.7060703@genband.com> <1297510935.1770.38.camel@andybev> <4D5AF8CA.8080908@genband.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Beverley <andy@andybev.com>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	netfilter <netfilter@vger.kernel.org>
To: Chris Friesen <chris.friesen@genband.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56188 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab1BOWmv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:42:51 -0500
In-Reply-To: <4D5AF8CA.8080908@genband.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-02-15 23:06, Chris Friesen wrote:
>On 02/12/2011 05:42 AM, Andrew Beverley wrote:
>> On Fri, 2011-02-11 at 15:24 -0600, Chris Friesen wrote:
>>> It has been proposed to add a custom patch to clear the mark for all
>>> marked connections--is there a better way of doing this?
>>>
>> 
>> How about using the conntrack userspace command-line interface?
>> 
>> conntrack -U -m 0
>> 
>> looks like it should do what you want.
>
>Oooh, that looks perfect.
>
>For some reason the online man pages for conntrack don't seem to be up
>to date...they don't have the -U option.  It's listed in the package
>itself though.

What online manpages are you referring to?
