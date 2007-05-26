From: Patrick McHardy <kaber@trash.net>
Subject: Re: bugs in ftp conntrack
Date: Sat, 26 May 2007 11:07:32 +0200
Message-ID: <4657F8D4.8070202@trash.net>
References: <380055457.11873@tsinghua.org.cn>
	<1180150132.304.21.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "YU, Haitao" <yuhaitao@tsinghua.org.cn>,
	netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1180150132.304.21.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:
> fre 2007-05-25 klockan 09:10 +0800 skrev YU, Haitao:
> 
> 
>>I think if it's possible that we don't record the new seqence of too new packets.
>>"Too new packets" means the sequence of the packet is greater than all
>>seq_aft_nl[] values.  We just wait until another "port", "227", etc. packet is
>>parsed correctly.
> 
> 
> The best (save for doing a full TCP stream reassembly or proxying) would
> be to drop such out-of-order packets, relying on the sender to
> retransmit them later..  Might result in quite inefficient
> communication, but will make the protocol parsing behave correctly.


That also sounds like a good idea. We shouldn't see any reordering
in FTP command streams since clients usually wait for an reply before
sending the next command (at least I believe so, or is it always?),
so I'm not too worried about inefficient communication.

That would also allow to find silly bugs in newline sequence number
tracking faster :)
