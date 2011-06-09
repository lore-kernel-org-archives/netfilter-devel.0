From: Tihomir Katic <tihomir.katic@gmail.com>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 16:07:45 +0200
Message-ID: <BANLkTi=Ggxj5Pv1t8H_S4gqEWGQwP=iWqA@mail.gmail.com>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
	<alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63242 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FIOHt convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:07:49 -0400
Received: by yie30 with SMTP id 30so807733yie.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 07:07:48 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan

Thank you, I downloaded it, but I have to check how to work with GIT.
Now I am sorry I didn't upload this SW sooner.

Some explanation of it can be found in this work
http://biblio.irb.hr/prikazi-rad?&rad=3D310019

But it is pretty old. I am preparing document with 100 pages of
explanation, for now it is in Croatian:-( But code is commented in
English

Basic idea behind this work is to have "static optimizator of iptables
rules" or even some other with modifications. It takes only result of
iptables-save, removes redundant rules, removes unnecessary elements
e.g from multiport array, or even whole matching parameter,  merge
rules, reposition LOG rules later in file. This is not perfect,
because network traffic is probably more important.

I will try to generate some test input files, so you could see how
does it work. All optimization actions are documented in generated
files.


Also, I have been doing some tests, and in config.txt you will see:
## Optimal size of multiport - port array
port_array_size_optimal =3D 10

It means, it will merge 2 rules for example --dport 1:5 and --dport
21:25 into -m multiport --dports 1,2,3,4,5,21,22,23,24,25
but it will not merge them if they have more than 10 elements in array

But, based on my recent tests, it should be
port_array_size_optimal =3D 15

Because
rule with  --dport 1:5  takes e.g. ~0.2 us
and rule with 15 elements in multiport array lasts ~0.4us, so it is
pretty much the same

Br
Tihomir

2011/6/9 Jan Engelhardt <jengelh@medozas.de>:
> On Thursday 2011-06-09 15:18, Tihomir Katic wrote:
>>
>>I developed some firewall optimizer for iptables optimization.
>>
>>FIRO is parsing output of iptables-save command and removes redundant
>>rules from it. Rules in each chain and table are optimized separately=
=2E
>>Optimization procedure continues until there are no more rules to
>>remove or to modify. As a result, FIRO generates new file with new se=
t
>>of rules for every successful optimization procedure. Also, it logs
>>all actions and changes in separated files.
>>
>>List of optimization procedures:
>> - =A0Remove irrelevant rules
>> - =A0Remove redundant "shadowed after" rules
>> - =A0Remove redundant "shadowed before" rules
>> - =A0Remove last rules with same action as chain
>> - =A0Merge rules
>> - =A0Remove redundant parameters from rules
>> - =A0Remove redundant elements from parameters
>> - =A0Reposition of "logging" rules in chain
>>
>>This is free software, 1st published version, and I would appreciate
>>every download, every test, every reported bug, suggestion, etc.
>>
>>Link to FIRO:
>>http://valeria.zesoi.fer.hr/~tkatic
>
> Great idea. Consider
> http://jengelh.medozas.de/documents/Perfect_Ruleset.pdf for more thin=
gs
> to do in rulesets.
>
> Some of the suggestions are not a 1:1 conversion, such as replacing -=
s
> 127.0.0.0/8 by -i lo. In this case, a warning is the most one can do =
in
> an automated fashion, and actually sufficient. -- in the spirit of
> checkpatch.pl.
>
>
> Inbetween, I have created a git repo with Makefiles. If I feel lucky,
> I'll also fix the build in a minute.
>
> =A0 =A0 =A0 =A0git://dev.medozas.de/firo
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
