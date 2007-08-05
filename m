From: Michael Guntsche <mike@it-loops.com>
Subject: Re: RTSP support for 2.6.23
Date: Sun, 5 Aug 2007 10:50:32 +0200
Message-ID: <0D1A942C-1A3C-43E4-B8E4-EB5895D5B2A9@it-loops.com>
References: <A96BBBA4-8FD8-4DE4-8389-439E0DFB1546@it-loops.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <A96BBBA4-8FD8-4DE4-8389-439E0DFB1546@it-loops.com>
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


On Aug 5, 2007, at 10:38, Michael Guntsche wrote:

> struct nf_conntrack_expect
> exp->mask.dst.u.udp.port
>
> nf_conntrack_helper
> hlpr->mask.src.u.tcp.port
> hlpr->mask.dst.protonum
>
> The new structs have no mask members and I am not sure how I can  
> achieve the same results with the new code.

Of course this should read nf_conntrack_expect has not "dst" member  
and nf_conntrack_helper has no "mask" member.

/Michael
