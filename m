From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Thu, 12 Jan 2006 13:33:07 +0100
Message-ID: <43C64C83.2060808@trash.net>
References: <BAY103-F101B38B8CF2C670CC1A915B2270@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F101B38B8CF2C670CC1A915B2270@phx.gbl>
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

Marco Berizzi wrote:
> 
> Patrick McHardy wrote:
> 
>> These are the addresses you need to use for --tunnel-src/dst, not the
>> outer addresses. Those can be match with -s and -d are usual.
> 
> 
> Aha! ;-)) It's working. Thanks a lot. Perhaps _IMHO_ this should be
> clarified in iptables man page. After all --tunnel-src/dst are the two
> IPsec endpoint addresses. Right?

Yes. I don't see how it could be made any clearer, but feel free to
send a suggestion :)

        --tunnel-src addr[/mask]
               Matches the source address of a tunnel. Only valid with 
--mode tunnel.

        --tunnel-dst addr[/mask]
               Matches the destination address of a tunnel. Only valid 
with --mode tunnel.
