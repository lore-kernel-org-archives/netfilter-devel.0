From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH 2.6] Use C99 initializers for conntrack sysctl tables
Date: Sun, 22 Feb 2004 17:07:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402221703210.17860-100000@filer.marasystems.com>
References: <4036D735.E834F74A@actiontec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bo Xiong <bxiong@actiontec.com>
In-Reply-To: <4036D735.E834F74A@actiontec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004, Bo Xiong wrote:

> init_conntrack()  will creat a new conntrack, bu where add the new
> conntrack to hash_list?

When it is confirmed by ip_conntrack_confirm(), called when the packet is
confirmed to be accepted (NF_IP_POST_ROTING / NF_IP_LOCAL_IN)

Regards
Henrik
