From: Eric Leblond <eric@inl.fr>
Subject: Re: bandwidth saving idea
Date: Mon, 11 Jul 2005 16:49:43 +0200
Message-ID: <1121093383.26639.29.camel@localhost.localdomain>
References: <20050701004115.34697.qmail@web26507.mail.ukl.yahoo.com>
	<42C853F4.6010702@outerspace.dyndns.org>
	<1121087802.4967.35.camel@OSCARLAPLIN>
	<1121088394.26639.8.camel@localhost.localdomain>
	<1121092737.4967.62.camel@OSCARLAPLIN>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: oscar@ufomechanic.net
In-Reply-To: <1121092737.4967.62.camel@OSCARLAPLIN>
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

> I do not understand "checksum functions are not injective" my intention
> was to hold a name=value list where name is checksum and value is
> payload (or reference to payload on disc/FC/RD). 

A function f is injective if for all a and b f(a)=f(b) implies a=b.

Let f be your checksum function and a and b two packet payload then
f(a)=f(b) does not implied a=b. Thus, given a checksum c you can not
assert that there is only one a such as f(a)=c.

In fact, your start set is the set of number of size 1500bits (packet
length) and your result set is the set of number of size inferior or
egal to checksum length (32). As number of elements of start set is
larger than the number of elements of result set. Thus, there is no
injective function from set of packet to set of checksum.

BR,
-- 
Eric Leblond <eric@inl.fr>
