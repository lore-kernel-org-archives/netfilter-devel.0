From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: NAT for IPv6
Date: Thu, 20 Nov 2003 16:06:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031120150641.GB1330@balabit.hu>
References: <Pine.LNX.4.51.0311191336570.8218@dns.toxicfilms.tv> <20031120134042.GA28035@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20031120134042.GA28035@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 20, 2003 at 02:40:42PM +0100, Harald Welte wrote:
> On Wed, Nov 19, 2003 at 01:38:47PM +0100, Maciej Soltysiak wrote:
> > Hello,
> > 
> > out of curiousity - are there plans to incorporate NAT into ip6tables
> > or future pkttables ?
> 
> over my dead body.  NAT is what broke ipv4 end-to-end.  Let's not do the
> same with ipv6.
> 
> The only reasonable application is ipv4-to-ipv6 transition-nat.

s/transition-nat\./transition-nat, and local NAT necessary for TPROXY to work./

please.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
