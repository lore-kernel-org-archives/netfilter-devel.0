From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 09 Dec 2010 13:08:04 +0100
Message-ID: <4D00C6A4.6090305@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 26/11/10 20:01, Jozsef Kadlecsik wrote:
> Hi Jan,
> 
> On Wed, 24 Nov 2010, Jan Engelhardt wrote:
> 
>> By request of Pablo, I am posting the Xtables2 Netlink interface 
>> specification for review. Additionally, further documentation and 
>> toolchain around it is available through the temporary project page at
>>
>> 	http://jengelh.medozas.de/projects/xtables/
>>
>> which currently includes
>>
>>  * User Documentation Chapter 1: Architectural Differences
>>
>>  * Developer Documentation Part 1: Netlink interface (WIP)
>>    This is copied below to facilitate inline replies
>>
>>  * Runnable Linux source tree
>>
>>  * Runnable userspace library (libnetfilter_xtables)
>>    with small test-and-debug program
> [...]
> 
> Please add fine-grained error reporting to the protocol: in my opinion the 
> main shortcoming of the current kernel-userspace xtables protocol is the 
> lack of the proper error reporting. I mean, the new protocol should be 
> able to carry back which rule caused the error, in the rule whether it was 
> a general kind of error (ENOMEM), or a table, chain, match or target error 
> and exactly what was the error at table/chain/match/target level.
> 
> Say, the TCPMSS target should be able to report back that it cannot be 
> used outside of FORWARD, OUTPUT and POSTROUTING. Or that the rule must 
> match TCP SYN packets.

If we follow the one message per rule basis, you can put several
messages into one batch with different sequence numbers. Thus, you can
know what message in the batch has triggered the error and the reason.
