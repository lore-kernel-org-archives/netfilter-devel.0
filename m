From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Wed, 25 Jul 2007 18:17:16 +0200
Message-ID: <46A7778C.2040609@trash.net>
References: <56054.81.207.0.53.1185319467.squirrel@secure.samage.net>	<46A76A0E.8050100@trash.net>
	<44953.81.207.0.53.1185379973.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Indan Zupancic <indan@nul.nu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44953.81.207.0.53.1185379973.squirrel@secure.samage.net>
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

Indan Zupancic wrote:
> On Wed, July 25, 2007 17:19, Patrick McHardy wrote:
> 
>>Indan Zupancic wrote:
>>
>>>Hello,
>>>
>>>After reading the "Never happen" comment in the code, I thought it
>>>wasn't too silly to mention that it apparently does happen. Never saw
>>>the message before, hence this mail. This happened on a machine
>>>doing SNAT for another pc, so conntrack may be involved.
>>>
>>>The three errors happen within 1.5 seconds of each other:
>>>
>>>[17834.377955] ipv4_get_l4proto: Frag of proto 17
>>>[17835.358985] ipv4_get_l4proto: Frag of proto 17
>>>[17835.872457] ipv4_get_l4proto: Frag of proto 17
>>>
>>>As this seems to be an incident, I've no idea how to debug it, nor
>>>whether it's worth debugging. If this can be caused by a peer
>>>sending a bad packet I'd ignore this report.
>>>
>>>If this is serious enough to be reported, perhaps it should be a BUG?
>>
>>It should not be serious, the packets are simply dropped.
> 
> 
> I meant serious in the sense of there being a bug in the code or not.
> If it indicates a bug then it might be better to make it a BUG or
> something else which gives more feedback to make it easier to track
> down. Right now it's not clear where the packet came from and goes to.


There is only one possible path, crashing peoples machines won't help :)
It does indicate a bug, but not a serious one.

>>Did it perhaps happen directly after nf_conntrack_ipv4 module load?
> 
> 
> No, it was loaded for at least a few hours.
> 
> 
>>Otherwise I think it might happen on loopback if you manually send
>>to large packets or possibly with NOTRACK. Any chance you're doing
>>anything of that?
> 
> 
> No idea what NOTRACK is, I've quite simple iptables rules and didn't do
> anything fancy at the time, so I don't think so.
> 
> As far as I can remember I was just browsing at the time, at least doing
> nothing that causes much UDP activity, DNS only. That said, I do run
> dnsmasq locally, so there is some loopback UDP activity, and it's also the
> DNS server for the SNATed host. Fair chance that there was more UDP
> activity from that host though (Quake3).
> 
> If it happens again I'll add extra debugging stuff and hope that it'll
> happen again. Currently it seems it's too vague to debug.


Thanks. One more question: are you running nfs?
