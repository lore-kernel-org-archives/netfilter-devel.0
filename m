From: Daniel Hartmeier <daniel@benzedrine.cx>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 29 Jun 2005 16:55:45 +0200
Message-ID: <20050629145545.GO26761@insomnia.benzedrine.cx>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
	<Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
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

On Wed, Jun 29, 2005 at 12:26:02PM +0200, Jozsef Kadlecsik wrote:

> > http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/tcp-window-tracking/linux-2.4.patch?rev=4073&view=markup
> >
> > It would be nice to have a second opinion regarding the tcp state transitions,
> > the SACK handling and the tcp_in_window() function, which is most critical.
> > We're probably talking about this gem, among others:
> >
> > http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/sys/net/pf.c?rev=1.493&content-type=text/plain
> 
> I'd be just happy to receive any opinion, critics on how the window
> tracking were implemented in netfilter.

The SACK handling looks curious to me. This is the TCP Selective
Acknowledgements options, as in RFC 2018, right?

OpenBSD pf doesn't read those at all, currently. Stateful filtering
shouldn't have to know about SACK, as SACK-enabled hosts must still
honour the general rules in Guido's paper, i.e. ignoring SACK holes
doesn't break any valid SACK-enabled connection. This is unlike the
window scaling options, which the filter has to understand.

But there's one desirable thing you can do if you know about SACK holes:
you can prevent a peer from overwriting a TCP segment which has already
been (selectively) acknowledged. That is, similar to how the IP-level
reassembly in pf prevents attacks (for instance on IDSs) by weeding out
overlapping IP fragments, a TCP-level normalization could ensure that a
peer isn't allowed to overwrite TCP segments that have already been
acknowledged by the recipient. For instance, an attacker's goal might be
to take advantage of differences in how different readers will deal with
overlaps (the IDS might keep the first version, which doesn't trigger an
alarm, while the end-point host might keep the second version).

We want to implement this kind of TCP normalization eventually in pf,
and SACK makes this quite an interesting problem (i.e. should the
stateful filter use up memory to cache all SACK holes, etc.?).

Is this implemented in the netfilter patch above? Or what else do you
read SACK options for?

I don't see it caching individual SACK boundaries, there seems to be a
single 'highwater mark', as the comment explains

+   The boundaries and the conditions are changed according to RFC793:
+   the packet must intersect the window (i.e. segments may be
+   after the right or before the left edge) and thus receivers may ACK
+   segments after the right edge of the window.
+
+   	td_maxend = max(sack + max(win,1)) seen in reply packets
+	td_maxwin = max(max(win, 1)) + (sack - ack) seen in sent packets
+	td_maxwin += seq + len - sender.td_maxend
+			if seq + len > sender.td_maxend
+	td_end    = max(seq + len) seen in sent packets
+   
+   I.   Upper bound for valid data:	seq <= sender.td_maxend
+   II.  Lower bound for valid data:	seq + len >= sender.td_end - receiver.td_maxwin
+   III.	Upper bound for valid ack:      sack <= receiver.td_end
+   IV.	Lower bound for valid ack:	ack >= receiver.td_end - MAXACKWINDOW
+   	
+   where sack is the highest right edge of sack block found in the packet.
                      ^^^^^^^^^^^^^^^^^^

If you're using only the highest right edge, I wonder why you have to
read that at all (and don't just use normal ACKs that are sent when
there are no holes or holes are filled). Could you explain what
advantages this has? We see no problems with SACK-enabled connections in
pf, and simply ignore selective ACK options.

Daniel
