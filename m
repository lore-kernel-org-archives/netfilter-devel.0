From: Brian G <unixman83@gmail.com>
Subject: Re: How to get access to NAT info from userland
Date: Sat, 02 Apr 2011 19:07:15 -0500
Message-ID: <4D97BA33.20205@gmail.com>
References: <4D96DD0E.4020404@gmail.com> <AANLkTi=U8KZ_=ckSJ9yrqsTdG=L3tgtzLcDQ58mS=eRM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36053 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab1DCAH1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Apr 2011 20:07:27 -0400
Received: by iyb14 with SMTP id 14so4758787iyb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2011 17:07:27 -0700 (PDT)
In-Reply-To: <AANLkTi=U8KZ_=ckSJ9yrqsTdG=L3tgtzLcDQ58mS=eRM@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4/2/2011 6:55 PM, Sam Roberts wrote:
> On Sat, Apr 2, 2011 at 1:23 AM, Brian G<unixman83@gmail.com>  wrote:
>> If not, I still need to know the TRUE DESTINATION when using a transparent
>> proxy so I know where to send to request. What needs to added to the kernel
>> (e.g. like an iptables TARGET) to get this info.
> Does the conntrack -L output have the info you'd like?
Probably. Too bad my distro (CentOS) doesn't seem to provide this binary.
> Sam
Brian
