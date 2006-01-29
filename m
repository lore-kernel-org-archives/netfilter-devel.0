From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Sun, 29 Jan 2006 23:14:21 +0100
Message-ID: <43DD3E3D.5070201@trash.net>
References: <1138563710.26998.22.camel@leto.intern.saout.de>	
	<43DD1E3E.70503@trash.net>
	<1138568354.21229.1.camel@leto.intern.saout.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christophe Saout <christophe@saout.de>
In-Reply-To: <1138568354.21229.1.camel@leto.intern.saout.de>
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

Christophe Saout wrote:
> Patrick McHardy wrote:
>
>>It should work just fine. Please add logging rules for both encrypted
>>and decrypted packets to all chains in the mangle table and enable
>>logging of invalid packets in connection tracking
>>(echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid)
>>and post the results.
> 
> 
> I did, but it doesn't seem conclusive.
> 
> Trying to open a tcp connection: (note that there are no entries with
> IN=eth0 ???)
> 
> Jan 29 21:51:23 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=100 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=41 
> Jan 29 21:51:23 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=100 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=41 

41 is IPPROTO_IPV6, you seem to be talking to the remote side using IPv6
over sit, which is why NAT on the TCP packet doesn't work.
