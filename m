From: Tom Hacohen <tom@stosb.com>
Subject: Re: nftables: masquerade sets wrong source address
Date: Thu, 22 Dec 2016 10:26:52 +0000
Message-ID: <CAEvi_o96hh=ZfkofcjswUEDeH1Pi6wGD99qV+k87B=Z+QM-78w@mail.gmail.com>
References: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
 <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com>
 <CAEvi_o-7soTh5vPqniCo76Szbf7J1y6nwwD-YqJ5uJvOYSeVHw@mail.gmail.com> <CAML_gOfxzY9iWefK8Vw8kxYXNmOrZBmouO=PfMxtyz4jfp=13g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CAML_gOfxzY9iWefK8Vw8kxYXNmOrZBmouO=PfMxtyz4jfp=13g@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Dec 21, 2016 at 2:39 AM, Liping Zhang <zlpnobody@gmail.com> wrote:
> 2016-12-20 23:16 GMT+08:00 Tom Hacohen <tom@stosb.com>:
>> On Sat, Dec 17, 2016 at 2:18 PM, Liping Zhang <zlpnobody@gmail.com> wrote:
>>> According to the explanations in nftables wifi:
>>> https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)
>>>
>>> You should add the following nft rules(I agree this is tricky and
>>> unfriendly for the end user):
>>> # nft add chain nat prerouting { type nat hook prerouting priority 0 \; }
>>>
>>> But unfortunately,  even if you add the above rule, you will still fail to
>>> connect to a local server.
>>>
>>
>> Correct, doesn't change anything.
>>
>>> Now add another nft rules listed below, you can probably make everything
>>> work fine:
>>> # nft add chain nat output { type nat hook output priority 0 \; }
>>>
>>
>> Haven't tried it. Why would it change things? Have you tried it?
>
> I tried it and it did take effect. But my test scenario may be
> different with yours.
> So can you try it?

Tried it, and it works.

>
> [...]
>>> In iptables, nat output chain always exists, so there's no
>>> such problem.
>>>
>>> But I think that enforcing the user to add a nat output chain
>>> in nftables is not a good idea, so probably we need a following
>>> patch(I only list the ipv4 part):
>>
>> Interesting. Maybe that's why it continued to work after iptables has
>> already been loaded on the box.
>> As said above though, I believe the problem is the masquerade setting
>> the wrong ip, and not (only?)
>> the fact that my setup happens to work with iptables but doesn't with nftables.
>
> As I analyzed, the main difference is that nat OUTPUT hook always
> exist in iptables, so the reply packet's destination ip address will be modified
> in OUTPUT hook. While in nftables, without nft output chain, the reply packet's
> destination ip address will be modified in PREROUTING hook. Then we try to
> do routing lookup, and the packets will be dropped because the incoming packets'
> destination ip address is 127.0.0.1
>
> But I think that enforcing the user  to add the following nft rule is
> not friendly:
> # nft add chain nat output { type nat hook output priority 0 \; }
>
> This will become more tricky. Do you agree with this?
>
> So I send the related patch to try to improve it.

It's definitely not user friendly to have to add it, especially since
I expected having a chain with no rules to be a noop.
I don't know how nftables works well enough to comment on one design
choice or another, so I can't comment if this needs to be fixed, but
this definitely feels inconsistent and buggy.

I'm sorry for repeating myself, however I'd like to stress out again,
that while your workaround fixes an inconsistency between iptables and
nftables, the scenario itself is caused by the buggy behaviour of
masquerade with "lo", and that needs to be fixed too. The workaround
above, and any fixes to that issue will only fix the dropping of the
packets, but the wrong rewrite will still be there.

Please let me know if there's anything else you'd like me to test.

--
Tom.
