From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: Logs behind a transparent proxy
Date: Wed, 29 Jan 2003 14:08:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030129130806.GB9188@balabit.hu>
References: <1043363627.3e30772b136d4@imp.free.fr> <200301291146.48346.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: =?iso-8859-1?Q?Gr=E9gory?= <gregory.wajs@free.fr>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200301291146.48346.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 29, 2003 at 11:46:48AM +0100, Bart De Schuymer wrote:
> On Friday 24 January 2003 00:13, Grégory wrote:
> > I'd like to make a "really" transparent bridge using a proxy.
> > Though when  watching my logs on my server (behind the bridge), I
> > always get the proxy IP  (which is normal). I'd like to know if
> > there's an existing patch to iptables that could hide the proxy's
> > adress by putting back the real source adress when the traffic is
> > coming from Internet.
> 
> If I understand correctly, the bridge proxy will make new IP packets to talk 
> with the server and therefore the IP packets have the proxy's IP. Because 
> these are new packets, it seems hard to get your requested behaviour using 
> iptables. I think it's much easier to hack the code of the proxy, maybe it's 
> even already an option there.

Check my transparent proxy patches. They are reported to work in bridging
mode, though a couple of conflicts in the patches need to be sorted out.

Note that your proxy need to be modified a bit to be able to do what you
want.

http://www.balabit.hu/en/downloads/tproxy/

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
