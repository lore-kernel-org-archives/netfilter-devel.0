From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: problem when loading ip_tables
Date: Wed, 24 Mar 2004 17:51:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403241750440.31592-100000@filer.marasystems.com>
References: <40616A52.3080704@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <40616A52.3080704@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 24 Mar 2004, Emmanuel Guiton wrote:

> insmod: ip_tables: no module by that name found
> 
> while the module ip_tables.o exists. insmod finds without problem the 
> other modules like for example ipt_REDIRECT, ip_conntrack, iptable_nat...


Probably your modules.dep is not up to date.

Regards
Henrik
