From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Netfilter hook! Insert error (insmod)
Date: Tue, 30 Mar 2004 17:51:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403301746240.9211-100000@filer.marasystems.com>
References: <20040330034954.13321.qmail@web41302.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tuan nguyen hoang anh <nguyen_hoang_anh_tuan@yahoo.com>
In-Reply-To: <20040330034954.13321.qmail@web41302.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 29 Mar 2004, Tuan nguyen hoang anh wrote:

> Hi, i'm writting a netfilter hook module. I compiled
> it successfull but when i insert it into kernel then
> it occurs errors following:
> 
> "unresolved symbol nf_register_hook"
> "unresolved symbol nf_unregister_hook"

Looks like your running kernel is not built with support for netfilter.

Make sure you run the same kernel build as the kernel headers you used 
when building your module.

Also make sure the compile flags are correct for your kernel.

Recommended method for building modules is to have them integrated in 
the kernel buildprocess. See Netfilter patch-o-matic-ng for a simple 
method of incorporating separately developed modules into the kernel 
source tree.

Regards
Henrik
