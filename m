From: Patrick McHardy <kaber@trash.net>
Subject: Re: mss to pmtu clamping partially broken?
Date: Fri, 29 Jun 2007 14:13:18 +0200
Message-ID: <4684F75E.90304@trash.net>
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net> <4684F5D3.8020506@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
To: Andreas Steinmetz <ast@domdv.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765822AbXF2MNk@vger.kernel.org>
In-Reply-To: <4684F5D3.8020506@domdv.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Andreas Steinmetz wrote:
> Patrick McHardy wrote:
> 
>>- assuming you have ethernet internally, the PMTU from your router
>>to the internal hosts is 1500, so it won't do any clamping.
>>
> 
> 
> Yep, internal PMTU is 1500, still the incoming packets are clamped to
> 1452 on the one line and not clamped on the other.
> 
> 
>>Does that explain it?
>>
>>A useful thing for TCPMSS for routers would be to clamp to the
>>minimum of the PMTU of both directions. But thats not supported
>>so far.
>>
> 
> 
> I wonder, as somteimes it gets clamped. If it would never have been
> clamped I wouldn't have asked.


Its possible that one of your ISPs is doing clamping. You could
check on ppp0 if thats the case. Or maybe for some reason the
PMTU value for the internal host is smaller than 1500. You can
check that by doing "ip route get <internal host>".
