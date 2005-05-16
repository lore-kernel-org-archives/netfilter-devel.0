From: Silimite <silimite@gmail.com>
Subject: Re: Handling large amounts of data
Date: Mon, 16 May 2005 10:39:07 -0400
Message-ID: <5ad977d10505160739e482c66@mail.gmail.com>
References: <5ad977d10505151446348e932f@mail.gmail.com>
	<876ef97a05051515154bdb4157@mail.gmail.com>
Reply-To: Silimite <silimite@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a05051515154bdb4157@mail.gmail.com>
Content-Disposition: inline
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

Thanks!  I'll look into that more.  I had looked at the netlink
sockets in the past but they seemed to require a more complex
interface (ie. I can't just cat/echo commands like in procfs).  I do
like the idea of being able to use netlink and have persistent
connections open (for status updates like in a GUI interface).

I suppose there are not a lot of modules that need this type of
interface.   I noticed that there was at least one other module using
procfs.

s

On 5/15/05, Tobias DiPasquale <codeslinger@gmail.com> wrote:
>  A unicast netlink socket would almost certainly be the best way to go
> here. For examples on how to use unicast netlink sockets, look at
> net/ipv4/netfilter/ip_queue.c or net/core/rtnetlink.c.
>=20
> --
> [ Tobias DiPasquale ]
> 0x636f6465736c696e67657240676d61696c2e636f6d
