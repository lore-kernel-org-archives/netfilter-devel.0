From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: netfilter on solaris?
Date: Sat, 15 Jun 2002 15:13:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020615131326.GA13464@balabit.hu>
References: <20020614100540.GA6399@balabit.hu> <Pine.LNX.4.33.0206141216360.17029-100000@blackhole.kfki.hu> <20020614104707.GA6827@balabit.hu> <20020615145530.T2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020615145530.T2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 15, 2002 at 02:55:30PM +0200, Harald Welte wrote:
> On Fri, Jun 14, 2002 at 12:47:07PM +0200, Balazs Scheidler wrote:

> As long as I am one of the maintainers of netfilter/iptables, I am not 
> going to do any extra hassle in order to support different operating systems.
> This includes using weird different types instead of sk_buff.  Linux kernel
> hackers expect to see linux code, not something abstract using only typedefs
> and macros all over the place.

ok, it was only an idea. I thought netfilter would only benefit from the effort.
the technical problems would be overwhelming anyway.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
