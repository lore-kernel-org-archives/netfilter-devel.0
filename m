From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: condition and 2.6
Date: Mon, 1 Mar 2004 07:30:38 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403010727240.2969-100000@filer.marasystems.com>
References: <200402292314.03863.lists@egidy.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gerd@egidy.de
In-Reply-To: <200402292314.03863.lists@egidy.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 29 Feb 2004, Gerd v. Egidy wrote:

> I think of a lockfile (e.g. /var/run/libiptc.pid) which is created by the 
> library in iptc_init and removed in iptc_commit. This way all programs using 
> libiptc become safe at once.

If this is done it should be optional.

iptables is used in very many applications, and not in all cases is there 
obvious plases to place lock files.

Regards
Henrik
