From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: local NAT
Date: Wed, 11 Jun 2003 17:19:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611151922.GA15206@balabit.hu>
References: <20030607215013.4F9B8444E8@service.i-think-future.de> <20030611120649.GK32593@sunbeam.de.gnumonks.org> <20030611140313.GB8055@balabit.hu> <20030611145856.GT32593@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Nils Radtke <Nils.Radtke@Think-Future.de>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030611145856.GT32593@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 11, 2003 at 04:58:56PM +0200, Harald Welte wrote:
> On Wed, Jun 11, 2003 at 04:03:13PM +0200, Balazs Scheidler wrote:
> > a security proxy analyzing HTTP requests before the real webserver gets its
> > hand on it. if you want the webserver to get the original client as the
> > source of the connection you need something like this.
> 
> Oh, well.  Either you or me misunderstood the feature Nils was
> requesting.  You seem to be talking about SNAT'ing outgoing packets sent
> by local processes.  I was talking about SNAT'ing incoming packets
> received for a socket of a local process.
> 
> Nils: which one are you interested in?

I am talking about SNATing outgoing packets sent by local processes destined
_to_ a local process.

Is this the same case?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
