From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: Syncookie firewall
Date: Thu, 6 Jun 2002 14:18:33 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15615.53673.287531.24270@isis.cs3-inc.com>
References: <20020606192927.6B7684DCE@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020606192927.6B7684DCE@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > Don Cohen wrote:
 > 
 > > Why do you think that's better than simply forwarding packets with
 > > sequence/ack# translation?  Surely it's less efficient.  And it raises
 > > questions about how much data to buffer between the two and how that
 > > can be controlled.
 > 
 > Because there is no good way to know the servers TCP options before
 > you have opened the TCP connection to the server, and you do not
 > want to open the TCP connection to the server before the client has
 > acknowledged the connection... 
Fortunately, all of these options are ... optional, so the firewall 
can, if it doesn't know better, simply not use them.

 > Adjusting the sequence numbers is the simple part of the picture. Does not 
 > worry me.. this is what the NAT engine is doing.
 > 
 > What worries me is
 > 
 >   * Window scaling
It would be unfortunate to lose this in some cases, but those are the
cases where the firewall is likely to know what sort of window scaling
is supported by the server.

 >   * Timestamp
 >   * ECN
 > 
 > and a number of other end-to-end TCP options that depend on correct 
 > negotiation during SYN.
 > 
 > Sure, window scaling and ECN can be set by configuration if you know your 
 > server, but there is no good way to deal with the timestamp option short of 
 > forcibly filter it out entirely from the TCP stream.

The timestamp option is not a problem in this case.  The firewall only
responds to a few packets and for those it can supply its own
timestamp (or not).  After it establishes both halves of the
connection it just forwards the packets and the timestamps (seems to
me) should work out fine.
