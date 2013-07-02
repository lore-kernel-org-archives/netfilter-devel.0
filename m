From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH nft] src: add xt compat support
Date: Tue, 02 Jul 2013 12:04:20 +0300
Message-ID: <51D29794.9020301@linux.intel.com>
References: <1372608125-28734-1-git-send-email-pablo@netfilter.org> <51D12B42.40806@linux.intel.com> <20130701222020.GA4082@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, eric@regit.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36357 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab3GBJJp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:09:45 -0400
In-Reply-To: <20130701222020.GA4082@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> To me I see iptables-nftables being the only entry point for legacy
>> >commands, and nowhere else.
> We can add native nft interfaces to several of the existing xt
> matches/targets, no need to reimplement all of them from scratch, we
> can reuse many of the existing xt extensions by adding nft interfaces.
>
> If iptables-nftables starts translating existing matches/targets to
> native nft expressions, users will get their rule-set automatically
> translated to native nft expressions. Thus, they will get rid of the
> old rule expressed using the binary xt interface with no work at all.
> That can happen progressively, as iptables-nftables will provide more
> and more native replacements.

Yes that has been the plan and I am committed to it, a patch is coming 
soon. We will translate, little by little, all xt matches/targets to nft 
expressions.
Through iptables-nftables: it will be fully transparent for the user.

But your patch is bringing the old iptables-like commands into nft, and 
I think it's not a good idea.
Users will have 2 totally different ways to express something in the 
same tool:
  - One very flexible, new, based on a small subset of expressions: the 
nft way.
  - And one based on the iptables way, which is of course following a 
different format than nft commands and misleading in case of the xt 
match/target not using the xt compat expression anymore.

Let's say an xt match M. User uses nft to add a rule using M:

nft add rule ip filter xt M [ <M match options> ] drop

But what's the user does not know, is that the xt match M will generate 
pure nft expressions, not using the xt compat expression (no memory blob 
etc...)
Then: (let's say M matches tcp protocol, port 12345)

nft list table filter

table global {
     chain filter input {
         ip protocol 6 tcp dport 12345 drop
     }
}

It's misleading. The user is not retrieving his command here. I am 
pretty sure lots of users will complain about that. (and you know bad 
habits are tough: users will also argue to keep such iptables-like 
mixing forever)
And it's going to happen fast, since I believe a lot of xt extensions 
can be expressed already as pure nft expressions (tcp, snat/dnat, ...).

Imho, as long as a user wants to use iptables-like matches/targets: he 
should use only iptables-nftables. He will stay with the old fashioned 
way of managing chains, rules...
The day he want to move to nft due to the fact it brings much more 
features, flexibility and so on... he will use nft, and its command 
format. No mixing.

We can enforce that in nft: if an xt match/target is found, we print a 
warning so they should use  iptables-nftables instead for handling those.
And we print a partial output only: like: ip xt_match <a_match_name> 
xt_target <a_target_name>, and of course nft -f is not going to handle such.

I understand your point of bringing this feature to the users (for full 
retro-compat issue), but somehow I feel it's going to be a hassle 
finally, and it won't help the users to fully move on properly with nft.
We have to force them ;) "Want iptables way of doing thing: use 
iptables-nftables. Want the new features and flexibility: use nft".


Tomasz

