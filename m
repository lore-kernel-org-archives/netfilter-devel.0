From: Matt Skidmore <fox@woozle.org>
Subject: Re: Feasability of Protocol Filtering
Date: Wed, 23 Apr 2003 15:03:31 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44+maildir.0304231452150.9967-100000@woozle.org>
References: <3EA7056F.2050601@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3EA7056F.2050601@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> i'm doing a quite similar thing at the moment: i'm developing a match that recognizes p2p
> traffic (kazaa, edonkey finished but more to come) by their protocol and mark them. After
> that i use a tc filter to read the marks and put the packets in QoS classes.
> What you need is something characteristic for every protocol. For example: every
> kazaa-download starts with a packet containing the string "GET /.hash=" - i do a
> string-match on each packet and if i find a match i just mark the whole connection with
> CONNMARK.

thats about what im thinking. im going to use HTTP and SSH as examples
because i know those protocols the best. and to keep it simple ill just
say we wish to REJECT the packet. for HTTP the syn and acks might go
through to establish the handshake, but you can examine the begining few
packet contents to figure out that its trying to GET some url and then
drop that packet and kindly reset the connection to be polite in this
case. same with SSH, when the connection begins it usually says SSH with
the version and some other tidbits that can be easily recognized. i would
say build the basic protocol identification source file and then create
the ability to choose which protocols you want to be able to recognize as
to keep down bloat on a module.

I was heading to p2p programs myself. but this sort of feature would be
nice to identify p2p stuff and perhaps reject or use QoS on them. once the
connection has been established the data in the packets may not match the
pattern for that protocol, but you could use connection tracking with
dest/src ip and port to mark said packets.

the downside to this is, say you want to reject SSH traffic. you issue the
command to reject it based on protocol. if there is a connection already
in progress it probably wouldnt get it unless there are some telltale
signs in the data packets, but since you can at least identify the initial
connection packets you could at least stop additional connections.

I would be interested in seeing what you have so far. as for CPU and RAM
concerns, I thought about this a bit myself. it could also intoduce
latency as well.

-matt
