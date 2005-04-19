From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [PATCH] new 'tcpack' match
Date: Tue, 19 Apr 2005 15:13:10 +0200
Message-ID: <426503E6.7010902@gmx.net>
References: <42464598.9040707@outerspace.dyndns.org>	<425032D5.2010302@trash.net>	<878113493.20050403233059@dns.toxicfilms.tv>	<4250848E.5040207@outerspace.dyndns.org>	<5810131003.20050404153025@dns.toxicfilms.tv>
	<425A5EE3.8060208@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425A5EE3.8060208@outerspace.dyndns.org>
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

Jonas Berlin schrieb:
> Quoting Maciej Soltysiak on 2005-04-04 13:30 UTC:
> 
> ~ > I agree the best way to go would be to extend the tcp match with
> | the proposed semantics:
> |     --datalen [!] A[,B:C[,D]]
> 
> I think [!] A[:B] should suffice :)
> 
> | It also might be useful to match the sole header length.
> |    --headerlen [!] A[,B:C[,D]]
> 
> Maybe [!] A[:B] here also..
> 
> Patric McHardy, what do you think, should I implement --headerlen also?
> 
> | And the lenght of tcp+data
> |    --len
> 
> This should be done with the "length" match IMO. -m length
> --layer2-length maybe ? I could implement this too while at it..
> 
> | Possibly the similar for udp:
> |    --datalen, --headerlen, --len
> 
> The udp header length is fixed (8 bytes), and thus --headerlen is
> unneeded and --datalen N[:M] could maybe implemented as -m length
> --layer2-length N+8[:M+8] ? I do agree that it would be a bit
> unaesthetic :)
> 
> | And ICMP:
> |    --datalen, --len (icmp headers have fixed size)
> 
> Same situation as udp, except maybe if the timestamps of the Timestamp
> message would be considered a part of the header, in which case the
> header size would no longer be fixed.. Anyway I guess --layer2-length
> should suffice for icmp..

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

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
