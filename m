From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: ICMP DNAT bug fix no longer applies?
Date: Mon, 28 Apr 2003 12:49:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428104929.GA28196@balabit.hu>
References: <Pine.LNX.4.44.0304241412470.24242-100000@localhost> <20030427132039.GN990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Chris Wilson <chris@netservers.co.uk>,
	netfilter-devel@lists.netfilter.org,
	John McEleney <john@netservers.co.uk>,
	Philippe Biondi <biondi@cartel-securite.fr>
Content-Disposition: inline
In-Reply-To: <20030427132039.GN990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Apr 27, 2003 at 03:20:39PM +0200, Harald Welte wrote:
> On Thu, Apr 24, 2003 at 02:34:11PM +0100, Chris Wilson wrote:
> > Hi all,
> > 
> > Since the ICMP DNAT advisory came out last year
> > [http://www.iptables.org/security/2002-04-02-icmp-dnat.html], we have been 
> > applying this patch to all kernels we build. However, in between 
> > patch-o-matic 20030107 and 20030422 this has been broken and no longer 
> > applies.
> 
> This is becaue this bug should now finally have disappeared from all
> future kernels ;)
> 
> > Does anyone know why the DNAT bug fix hasn't been incorporated into 
> > the main codebase yet?
> 
> The reason was that the solution at that time was too intrusive into the
> core ipv4 stack to be applied by David Miller.
> 
> What we now have is a probably unclean solution, that mangles the same
> stuff in a packet twice :(  But this was necessarry for yet another
> number of ICMP NAT bugs (see bugzilla)

Which bugzilla bug do you mean? Assuming you mean bug#55, the patch I've
submitted does not mangle packets twice. Instead of doing packet mangling at
two different hooks as it was done originally (hook and its opposite hook),
it does it one go, but translation is not performed twice. (or there's
something I don't see)

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
