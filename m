From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: /proc/net/ip_conntrack
Date: Wed, 30 Jun 2004 12:38:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301236030.3767-100000@filer.marasystems.com>
References: <20040629203549.M8283@linkexpress.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Daniel_Corr=EAa_de_A?=zevedo <nielca@linkexpress.com.br>
In-Reply-To: <20040629203549.M8283@linkexpress.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 29 Jun 2004, Daniel Corr=EAa de Azevedo wrote:

> I wonder if any one could help me with figuring out a way to write to t=
he=20
> proc file "/proc/net/ip_conntrack".

You can't. It is not a file, it is a window into the connection tracking=20
function of the kernel showing you what is going on "right now". This=20
window is bulletproof and you cant take things out or put things in via=20
this window, only look at how they look.

> What I need is to replicate this file=20
> from one computer to another.

See discussions on conntrack replication/syncronisation. There is an=20
ongoing (not yet finished) project implementing this kind of function.=20
There is a whole lot more involved than just "copying".

Regards
Henrik
