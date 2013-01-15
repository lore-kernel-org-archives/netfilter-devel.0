From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: state match is obsolete 1.4.17
Date: Tue, 15 Jan 2013 13:49:04 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301151342440.19279@nerf07.vanv.qr>
References: <CAMD-=V+PhM3NLpWyxB0G4KUN6D+-XKL0PZCBAuyUXUw56gmuJw@mail.gmail.com> <alpine.LNX.2.01.1301150958390.16853@nerf07.vanv.qr> <50F5273F.5020205@inliniac.net> <alpine.DEB.2.00.1301151102490.11129@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Victor Julien <lists@inliniac.net>,
	Nick Edwards <nick.z.edwards@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301151102490.11129@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tuesday 2013-01-15 11:06, Jozsef Kadlecsik wrote:
>> > 
>> > state is a redundant subset of conntrack (the latter was introduced around
>> > Linux 2.5.32) and shall go away.
>> 
>> I think removing it is a bad idea. For years and years all docs, books,
>> tutorials and frontends (like my own) have worked with "state". The
>> change seems so trivial "s/-m state --state/-m conntrack --ctstate/g"
>> that it would appear keeping "state" around as an alias or compatibility
>> layer would require minimal effort. Why not keep it around?
>
>Actually, I have to agree. Why don't we keep "state" as an alias and 
>accept the old syntax in "conntrack"?

state is currently aliased and translated to conntrack in iptables
if the kernel has it. No scripts are broken.

If the aliasing is done in userspace, the kernel part can be removed -
someday maybe.
