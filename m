From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip_conntrack_get
Date: Tue, 9 Dec 2003 09:51:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312090916320.23521-100000@filer.marasystems.com>
References: <3FD5486A.6060007@deansoft.com.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo neira <pablo@eurodev.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jesse Peng <jesse@deansoft.com.tw>
In-Reply-To: <3FD5486A.6060007@deansoft.com.tw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 9 Dec 2003, Jesse Peng wrote:

> while a new ip_conntrack cache initiates, every member 
> infos[i](nf_ct_info structure) then be charged with the same address 
> value pointing to the ip_conntrack cache's begining address(it's the 
> address of its first member nf_conntrack structure naming ct_general also).

Right.. now I get why this construct is looking like it does. It is a 
tradeoff "wasting" some space per conntrack to limit the mount of fields 
needed in the skb.

By using this construct both the ctinfo and conntrack can be derived from
a single pointer in the skb.

For systems using conntrack a lot it would be more efficient to extend the
skb with one more field for ctinfo, but as it is good if the skb is the
same regardless if conntrack is enabled or not and this construct is a
good tradeoff.

It is however possible to reduce the size of this construct considerably 
to just one byte per ctinfo.

Thanks
Henrik
