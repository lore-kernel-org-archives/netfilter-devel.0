From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tools to modifiy the conntrack?
Date: Tue, 21 Oct 2003 21:56:08 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310212155000.7523-100000@filer.marasystems.com>
References: <006001c39733$32949370$6500a8c0@SYFLO>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sylvain BERTRAND <jowy@2001-space-odyssey.net>
In-Reply-To: <006001c39733$32949370$6500a8c0@SYFLO>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Oct 2003, Sylvain BERTRAND wrote:

> I've got conntrack support in my 2.4.21 kernel. I'd like to flush it
> sometime, or at least delete a few lines.

This is a area somewhat lacking at this time.

There is ongoing development adding support for this, available both in 
p-o-m and separately. Look for ctnetlink.

> I'm not very excited about editing /proc/net/ip_conntrack by hand...

You can't. It is read-only.

Regards
Henrik
