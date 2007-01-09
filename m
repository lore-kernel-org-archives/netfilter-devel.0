From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Bug] OOPS with nf_conntrack_ipv6, probably fragmented UDPv6
Date: Tue, 09 Jan 2007 12:50:11 +0100
Message-ID: <45A38173.9090305@trash.net>
References: <459D322F.5010707@birkenwald.de> <45A63D72.2060405@trash.net> <45A37F5F.2030501@birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751253AbXAILuP@vger.kernel.org>
To: Bernhard Schmidt <berni@birkenwald.de>
In-Reply-To: <45A37F5F.2030501@birkenwald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Bernhard Schmidt wrote:
> Patrick McHardy wrote:
> 
>>> I've hit another kernel oops with 2.6.20-rc3 on i386 platform. It is
>>> reproducible, as soon as I load nf_conntrack_ipv6 and try to send
>>> something large (scp or so) inside an OpenVPN tunnel on my client
>>> (patched with UDPv6 transport) the router (another box) OOPSes.
>>>
>>> tcpdump suggests the problem appears as soon as my client sends
>>> fragmented UDPv6 packets towards the destination. It does not happen
>>> when nf_conntrack_ipv6 is not loaded. This is the OOPS as dumped from
>>> the serial console:
>>
>> Does this patch help?
> 
> 
> Yes, seems to be working fine.

Thanks, I'll send it upstream tonight.

> Can you tell since when this bug is in the kernel?

The real bug is in nf_conntrack and probably has been there since
the beginning (which I think is about 1.5 years ago). It blows up
in combination with the GSO code, which I believe was added in
2.6.18-rc, but it might have caused troubles somewhere else before.
