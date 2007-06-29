From: Andreas Steinmetz <ast@domdv.de>
Subject: Re: mss to pmtu clamping partially broken?
Date: Fri, 29 Jun 2007 14:06:43 +0200
Message-ID: <4684F5D3.8020506@domdv.de>
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net>
	<4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4684F4FB.9070807@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Andreas Steinmetz wrote:
>> Patrick McHardy wrote:
>>
>>> Andreas Steinmetz wrote:
>>>
>>>> [...]
>>>> The tcpdump on the client shows that the mss of the incoming syn reply
>>>> packet is *NOT* clamped to the ppp interface mtu.
>>>
>>> You forgot to mention *how* you're clamping the MSS. Using
>>> TCPMSS? Do you have a rule for incoming packets?
>>>
>>
>> The relevant iptables commands I do use for masquerading and clamping are:
>>
>> iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
>> iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS \
>> 	--clamp-mss-to-pmtu
> 
> 
> Two things here:
> 
> - tcpdumps on ppp0 will show unclamped packets since they haven't
> been forwarded yet
> 

That is true, I know this.

> - assuming you have ethernet internally, the PMTU from your router
> to the internal hosts is 1500, so it won't do any clamping.
> 

Yep, internal PMTU is 1500, still the incoming packets are clamped to
1452 on the one line and not clamped on the other.

> Does that explain it?
> 
> A useful thing for TCPMSS for routers would be to clamp to the
> minimum of the PMTU of both directions. But thats not supported
> so far.
> 

I wonder, as somteimes it gets clamped. If it would never have been
clamped I wouldn't have asked.

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
