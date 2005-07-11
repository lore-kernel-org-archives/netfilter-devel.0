From: Amin Azez <azez@ufomechanic.net>
Subject: Re: bandwidth saving idea
Date: Mon, 11 Jul 2005 16:02:30 +0100
Message-ID: <42D28A06.4040903@ufomechanic.net>
References: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>	<42C853F4.6010702@outerspace.dyndns.org>	<1121087802.4967.35.camel@OSCARLAPLIN>	<1121088394.26639.8.camel@localhost.localdomain>	<1121092737.4967.62.camel@OSCARLAPLIN>
	<1121093383.26639.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1121093383.26639.29.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Eric Leblond wrote:
>>I do not understand "checksum functions are not injective" my intention
>>was to hold a name=value list where name is checksum and value is
>>payload (or reference to payload on disc/FC/RD). 
> 
> 
> A function f is injective if for all a and b f(a)=f(b) implies a=b.
> 
> Let f be your checksum function and a and b two packet payload then
> f(a)=f(b) does not implied a=b. Thus, given a checksum c you can not
> assert that there is only one a such as f(a)=c.
> 
> In fact, your start set is the set of number of size 1500bits (packet
> length) and your result set is the set of number of size inferior or
> egal to checksum length (32). As number of elements of start set is
> larger than the number of elements of result set. Thus, there is no
> injective function from set of packet to set of checksum.

This is true; however if the system is bi-directional, both machines
will keep a copy of the entire packet payload that was md5'd so that
they can re-emit this payload when the receive the md5 code.

The "compressing" machine after finding an md5 hit, will need to do a
bit-comparison to see that it was the same payload that generated the
md5 in the remote machine as has just generated that md5 locally.

Thus, although md5 is non-injective, the actual system is proof against
this deficiency.

It remains to see how much packet storage is needed to effectively save
bandwidth, but in specific installations this may not be too great.

Amin
