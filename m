From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] new 'tcpack' match
Date: Sun, 17 Apr 2005 16:36:29 +0200
Message-ID: <4262746D.9060406@trash.net>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
	<425A698F.6080703@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425A698F.6080703@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Quoting Patrick McHardy on 2005-04-03 18:15 UTC:
> 
> |> ~  iptables -A INPUT -p tcp -m tcpack --tcpack -j CLASSIFY 1:10
> |
> | I can see that it would be useful, given all the half-working ACK
> | matching rules for shaping floating around, but we already a tcp
> | match, so it should be done in there, and, if possible, kept a little
> | bit more generic. Perhaps a data-len match option.
> 
> Should I make a new revision of the tcp match in order not to break
> binary compatibility?

Yes.

Regards
Patrick
