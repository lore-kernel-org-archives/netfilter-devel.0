From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re[2]: [PATCH] new 'tcpack' match
Date: Mon, 4 Apr 2005 15:30:25 +0200
Message-ID: <5810131003.20050404153025@dns.toxicfilms.tv>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
	<878113493.20050403233059@dns.toxicfilms.tv>
	<4250848E.5040207@outerspace.dyndns.org>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <4250848E.5040207@outerspace.dyndns.org>
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

> | Hmm. I'm no guru, but isn't it possible to do that using the u32 filter
> | with tc? Which propably is faster than doing it in iptables anyway.

> Yeah it's possible, but no one seems to be doing it right..
Ah, okay, I get it.

> I aim to fix this all with one simple netfilter match which can give an
> answer with simple arithmetics in one go instead of matching against a
> preconfigured list of possible values one by one.
Right.

I agree the best way to go would be to extend the tcp match with
the proposed semantics:
    --datalen [!] A[,B:C[,D]]


It also might be useful to match the sole header length.
   --headerlen [!] A[,B:C[,D]]

And the lenght of tcp+data

   --len

Possibly the similar for udp:
   --datalen, --headerlen, --len

And ICMP:
   --datalen, --len (icmp headers have fixed size)

-- 
Regards,
Maciej Soltysiak
