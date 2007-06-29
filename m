From: Patrick McHardy <kaber@trash.net>
Subject: Re: mss to pmtu clamping partially broken?
Date: Fri, 29 Jun 2007 14:03:07 +0200
Message-ID: <4684F4FB.9070807@trash.net>
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
To: Andreas Steinmetz <ast@domdv.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765065AbXF2MD1@vger.kernel.org>
In-Reply-To: <4684F3D8.1080800@domdv.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Andreas Steinmetz wrote:
> Patrick McHardy wrote:
> 
>>Andreas Steinmetz wrote:
>>
>>>[...]
>>>The tcpdump on the client shows that the mss of the incoming syn reply
>>>packet is *NOT* clamped to the ppp interface mtu.
>>
>>
>>You forgot to mention *how* you're clamping the MSS. Using
>>TCPMSS? Do you have a rule for incoming packets?
>>
> 
> 
> The relevant iptables commands I do use for masquerading and clamping are:
> 
> iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
> iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS \
> 	--clamp-mss-to-pmtu


Two things here:

- tcpdumps on ppp0 will show unclamped packets since they haven't
been forwarded yet

- assuming you have ethernet internally, the PMTU from your router
to the internal hosts is 1500, so it won't do any clamping.

Does that explain it?

A useful thing for TCPMSS for routers would be to clamp to the
minimum of the PMTU of both directions. But thats not supported
so far.
