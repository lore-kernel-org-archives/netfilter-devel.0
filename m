From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: nat/redirect question
Date: Thu, 26 Sep 2002 15:20:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020926132008.GA18136@balabit.hu>
References: <20020926105958.GB423@alfred.one2one-networks.com> <20020926141605.E3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "Jesper L. Nielsen" <jln@one2one-networks.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20020926141605.E3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 26, 2002 at 02:16:05PM +0200, Harald Welte wrote:
> On Thu, Sep 26, 2002 at 12:59:58PM +0200, Jesper L. Nielsen wrote:
> > Hello Harald.
> > The idea is to make a NAT helper that is bound to incoming port 80. The
> > helper should be able to parse the packages containing HTTP requests,
> > and upon seing af defined host, lets say 'slashdot.org' it should be
> > able to redirect this trafic to a different port (eg. port 8000). 
> >  So normal traffic flows by into port 80, but upon a HTTP request
> > containing the line: 'Host: slashdot.org', it should be sent to port
> > 8000, which could be a different HTTP server, listening on port 8000.
> 
> how do you want to do that?
> 
> you cannot have a couple of packets pass, and then at a certain point
> within the TCP stream start redirecting packets to other hosts/sockets/...
> 
> At the time you see the ULR (http get request), the tcp connectin is
> established, the full handshake has completed, window scaling/ecn/... has been
> negotiated, etc.
> 
> The only solution for your problem seems to be a transparent proxy which 
> redirects part of the traffic, and passes on all other traffic.

In fact transparent HTTP proxies usually read in the whole request (method +
headers), and start connecting to the server after the request has been
successfully parsed. Zorp for example does exactly this, and it is easy to
do this kind of job.


-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
