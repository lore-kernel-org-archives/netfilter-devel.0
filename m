From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]  - ipsecrx match - was Re: Writing iptables	IPSEC	reception
 support.
Date: Mon, 05 Apr 2004 03:27:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4070B5F4.7010903@trash.net>
References: <1080772179.5070.9.camel@knox.wgtn.cat-it.co.nz>	 <20040401004343.GS1616@sunbeam.de.gnumonks.org>	 <406B73E1.6020504@trash.net>	 <1080793472.1768.14.camel@knox.wgtn.cat-it.co.nz>	 <406C07B7.90601@trash.net> <1080861835.3750.17.camel@knox.wgtn.cat-it.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Grant <grantma@anathoth.gen.nz>
In-Reply-To: <1080861835.3750.17.camel@knox.wgtn.cat-it.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matthew Grant wrote:
> Patrick,
> 
> Isn't there room for both ways of doing it?

I don't think we need this match. The policy match offers a more
generic way for matching if a packet came from a tunnel. It works
in input and output, in tunnel and transport mode. This match only
supports input side in tunnel mode, and it needs to touch other
code.

> I have read the Web CVS for the policy match and you have only checked
> in IPv4.

Right, but it the only IPv4-specific thing it does is comparing the
tunnel endpoints.

> There is a security hole with the way iptables has to be set up to allow
> traffic in off the 2.6 IPSEC that allows packet injection off the
> immediate external ethernet.
> 
> The solution I have got is simple, and it also supports IPv6, and it
> closes the above hole by matching decapsulated traffic off the IPSEC
> tunnel.  We have a VPN network at work that we need to convert to racoon
> and the new IPSEC stack, and this problem needs to be sorted because of
> security auditing reasons.
> 
> The question is, how soon can you get the policy match in the mainline
> netfilter releases?  How well is it working? Do you support IPv6 yet? On
> reading the code it looks simple, so it should be easy to get right.  I
> could if you want get the thing finished if that is the preferred way to
> get things done.

Personal use and reports indicate it's working fine. It doesn't touch
other code, so it can't break anything. More testing is of course
welcome.

> Could you please let me know how you are placed.  A good solution is put
> the fix I have in now, and then add yours when it is ready.  They both
> do not stomp on each others toes, and can coexist together.

I guess I'll add an IPv6 counterpart, but I can't tell you when it's
going to get submitted. I don't think we should add your patch until
then for these reasons:

1. we have a working solution available as patch
2. we don't want to put it in and rip it out again after a short time
3. it's clearly no permanent solution.

Regards
Patrick

> 
> Thank you very much for your time and help.
> 
> Regards,
> 
> Matthew Grant
> 
> PS: I am also the Debian Maintainer for ipsec-tools and racoon packages.
> 
> On Fri, 2004-04-02 at 00:14, Patrick McHardy wrote:
> 
>>Matthew Grant wrote:
>>
>>>Patrick,
>>>
>>>Have written new patches.  Basically they just mark packets that came
>>>from IPSEC by setting a bit in the nfcache field in the skbuff. 
>>>Inspired by the longstanding nfmark feature.  Had to write quickly as I
>>>need a solution to this problem for security reasons.  Far simpler than
>>>the secpath stuff you wrote.
>>>
>>>I have attached the patches.  Not ready for patch-o-matic yet, but what
>>>do you think?
>>
>>I think we need more flexibility than this. The policy match allows you
>>to match --pol ipsec/none, but both ways.
>>
>>Regards
>>Patrick
>>
>>
>>>Cheers,
>>>
>>>Matthew Grant
>>
> 
