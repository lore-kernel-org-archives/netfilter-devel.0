From: Stefan Schlott <stefan.schlott@informatik.uni-ulm.de>
Subject: Re: netfilter and ipsec
Date: Thu, 9 Jan 2003 15:21:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109142151.GA17856@orca.informatik.uni-ulm.de>
References: <011101c2b7e6$69afb880$8365608c@kmlin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ?e?? <kmlin@itri.org.tw>
Content-Disposition: inline
In-Reply-To: <011101c2b7e6$69afb880$8365608c@kmlin>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Re-Hi,

>   I am a new entrant in linux network security, and have tried to
> understand Netfilter and FreesWan.
>   There is a question now confusing me so long. Why not integrating
> IPSec in the Netfilter architecture?
>   Is there any reason that IPSec must exist as an device driver or
> some drawbacks to integrate??

I personally never touched the FreeSWAN-code, but I did the kernel part of
an IPsec-implementation for the IPv6 module about 2 years ago. So, this
statement is from an IPv6-point-of-view :-)
The main problem is the increasing size of a packet: It is possible to
modify packets in netfilter - as long as you don't increase the size.
Fragmentation is done somewhere else (in an earlier stage), so you have
to make sure that your IPsec-enriched packets do not exceed the (P)MTU.
If they do, this is your problem. If you don't care, the kernel will drop
the outgoing packet.
Of course, you could implement that, but this would void the performance
optimization done in the TCP code.
Inbound packets are not better: When netfilter gets hold of them, they are
still fragmented - afaik IPsec processing is done on the reassembled packets
(this makes sense: If a fragment is lost, some expensive cryptographic
operations would have been done in vain).
That's why I ended up patching the ipv6 module.

Well, as already mentioned - that was two years ago. If something has
changed, I'd be curious to know.

Stefan.

-- 
*--- please cut here... -------------------------------------- thanks! ---*
|-> E-Mail: stefan.schlott@informatik.uni-ulm.de    PGP-Key: 0x2F36F4FE <-|
| The only secure Microsoft software is what's still shrink-wrapped in    |
| their warehouse...                                                      |
|   -- Richard Forno                                                      |
*-------------------------------------------------------------------------*
