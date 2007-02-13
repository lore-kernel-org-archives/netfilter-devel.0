From: Patrick McHardy <kaber@trash.net>
Subject: Re: SYN,URG combination considered INVALID by tcp conntrack
Date: Tue, 13 Feb 2007 12:22:31 +0100
Message-ID: <45D19F77.609@trash.net>
References: <20060905144620.a7937f80.posthuma@sangine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Martijn Posthuma <posthuma@sangine.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060905144620.a7937f80.posthuma@sangine.com>
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

Martijn Posthuma wrote:
> We have been experiencing problems with tcp connection establishment  when (for some reason) the URG flag and pointer were set in the SYN segment. The problem did not affect all machines that were contacted but a subset. All affected machines were using netfilter-conntrack and firewalling.
> Inspection of the conntrack code (on a 2.6 linux kernel source) reveiled that the above mentioned combination of flags is not considered valid. The code I am referring to is in  nf_conntrack_proto_tcp.c version 2.2, lines 768 to 795:
> 
> [..]
> 
> As you can see the SYN,URG combination is not considered valid. I can not find any justification for this in RFC793. I do realize that it is a rare combination of flags, but legal none the less. (In the RFC there is even a explicit mention of the fact that a SYN segment can contain data, so a URG flag is perfectly feasible in that case).
> 
> Does someone know of a good reason that this flag combination is excluded?

No reason, I've added SYN|URG and SYN|PUSH|URG to the valid flag
combinations, thanks.
