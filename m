From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: nft: parser problem, can use mark as datatype in sets and maps
Date: Tue, 11 Aug 2015 14:28:06 +0200
Message-ID: <55C9EA56.1020302@tpip.net>
References: <1027218717.2766569.1439214492178.JavaMail.zimbra@tpip.net> <20150810170920.GA3487@salvia> <55C9BDFE.9080207@tpip.net> <20150811102635.GA3622@salvia> <55C9DBA1.3070806@tpip.net> <20150811121212.GA3272@salvia> <20150811122339.GA4304@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:38809 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934075AbbHKM2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2015 08:28:10 -0400
In-Reply-To: <20150811122339.GA4304@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 08/11/2015 02:23 PM, Pablo Neira Ayuso wrote:
> On Tue, Aug 11, 2015 at 02:12:12PM +0200, Pablo Neira Ayuso wrote:
>> On Tue, Aug 11, 2015 at 01:25:21PM +0200, Andreas Schultz wrote:
>>> On 08/11/2015 12:41 PM, Pablo Neira Ayuso wrote:
>>>> On Tue, Aug 11, 2015 at 11:18:54AM +0200, Andreas Schultz wrote:
>>>>> On 08/10/2015 07:09 PM, Pablo Neira Ayuso wrote:
>>>>>> On Mon, Aug 10, 2015 at 03:48:12PM +0200, Andreas Schultz wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> The data type definition for mark and the general idea of the parser
>>>>>>> indicate that the following nft statements should work:
>>>>>>>
>>>>>>>    # nft add map filter MAP1 { type ipv4_addr : mark\; }
>>>>>>>    # nft add set filter SET1 { type mark\; }
>>>>>>>
>>>>>>> However, both fail with a similar error message:
>>>>>>>
>>>>>>>    <cmdline>:1:40-43: Error: syntax error, unexpected mark, expecting string
>>>>>>>    add map filter MAP1 { type ipv4_addr : mark; }
>>>>>>>    <cmdline>:1:28-31: Error: syntax error, unexpected mark, expecting string
>>>>>>>    add set filter SET1 { type mark; }
>>>>>>>
>>>>>>> The problem is parser, it expects a string as data type spec, but
>>>>>>> mark is already declared as a token.
>>>>>>>
>>>>>>> I don't have much experience with bison, so does anyone have a quick
>>>>>>> work-around for this?
>>>>>>
>>>>>> This is fixed by 2baf59c ("parser_bison: allow to use mark as datatype
>>>>>> for maps and sets").
>>>>>
>>>>> Ah, I was using the next-4.2 branch and missed this fix in master,
>>>>> sorry for the noise.
>>>>>
>>>>> However, the parser problem is solved, but named mark maps are still
>>>>> not working:
>>>>>
>>>>> anonymous maps work as expected:
>>>>>
>>>>>    # nft add rule ip mangle OUTPUT mark set ip saddr map {
>>>>> 192.168.0.10 : 0x1 }
>>>>>
>>>>> named maps do not:
>>>>>
>>>>>    # nft add map mangle CLASS05 "{ type ipv4_addr : mark; }"
>>>>>    # nft add element mangle CLASS05 { 192.168.0.10 : 0x1 }
>>>>>    # nft add rule ip mangle OUTPUT mark set ip saddr map @CLASS05
>>>>>    <cmdline>:1:1-56: Error: Could not process rule: Invalid argument
>>>>>
>>>>> Any idea?
>>>>
>>>> This is working fine here with a nf.git tree snapshot.
>>>>
>>>> table ip mangle {
>>>>          map CLASS05 {
>>>>                  type ipv4_addr : mark
>>>>                  elements = { 192.168.0.10 : 0x00000001}
>>>>          }
>>>>
>>>>          chain OUTPUT {
>>>>                  type route hook output priority 0; policy accept;
>>>>                  mark set ip saddr map @CLASS05
>>>>          }
>>>> }
>>>
>>> When I put that into a file and try to restore it, I get this:
>>>
>>> # nft -f /tmp/map.nft
>>> /tmp/map.nft:4:28-54: Error: mapping outside of map context
>>>                  elements = { 192.168.0.10 : 0x00000001}
>>>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>>> What Linux kernel version are you using? Remember that concatenation
>>>> support is there since 4.1.
>>>
>>> Userland:
>>>
>>> git://git.netfilter.org/libnftnl  branch master @ HEAD (0edeb66)
>>> git://git.netfilter.org/nftables  branch master @ HEAD (ecf855b)
>>
>> Please, give a try to this branch:
>>
>> http://git.netfilter.org/nftables/log/?h=cache-consolidation
>
> Wait, I was testing by loading via nft -f with a linear representation:
>
> add table mangle
> add chain mangle OUTPUT { type route hook output priority 0; }
> add map mangle CLASS05 { type ipv4_addr : mark; }
> add element mangle CLASS05 { 192.168.0.10 : 0x1 }
> add rule ip mangle OUTPUT mark set ip saddr map @CLASS05
>
> So I confirm I'm hitting the problem that you're reporting above. Let
> me have a look into this.

I have now rebuild the kernel from David's net-next tree and nftables 
userspace with the cache-consolidation branch applied. The test
give somewhat mixed results:

* nft -f with the linear representation works
* nft -f with the structured representation fails with:

/tmp/map2.nft:4:28-54: Error: mapping outside of map context
		elements = { 192.168.0.10 : 0x00000001}
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^

* running each command separately, like so:

   # nft add table mangle
   # nft add chain mangle OUTPUT { type route hook output priority 0\; }
   # nft add map mangle CLASS05 "{ type ipv4_addr : mark; }"
   # nft add element mangle CLASS05 { 192.168.0.10 : 0x1 }
   # nft add rule ip mangle OUTPUT mark set ip saddr map @CLASS05

fails on the last command with:

<cmdline>:1:1-56: Error: Could not process rule: Invalid argument
add rule ip mangle OUTPUT mark set ip saddr map @CLASS05
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Andreas
