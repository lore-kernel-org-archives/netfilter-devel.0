From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: SIP helper: expect RTP streams in both directions
Date: Tue, 01 Aug 2006 08:53:31 +0200
Message-ID: <44CEFA6B.5020406@trash.net>
References: <44CEF736.4020105@trash.net>
	<20060731.234747.88341516.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20060731.234747.88341516.davem@davemloft.net>
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

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 01 Aug 2006 08:39:50 +0200
> 
> 
>>following are two small fixes for 2.6.18. The second patch fixes
>>missing string validation in two netfilter modules. James sent a
>>similar patch for SECMARK to -stable, in my opinion this is not
>>necessary since CAP_NET_ADMIN in practice always means root and
>>mainline doesn't support virtualization yet. But if you feel
>>otherwise please pass it on. Thanks.
> 
> 
> I applied James's patch because we should not make life
> overly difficult for the openvz folks.

I only meant -stable with "unnecessary", it should be fixed of course.

> I've applied both of your patches too, thanks a lot Patrick.

Thanks.
