From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT and locally bound sockets
Date: Mon, 1 Jul 2002 18:59:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207011859.39589.hno@marasystems.com>
References: <20020529164926.GA9003@gort.ecn.purdue.edu> <20020530153247.I7658@sunbeam.de.gnumonks.org> <20020701163232.GB7090@lucky>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: shuey@purdue.edu, Michael Shuey <shuey@fmepnet.org>,
	Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.samba.org
In-Reply-To: <20020701163232.GB7090@lucky>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Michael Shuey wrote:

> In this scenario, think about the tuple for a moment.  Since all clients
> and the natbox are mounting the same NFS server, selecting the same port by
> default, using UDP across the board, the connection tuples are (after SNAT)
> going to be very similar - they only differ in srcport.  Normally that
> would be just fine; however, with a high level of traffic the NAT system
> would occaisionally select a srcport that was already in use by the NFS
> client local to natbox.  That's not fine - it causes quite a few NFS
> timeouts, retransmits, etc. on natbox.

This is handled fine in all tests I have done provided your SNAT rule applies 
to both forwarded and locally originating packets.

If however your UDP nat entries times out from conntrack, which they can 
easily do for a idle NFS mount, then all bets is off.. The default udp 
timeout is only 180 seconds which is not by far sufficient for multi-client 
NAT of NFS. A typical case where conntrack by default cannot easily know a 
suitable timeout without additional information.

Regards
Henrik
