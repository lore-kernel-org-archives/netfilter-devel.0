From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack help
Date: Tue, 17 Feb 2004 11:51:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171149210.29541-100000@filer.marasystems.com>
References: <E1AsuVh-0007mH-MI@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhaoyao <zhaoyao@harbournetworks.com>
In-Reply-To: <E1AsuVh-0007mH-MI@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, zhaoyao wrote:

> conntrack IP_CT_DIR_ORIGINAL and IP_CT_DIR_REPLY
> is the same conntrack?

Yes, but different address details.

> If it is same conntrack, why clean_from_lists LIST_DELETE twice, orignal and reply?

It is one conntrack that is being deleted, but there is two references in
the lookup hash to the same conntrack, one per direction. This as the 
address details of the packet differs depending on the direction.

Regards
Henrik
