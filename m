From: "Stephan Jager" <Stephan@medz.org>
Subject: Re: H.323 conntrack patch
Date: Tue, 15 Jul 2003 20:37:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307151837.h6FIbUwT006094@alpha.medz.org>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: mzieba-netfilter@mail.biuro.medianet.pl
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 15 Jul 2003, mzieba-netfilter@mail.biuro.medianet.pl wrote:

> On Tue, Jul 15, 2003 at 03:00:10PM +0200, Stephan Jager wrote:

> Jul 14 10:45:20 nat kernel: ct_h245_help: new RTCP/RTP requested
> 192.168.2.101:->193.192.xxx.xxx:19422
> Jul 14 10:45:20 nat kernel: ct_h245_help: new RTCP/RTP requested
> 192.168.2.101:->193.192.xxx.xxx:19423
> 
> but only one h323_data_fixup for that packet. I just can't find example
> code of multiple expectation per packet to look, how it should be done. ;)

So our question: Can you have more expectations for one packet? It does 
not seem to word at least.

Stephan
