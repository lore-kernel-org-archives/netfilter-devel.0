From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: RE: Hash Function to Seperate Flows
Date: Thu, 4 May 2006 13:02:10 +0800
Message-ID: <041f01c66f37$ec232b10$aa0ba8c0@l7.com.tw>
References: <44587944.30707@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <44587944.30707@ufomechanic.net>
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

I suggest to refer the net/ipv4/netfilter/ip_conntrack_core.c

Thehe is a example using jhash for reference.

static u_int32_t __hash_conntrack(const struct ip_conntrack_tuple
*tuple,
                            unsigned int size, unsigned int rnd)
{
        return (jhash_3words(tuple->src.ip,
                             (tuple->dst.ip ^ tuple->dst.protonum),
                             (tuple->src.u.all | (tuple->dst.u.all <<
16)),
                             rnd) % size);
}

Vincent

>-----Original Message-----
>From: netfilter-devel-bounces@lists.netfilter.org 
>[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf 
>Of Amin Azez
>Sent: Wednesday, May 03, 2006 5:35 PM
>To: netfilter-devel@lists.netfilter.org
>Subject: Re: Hash Function to Seperate Flows
>
>
>Srinivas Krishnan wrote:
>> hi,
>> 
>> i am trying to separate different flows, and was wondering 
>if there is 
>> a standard hash function with low collisions i can use to hash based 
>> on src ip, dest ip, src port, dest port and protocol.
>> 
>> there seems to be as hash fn in freeBSD's dummynet code but I do not 
>> know if it can be directly applied, as it does some bit 
>fiddling with 
>> flow_mask.
>> 
>> any help/thoughts would be greatly appreciated
>
>I suggest you read a few times through all kernel source files 
>with "conntrack" in the name.
>
>I did, and it did me a world of good.
>
>jhash is probably the hash function you want. Look out for it, 
>and happy reading.
>
>Sam
>
