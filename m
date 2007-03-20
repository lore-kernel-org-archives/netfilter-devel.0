From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: fix NF_CT_NETLINK dependency
Date: Tue, 20 Mar 2007 07:35:38 +0100
Message-ID: <45FF80BA.2000007@trash.net>
References: <200703200634.l2K6Y9h0027328@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703200634.l2K6Y9h0027328@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi, This is for 2.6.21 tree.
> 
> nf_conntrack_netlink has the NAT related staffs if NAT is enabled.
> Then NF_CT_NETLINK=y requires NF_NAT=y or NF_NAT=n.


Thanks, I already have an identical patch queued. Will push it
soon.
