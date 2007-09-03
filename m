From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH] libnetfilter_conntrack: Packet/byte counters are 64 bit
Date: Mon, 03 Sep 2007 10:20:00 +1000
Message-ID: <46DB5330.8050201@snapgear.com>
References: <46C1577A.1010308@snapgear.com> <46DA7A71.3050909@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DA7A71.3050909@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Philip Craig wrote:
>> The counters in struct nf_conntrack are 64 bit, so the getter/setter
>> have to access them as such.
> 
> Still my kernel has 32 bit counters although I know that there was a
> patch on the table to recover 64 bits counters. I'm still getting in
> sync with the development again, did that patch finally hit mainline?

The kernel still sends 32 bit from what I can see, but this is problem
independent of what the kernel sends. The library handles receiving both
32 and 64 bit counters from the kernel, and stores them in a 64 bit
field in a structure. The getter/setter then access that field, but that
doesn't work if they access only 32 bits of it, at least for big endian.

An alternative fix is to change the nf_conntrack field to 32 bit,
but I would only do that if you never intend for the kernel to send
64 bit counters.
