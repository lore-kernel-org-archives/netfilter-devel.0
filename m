From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [netfilter-core] Strange conntrack behaviour
Date: Mon, 17 Jan 2005 10:59:57 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501171057180.29249@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0501101514260.12738-100000@presidium.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Duncan B." <duncan@presidium.org>
In-Reply-To: <Pine.LNX.4.44.0501101514260.12738-100000@presidium.org>
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

On Mon, 10 Jan 2005, Duncan B. wrote:

> Hi there,

Hi, this mail should have been sent to the
netfilter-devel@lists.netfilter.org list.

> I am running linux kernel 2.6.10 on Debian sarge, and have noticed
> recently that lots of connections in the conntrack table (shown with
> 'netstat-nat') are in the ESTABLISHED state, when they have long been
> closed on the client machine ... surely this is not usual behaviour?
>
> Could you tell me why this would be, or if there has been anything changed
> in the netfilter code as of recent versions that could have perhaps caused
> this to happen as a bug?  ... I'm guessing it's something my end however.

This is a known bug which has been fixed. Either upgrade to 2.6.11-rc1 or
apply the patch at this location:
http://people.netfilter.org/gandalf/patches/conntrack-fix-rst.patch

/Martin
