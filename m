From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables shared library compiling error
Date: Wed, 31 Mar 2004 12:55:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403311254310.20554-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0403310026460.19914-100000@lhotse.up.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Fastabend <jfastabe@up.edu>
In-Reply-To: <Pine.LNX.4.44.0403310026460.19914-100000@lhotse.up.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, John Fastabend wrote:

> pseudo@nitbit kernrouter $ gcc -fPIC libipt_CHANGEIP.c
> In file included from libipt_CHANGEIP.c:10:
> /usr/include/iptables.h:4:29: iptables_common.h: No such file or directory
> /usr/include/iptables.h:5:29: libiptc/libiptc.h: No such file or directory

You need to specify the include path to the iptables userspace include 
files on your gcc line, like how iptables builds the other extensiosn.

Why don't you build your extension within the established framework: place 
the file in extensions/ and a corresponding .CHANGEIP-test file?

Regards
Henrik
