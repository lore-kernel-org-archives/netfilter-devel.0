From: "peter smith" <smith-peter@comcast.net>
Subject: RE: real time stateful filtering question
Date: Wed, 17 Mar 2004 09:53:34 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <NEBBJFIAIKIHKGJDONCDMENJCCAA.smith-peter@comcast.net>
References: <20040317135825.GA21899@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@gnumonks.org>
In-Reply-To: <20040317135825.GA21899@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks to all for responding.

My application is *not* participating in the network level session(s). It is
not an end-station. I am building a monitor application - like an IDS -
which simply sniffs the wire by installing a filter at a well known port,
and waits for sessions on that port, and then installs filters for data
sessions that are related to the initial control session. I simply used FTP
as an example of a protocol that behaves this way...

I wanted to use netfilter as-is, and do application level parsing of FTP
commands, etc, in my userland code.

I believe that while the backlog queue is processed in the kernel, in-order,
the fact that the packet containing the FTP "PORT" command isn't processed
by my userland application level decode until a context switch occurs makes
it impossible to guarantee that the userland application level decode will
get to process the PORT command packet will be seen before data channel
packets are discarded ... this seems to be common sense unless there is some
workaround that I am missing (or fundamental tenet I am missing)...

Thanks!
Peter



-----Original Message-----
From: Harald Welte [mailto:laforge@gnumonks.org]
Sent: Wednesday, March 17, 2004 8:58 AM
To: peter smith
Cc: Netfilter Development Mailinglist
Subject: Re: real time stateful filtering question


On Mon, Mar 15, 2004 at 10:54:00AM -0500, peter smith wrote:
> If I wish to monitor using netfilter a link that has applications talking
on
> it that use ephemeral ports (like, for instance, FTP or H323), is there a
> way to install filters fast enough /syncronously enough to guarantee that
> you won't miss packets that you have already received? For instance, say
> that you have some number of packets in your rx ring buffer waiting to be
> processed. The first one is processed, and matches some filter you have
set.
> That packet is queued for delivery to userland.
>
> That packet also has a FTP PORT command inside it's payload that specifies
> the new data channel that the two hosts will use to transfer data. (where
> channel == the src/dst ip and src/dst ports)
>
> Unfortunately, packets sent on the data channel are also in your receive
> buffer, and get processed by netfilter *before* the "PORT COMMAND" packet
> gets processed by the userland monitor, or before the monitor can
> sucessfully re-program the netfilter filter list. So they are dropped,
> silently.

the backlog queue ('receive buffer') is always processed in-order.  so
it is a violation of protocol if an ftp data packet would arrive before
the control connection would show PORT/PASV.

Imagine this being the FTP client/server.  It would return a  TCP RST to
the data packet, since it wouldn't have bound a socket to the respective
address yet (or whatever).

[yes, ftp sucks as an example because this could never happen, but
settinh this aside]

> Thanks,
> Peter

--
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
============================================================================
Programming is like sex: One mistake and you have to support it your
lifetime
