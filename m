From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 04 Apr 2005 16:15:43 +0200
Message-ID: <42514C0F.4000605@gmx.net>
References: <42464598.9040707@outerspace.dyndns.org>	<425032D5.2010302@trash.net>	<878113493.20050403233059@dns.toxicfilms.tv>	<4250848E.5040207@outerspace.dyndns.org>
	<5810131003.20050404153025@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <5810131003.20050404153025@dns.toxicfilms.tv>
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

Maciej Soltysiak schrieb:
>>I aim to fix this all with one simple netfilter match which can give an
>>answer with simple arithmetics in one go instead of matching against a
>>preconfigured list of possible values one by one.
> 
> Right.
> 
> I agree the best way to go would be to extend the tcp match with
> the proposed semantics:
>     --datalen [!] A[,B:C[,D]]
> 
> 
> It also might be useful to match the sole header length.
>    --headerlen [!] A[,B:C[,D]]
> 
> And the lenght of tcp+data
> 
>    --len
> 
> Possibly the similar for udp:
>    --datalen, --headerlen, --len
> 
> And ICMP:
>    --datalen, --len (icmp headers have fixed size)

Could we do this in a generic way? I'm currently rewriting the iptables
ACCOUNT target and it could benefit from that as well.

I'd need:
- length of whole IP packet
- length of layer 2 frame

Perhaps a generic prefix for all "length" options is appropriate?

--len-header-ip
--len-data-ip
--len-full-ip
--len-header-tcp
--len-data-tcp
--len-full-tcp
--len-header-ether
--len-data-ether
--len-full-ether
etc.

I realize that some of the options above don't make that much sense,
but you get the idea.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
