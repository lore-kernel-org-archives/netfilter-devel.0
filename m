From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Hash Function to Seperate Flows
Date: Wed, 03 May 2006 10:35:00 +0100
Message-ID: <44587944.30707@ufomechanic.net>
References: <ba7fdfc10605021333i167f9ads7b540a801c349c00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <ba7fdfc10605021333i167f9ads7b540a801c349c00@mail.gmail.com>
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

Srinivas Krishnan wrote:
> hi,
> 
> i am trying to separate different flows, and was wondering if there is
> a standard hash function with low collisions i can use to hash based
> on src ip, dest ip, src port, dest port and protocol.
> 
> there seems to be as hash fn in freeBSD's dummynet code but I do not
> know if it can be directly applied, as it does some bit fiddling with
> flow_mask.
> 
> any help/thoughts would be greatly appreciated

I suggest you read a few times through all kernel source files with
"conntrack" in the name.

I did, and it did me a world of good.

jhash is probably the hash function you want. Look out for it, and happy
reading.

Sam
