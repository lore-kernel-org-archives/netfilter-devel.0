From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables compilation (or user :) error
Date: Wed, 10 Sep 2003 22:00:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309102158250.31287-100000@filer.marasystems.com>
References: <Pine.LNX.4.51.0309101554140.6867@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Gergely Imre <gimre@nextra.ro>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0309101554140.6867@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Sep 2003, Maciej Soltysiak wrote:

> There is a bug in the build system, apply this patch over the
> netfilter tree.

> Harald, or anyone, can you apply this, it breaks all builds that did
> not choose CLASSIFY target to be patched from pom.

Or better yet the slightly larger (same lines, one word more deleted)  
patch I submitted a few days ago which also fixes a similar problem with
NETMAP.

Regards
Henrik
