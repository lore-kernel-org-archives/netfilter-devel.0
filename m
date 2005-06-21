From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: pptp conntrack stream timeout
Date: Tue, 21 Jun 2005 11:18:17 +0200
Message-ID: <200506211118.17112.thomas.jarosch@intra2net.com>
References: <200506201545.14009.thomas.jarosch@intra2net.com>
	<20050620222920.GB23109@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050620222920.GB23109@obroa-skai.de.gnumonks.org>
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

On Tuesday 21 June 2005 00:29, Harald Welte wrote:
> > while looking at the source of the PPTP conntrack helper,
> > I noticed the "PPTP_GRE_STREAM_TIMEOUT" is set to 5 days.
> >
> > Is there a reason why this timeout is so high?
> > 5 days is pretty long for a timeout.
>
> It's set to the same timeout like the TCP ESTABLISHED timeout.
>
> The main reason being that it is impossible to spoof a connection from
> one side into that state without appropriate feedback traffic.  The
> other reason being that nothing in the respective protocol
> specifications prevent a tunnel (or a tcp session) from being completely
> idle for an indefinite amount of time before continuing traffic.
>
> 5 days is the compromise between now and eternity ;)

Thanks for enlightening me :)

Thomas
