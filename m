From: "peter smith" <smith-peter@comcast.net>
Subject: RE: real time stateful filtering question
Date: Wed, 17 Mar 2004 11:38:21 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <NEBBJFIAIKIHKGJDONCDAENMCCAA.smith-peter@comcast.net>
References: <Pine.LNX.4.44.0403171650450.11069-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Harald Welte" <laforge@gnumonks.org>,
	"Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Henrik Nordstrom" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403171650450.11069-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am a passive tap, not a bump in the wire. So, as you said, apparently
netfilter is not the tool for the job, as for my software, I need to
guarantee that each packet is processed to completion (i.e. by my userland
software) before *any* processing is performed on subsequent packets in the
flow, or subsequent packets in related flows.

Thanks,
Peter


On Wed, 17 Mar 2004, peter smith wrote:

> My application is *not* participating in the network level session(s). It
is
> not an end-station. I am building a monitor application - like an IDS -
> which simply sniffs the wire by installing a filter at a well known port,
> and waits for sessions on that port, and then installs filters for data
> sessions that are related to the initial control session. I simply used
FTP
> as an example of a protocol that behaves this way...

This important distinction to make is if this sniffing device inline with
the traffic (forwarding), or just passively listening?

If passively listening then netfilter is not the tool for the job, and you
must make sure packet processing can keep up with the rate needed as you
can not delay traffic.

If inline, then all of what has been discussed applies, including the
exaplanation why your expected window is permanently shut close in most
protocols (certainly for FTP).

> I wanted to use netfilter as-is, and do application level parsing of FTP
> commands, etc, in my userland code.

Which is entirely fine if you are inline. See earlier discussion.

> I believe that while the backlog queue is processed in the kernel,
in-order,
> the fact that the packet containing the FTP "PORT" command isn't processed
> by my userland application level decode until a context switch occurs
makes
> it impossible to guarantee that the userland application level decode will
> get to process the PORT command packet will be seen before data channel
> packets are discarded

Not at all. The FTP protocol does not progress to use the data channel
until the response to the PORT command is seen. If you are executing
inline using netfilter QUEUE then this will not happen until your
userspace program has processed the PORT command and allowed it to be
forwarded. End of story.

If you are not executing inline in the traffic stream then it is another
business, but then netfilter is also not the proper tool for the job.

Regards
Henrik
