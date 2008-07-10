From: Manu <manuprivat@gmx.de>
Subject: Re: RAWNAT kernel crash
Date: Thu, 10 Jul 2008 13:23:26 +0200
Message-ID: <4875F12E.3010709@gmx.de>
References: <4875D2DC.9040107@gmx.de> <alpine.LNX.1.10.0807101119180.27323@fbirervta.pbzchgretzou.qr> <4875DCD0.9070107@gmx.de> <alpine.LNX.1.10.0807101209050.27323@fbirervta.pbzchgretzou.qr> <4875EF77.8060700@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40558 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752310AbYGJLXR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:23:17 -0400
In-Reply-To: <4875EF77.8060700@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Manu schrieb:
> Jan Engelhardt schrieb:
>> (and don't strip the mailing list from cc)
>>
>> On Thursday 2008-07-10 11:56, Manu wrote:
>>   
>>>>> I can set the rules but everytime I want to send traffic through the rules
>>>>> I got a system crash!?
>>>>>         
>>>> I will investigate... I assume you do have dcd0c66 at least?
>>>>   
>>>>       
>>> I don't know what you mean with dcd0c66. I downloaded the snapshot of
>>> 2008-04-28
>>>     
>>
>> Ah ok, if you click on that you will see "commit
>> dcd0c661355bc5ff95d3a587c49fa59d8c4a8fef"
>>
>>   
>>>> Posting the crash would be helpful.
>>>>       
>>> What exactly do you mean with posting the crash?
>>>     
>>
>> Kernel log, oops dump. If you just say "crash", then that could be
>> anything, with cosmic rays to begin.
>>
>>   
> maybe this is already helpful - i will work on further informations 
> about the "crash"
>
>
> <3>compat_xtables: compat layer limits reached 
> (xtnu_skb_make_writable) - dropping packets
> <3>compat_xtables: compat layer limits reached 
> (xtnu_skb_make_writable) - dropping packets
> <1>BUG: unable to handle kernel NULL pointer dereference at virtual 
> address 00000004
> <1> printing eip:
> <4>c02acd98
> <1>*pde = 00000000
> <0>Oops: 0002 [#1]
> <0>PREEMPT
> <4>Modules linked in: iptable_rawpost xt_RAWNAT compat_xtables ebt_ip 
> ebtable_nat ebtables sch_sfq cls_fw cls_u32 sch_htb tun 8021q 8139too 
> cramfs
> <0>CPU:    0
> <0>EIP:    0060:[<c02acd98>]    Not tainted VLI
> <0>EFLAGS: 00010047   (2.6.23.9-default #26)
> <0>EIP is at skb_dequeue+0x21/0x4d
> <0>eax: 00000000   ebx: c4cf93c0   ecx: 00000246   edx: c5a06c60
> <0>esi: c5a06c00   edi: 00000000   ebp: c512fe2c   esp: c512fdfc
> <0>ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
>
>

