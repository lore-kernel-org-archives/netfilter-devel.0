From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Tue, 18 Oct 2005 10:31:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510181029260.6259@filer.marasystems.com>
References: <E1ERgwX-0002vy-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <E1ERgwX-0002vy-00@gondolin.me.apana.org.au>
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

On Tue, 18 Oct 2005, Herbert Xu wrote:

> Henrik Nordstrom <hno@marasystems.com> wrote:
>>
>> An IP fragment with offset 1 can overwrite parts of the TCP header, and if
>
> IP fragment offset is measured in units of 8 bytes so this can't happen.

I know. I tried to correct myself in a later message. The port numbers can 
not be overwritten by fragments, but the TCP flags such as SYN can. The 
first 8 bytes only contains the ports and sequence number.

Regegards
Henrik
