From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: Re: NAT pool
Date: Tue, 18 Dec 2012 19:53:46 -0600
Message-ID: <CAOSBYzeWpv_+eoYKHnfkcUctRiDDRDk4=fLOcGsY2usWXA6VPg@mail.gmail.com>
References: <CAOSBYzcjkZiPA7zFC62OoQGdzTiw7c4aavvBE1_FM+Su1x5Mxg@mail.gmail.com>
	<alpine.LNX.2.01.1212182348580.8238@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:35658 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2LSBxr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:53:47 -0500
Received: by mail-qc0-f173.google.com with SMTP id b12so774372qca.4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Dec 2012 17:53:46 -0800 (PST)
In-Reply-To: <alpine.LNX.2.01.1212182348580.8238@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cool, well I want to use it for a NAT64 module where are developing...
right now we have a pool developed from scratch. It would have to
handle a ip range and protocol range... but I think the implementation
you guys have already does this.

I guess the file I have to include is:

Linux/include/uapi/linux/netfilter/nf_nat.h

Would you care to explain how can I use it or what codes should I read
to see how it works...

Regards!

On Tue, Dec 18, 2012 at 4:58 PM, Jan Engelhardt <jengelh@inai.de> wrote=
:
> On Tuesday 2012-12-18 23:32, Miguel Alejandro Gonz=E1lez wrote:
>
>>I was wondering how the pool of ipv4 addresses works in netfilter. I
>>know you can configure a range or subnet from iptables when you are
>>configuring NAT.I was reading some NAT code from the kernel, but I
>>think it just checks if the packet's address is in the range
>>specified.
>
> get_unique_tuple() makes sure they don't overlap.
>
>>I guess my main question is, if there is a ipv4 pool implementation i=
n
>>netfilter. If so, can it be used by other modules?
>
> As much as other modules are already using it.
> The question should not be whether it can be used, but whether it can=
 be
> used for what.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
