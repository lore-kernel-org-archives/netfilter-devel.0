From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re[2]: [PATCH] new 'tcpack' match
Date: Sun, 3 Apr 2005 23:30:59 +0200
Message-ID: <878113493.20050403233059@dns.toxicfilms.tv>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <425032D5.2010302@trash.net>
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

> I can see that it would be useful, given all the half-working ACK
> matching rules for shaping floating around, but we already a tcp
> match, so it should be done in there, and, if possible, kept a little
> bit more generic. Perhaps a data-len match option.
Hmm. I'm no guru, but isn't it possible to do that using the u32 filter
with tc? Which propably is faster than doing it in iptables anyway.

--
Maciej
