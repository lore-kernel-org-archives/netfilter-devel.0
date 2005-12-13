From: DervishD <lartc@dervishd.net>
Subject: Re: MARK: targinfosize 8 != 4
Date: Tue, 13 Dec 2005 21:37:30 +0100
Message-ID: <20051213203730.GD19326@DervishD>
References: <00fe01c5ffb5$f0a7cf20$455f030a@askeyrd3>
	<20051213091820.GA1021@DervishD> <439EB826.3070002@trash.net>
	<200512131809.jBDI9lAW028466@usagi.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Jones Desougi <jones@ingate.com>
Content-Disposition: inline
In-Reply-To: <200512131809.jBDI9lAW028466@usagi.ingate.se>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

    Hi Jones :)))

 * Jones Desougi <jones@ingate.com> dixit:
> > That can't be the reason, all revisions of a single match/target
> > are in the same object file and the supported revision is
> > (supposed to be) probed.

    They are not due to the DONT_LOAD usage ;)) The patch below is
much better than the one I tested ;)))

> Try the patch below. (It's bug #413 in bugzilla)

    Thanks a lot :)) I'll test it as soon as I can.

    Ra=FAl N=FA=F1ez de Arenas Coronado

--=20
Linux Registered User 88736 | http://www.dervishd.net
http://www.pleyades.net & http://www.gotesdelluna.net
It's my PC and I'll cry if I want to...
