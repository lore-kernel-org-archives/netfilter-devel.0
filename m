From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables compilation (or user :) error
Date: Wed, 10 Sep 2003 21:57:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309102156470.31287-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gergely Imre <gimre@nextra.ro>
In-Reply-To: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Sep 2003, Gergely Imre wrote:

> [root@imi userspace]# make
> Making dependencies: please wait...
> Something wrong... deleting dependencies.
> make: *** [/usr/src/linux/include/linux/netfilter_ipv4/ipt_CLASSIFY.h] 
> Error 1
> 
> i have kernel source 2.4.22. do i have to patch it, or why isn't this 
> working? thx.

See my post a few days ago for a patch.

Regards
Henrik
