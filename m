From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: Syncookie firewall
Date: Thu, 6 Jun 2002 15:36:55 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15615.58375.448754.673206@isis.cs3-inc.com>
References: <20020606192927.6B7684DCE@lists.samba.org>
	<15615.53673.287531.24270@isis.cs3-inc.com>
	<200206062334.17294.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206062334.17294.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom writes:

 > > Fortunately, all of these options are ... optional, so the firewall
 > > can, if it doesn't know better, simply not use them.
 > 
 > To ensure interoperability you must also filter out any options on future 
 > packets of that TCP not known to be 100% compatible with your SYN+ACK.

There is no need to do anything but send syn and syn/ack without any
options that might be incorrect for the other participant.
Then it's incorrect for the other side to send them in later packets
so there's nothing for you to filter.  If the participants want to
violate the spec it's not the responsibility of the firewall to
prevent them.

 > > The timestamp option is not a problem in this case.  The firewall only
 > > responds to a few packets and for those it can supply its own
 > > timestamp (or not).  After it establishes both halves of the
 > > connection it just forwards the packets and the timestamps (seems to
 > > me) should work out fine.
 > 
 > The timestamp option must be real all the time, or never. You
 > cannot suddently switch TCP timestamp source in the middle of a TCP
 > connection. Doing so will serverely break PAWS.

Now that I reread rfw1323 I see that timestamps also are not allowed
unless they appear in the first segment.  So again the general
solution is not to send it.
(Once again I think the "solution" is to change the spec.)

In any case it's sufficient for the firewall to simply not send any 
timestamp options at all.
