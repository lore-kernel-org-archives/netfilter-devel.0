From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Compiler warnings on libnetfilter_*
Date: Wed, 24 Dec 2008 20:13:45 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812222324030.27814@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr> <495012D7.2080002@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45870 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYLXTNr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Dec 2008 14:13:47 -0500
In-Reply-To: <495012D7.2080002@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-12-22 23:21, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> Hi,
>> 
>> I have compiled all the libnetfilter* libraries and conntrack-tools,
>> and this is the collection of compiler warnings I obtained.
>> (Note: running a silenced automake is a big win.)
>
>Is there already an option to silence automake? I found your patches in
>the automake ML but I didn't find them in the official tree.

It is currently underway. If you do not like the wait, you can
of course patch your automake. Lucky users of openSUSE Linux can
also grab an rpm from my distro.

>> + make -j2
>> Making all in conntrack
>> make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/conntrack'
>>   CC       api.lo
>>   CC       callback.lo
>> mkdir: cannot create directory `.libs': File exists
>
>I did not know this one.

Oh this is due to the compiler command line having `mkdir .libs` in it,
and running with -jN with N >= 2, multiple mkdir invocations can run
at the same time. It is perfectly normal.

>> callback.c: In function '__callback':
>> callback.c:30: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
>> api.c: In function 'nfct_parse_conntrack':
>> api.c:668: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
>
>A casting should fix this?

void __parse_conntrack(const struct nlmsghdr *nlh,                              
                       const struct nfattr *cda[],                              
                       struct nf_conntrack *ct)                                 


int __callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data)          
{
       __parse_conntrack(nlh, nfa, ct);                                        
}


A const_cast() [1] should do ;-)


[1] http://jengelh.medozas.de/2008/1224-typechecking-casts.php
