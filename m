From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetBIOS datagram nat helper proposal
Date: Wed, 21 Sep 2005 00:51:35 +0200
Message-ID: <43309277.2040900@trash.net>
References: <1127164215.25000.44.camel@localhost>	 <432F58A7.4030907@trash.net>
	<1127181124.29021.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
In-Reply-To: <1127181124.29021.34.camel@localhost>
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

John A. Sullivan III wrote:
> On Tue, 2005-09-20 at 02:32 +0200, Patrick McHardy wrote:
> 
>>>We are seeing if we have the resources to finish and polish this patch
>>>and submit it.  It seems that we then simply post it to this list to
>>>submit it.  Is that the correct procedure?
>>
>>Yes, if the patch is OK conceptually. If you send me some pointers,
>>I'll have a look.
>>
> 
> I believe it is defined by RFC1002.  You can find it here:
> http://ubiqx.org/cifs/rfc-draft/rfc1002.html#s4.4
> I would think it is pretty straightforward but it is so easy to
> dreadfully underestimate these things.  Thanks - John

Thanks. Looking at the RFC, the patch is incomplete in at least two
ways. First, the protocol includes broadcasts, these need to be tracked
in a similar way to ip_conntrack_netbios_ns. Second, the helper only
NATs the source IP but the packets also include the source port, it
needs to be translated as well. I'm not sure how the reply packets
look, I found some broadcast queries in my local network, but don't
have access to any of the machines to sniff the unicast replies.

# tcpdump -i eth0 -ntv port 138
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 96
bytes
IP (tos 0x0, ttl 128, id 64557, offset 0, flags [none], proto: UDP (17),
length: 229) 172.16.0.77.138 > 172.16.255.255.138: NBT UDP PACKET(138)
IP (tos 0x0, ttl 128, id 52744, offset 0, flags [none], proto: UDP (17),
length: 239) 172.16.1.56.138 > 172.16.255.255.138: NBT UDP PACKET(138)
IP (tos 0x0, ttl 128, id 37133, offset 0, flags [none], proto: UDP (17),
length: 229) 172.16.1.11.138 > 172.16.255.255.138: NBT UDP PACKET(138)
IP (tos 0x0, ttl 128, id 53239, offset 0, flags [none], proto: UDP (17),
length: 229) 172.16.1.56.138 > 172.16.255.255.138: NBT UDP PACKET(138)

If you can provide me with some packet dumps of a machine sending and
receiving these packets I'll give it a try, it shouldn't be much work.
