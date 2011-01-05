From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: Xtables-addons 1.32/ipset-GENL 5.2
Date: Wed, 05 Jan 2011 15:52:07 +0000
Message-ID: <4D2493A7.5070203@googlemail.com>
References: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr> <alpine.DEB.2.00.1101050921130.23762@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101050921130.23762@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> I fully appreciate your effort, however with it you forked ipset 5.x and 
> now the two branches cannot talk to each other.
>
> I'm not convinced that ipset should be moved from nfnetlink to genetlink. 
> It'd make life easier for the users at the beginning, however on the 
> longer run it'd buy nothing and I believe ipset belongs to nfnetlink.
>
> I considered the idea of adding support of both protocols, however it 
> might make the acceptance for kernel inclusion harder. I'm not happy.
>   
Jozsef,

I have been thinking along similar lines with regards to ipset/xtables 
for quite a while - I do not really need or use xtables apart from the 
ipset part.

Up until now I have been compiling rpm which builds the main xtables 
package and I also use a sepearate .spec file to create the kernel 
modules (kmod-*.rpm). The process is by no means flawless (my post 
history on here vouches that to be the case) so, waiting for ipset to be 
integrated with xtables every time a new ipset version is released is 
not always the best for me as a regular user of that package as your 
comments above highlight.

What I am getting at is this - I will try to create a .spec file for 
building a completely separate package which only deals with ipset and 
leaves xtables aside as it is highly likely that I will dump xtables 
once and for all as soon as I am able to create this package since I do 
not need/use its features, apart from what ipset currently offers me.

As it stands, Fedora does not distribute ipset on its own, but as part 
of the xtables package. I do not know whether this is going to change, 
but as far as I am concerned the moment I am able to build a separate 
ipset rpm which functions as it should, xtables is gone on all of my 
machines. I presume ipset, too, generates/uses kernel modules - is that 
the case?
 
