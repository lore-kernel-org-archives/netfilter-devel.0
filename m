From: Rick Jones <rick.jones2@hp.com>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Wed, 05 Nov 2008 13:02:22 -0800
Message-ID: <491209DE.3060300@hp.com>
References: <490B46F0.4010100@hp.com>	<alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>	<490B544B.50903@hp.com>	<alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0811051922050.6949@ask.diku.dk> <Pine.LNX.4.64.0811052133050.9289@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:24021 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYKEVC1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:02:27 -0500
In-Reply-To: <Pine.LNX.4.64.0811052133050.9289@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> 
>>>  On Friday 2008-10-31 19:54, Rick Jones wrote:
>>> > >  Here is where I cop to being a luddite who prefers straight C to 
>>> calling
>>> >  system() :)
> 
> 
> Using libiptc, here is the C-program you need:
> 
> --- cut here ---
> #include <stdio.h>
> #include <libiptc/libiptc.h>
> 
> main(int argc, char *argv[])
> {
>     char *table = "filter";
>     const char             *chain;
>     const struct ipt_entry *rule;
>     iptc_handle_t handle = NULL;
>     unsigned int num_chains = 0;
>     unsigned int num_rules  = 0;
> 
>     handle = iptc_init(table);
>     //dump_entries(handle);
> 
>     chain = iptc_first_chain(&handle);
>     while (chain) {
>         //printf("Chain:%s\n", chain);
>         num_chains++;
> 
>         rule = iptc_first_rule(chain, &handle);
>         while (rule) {
>             num_rules++;
>             rule = iptc_next_rule(rule, &handle);
>         }
>         //printf("Rules so far:%u\n", num_rules);
> 
>         chain = iptc_next_chain(&handle);
>     }
> 
>     printf("Number of chains:%u\n", num_chains);
>     printf("Number of rules:%u\n", num_rules);
> }
> --- cut here ---
> 

Thanks - indeed I have code very much like that already in my initial 
prototype.  Biggest difference is I check every table listed under 
/proc/net/mumble :)  I'm still trying to decipher what the parsing code 
in libiptc is doing so see how much work it would be for me to create 
braindead rule counting code.

I could I suppose just drop back and not worry about counting rules per 
se, but just arriving at a rules vs no rules decision somehow.

rick jones
