From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: nftables: masquerade sets wrong source address
Date: Wed, 21 Dec 2016 10:39:24 +0800
Message-ID: <CAML_gOfxzY9iWefK8Vw8kxYXNmOrZBmouO=PfMxtyz4jfp=13g@mail.gmail.com>
References: <CAEvi_o9_SJNGH-RWq6Kt+UiXVY4ozaMy3yJ2rPdV0Rbk1QrRZw@mail.gmail.com>
 <CAML_gOdZn8UmZzeDWd6q--U9+f+SzBLMppCEtdCFsZ4rrTZ24A@mail.gmail.com> <CAEvi_o-7soTh5vPqniCo76Szbf7J1y6nwwD-YqJ5uJvOYSeVHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Tom Hacohen <tom@stosb.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CAEvi_o-7soTh5vPqniCo76Szbf7J1y6nwwD-YqJ5uJvOYSeVHw@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

2016-12-20 23:16 GMT+08:00 Tom Hacohen <tom@stosb.com>:
> On Sat, Dec 17, 2016 at 2:18 PM, Liping Zhang <zlpnobody@gmail.com> wrote:
>> According to the explanations in nftables wifi:
>> https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)
>>
>> You should add the following nft rules(I agree this is tricky and
>> unfriendly for the end user):
>> # nft add chain nat prerouting { type nat hook prerouting priority 0 \; }
>>
>> But unfortunately,  even if you add the above rule, you will still fail to
>> connect to a local server.
>>
>
> Correct, doesn't change anything.
>
>> Now add another nft rules listed below, you can probably make everything
>> work fine:
>> # nft add chain nat output { type nat hook output priority 0 \; }
>>
>
> Haven't tried it. Why would it change things? Have you tried it?

I tried it and it did take effect. But my test scenario may be
different with yours.
So can you try it?

[...]
>> In iptables, nat output chain always exists, so there's no
>> such problem.
>>
>> But I think that enforcing the user to add a nat output chain
>> in nftables is not a good idea, so probably we need a following
>> patch(I only list the ipv4 part):
>
> Interesting. Maybe that's why it continued to work after iptables has
> already been loaded on the box.
> As said above though, I believe the problem is the masquerade setting
> the wrong ip, and not (only?)
> the fact that my setup happens to work with iptables but doesn't with nftables.

As I analyzed, the main difference is that nat OUTPUT hook always
exist in iptables, so the reply packet's destination ip address will be modified
in OUTPUT hook. While in nftables, without nft output chain, the reply packet's
destination ip address will be modified in PREROUTING hook. Then we try to
do routing lookup, and the packets will be dropped because the incoming packets'
destination ip address is 127.0.0.1

But I think that enforcing the user  to add the following nft rule is
not friendly:
# nft add chain nat output { type nat hook output priority 0 \; }

This will become more tricky. Do you agree with this?

So I send the related patch to try to improve it.

>
> Don't you agree?
>
> Thanks,
> Tom.
