From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 22:31:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725203114.GA7921@balabit.hu>
References: <20030725085731.GA5776@balabit.hu> <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se> <20030725135020.GA6433@balabit.hu> <20030725173555.GA7458@balabit.hu> <1059157364.21504.23.camel@henrik.marasystems.com> <20030725201650.GJ10897@naboo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030725201650.GJ10897@naboo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 25, 2003 at 10:16:50PM +0200, Harald Welte wrote:
> On Fri, Jul 25, 2003 at 08:22:44PM +0200, Henrik Nordstrom wrote:
> > fre 2003-07-25 klockan 19.35 skrev Balazs Scheidler:
> > Assuming this is a reuse after free overwrite by bogus array index
> > thereby hitting an unexpected element in the structure you should be
> > able to find the source of this by identifying all array type positions
> > where the IP address may have been legally written into the
> > ip_conntrack. Check if the overwriten location is reachable via the
> > array. Then look for assignments of this member and you have a likely
> > victim.
> 
> num_manips is set to 0 while we memset a newly-allocated conntrack.
> After that, it is only incremented.  The array is only accessed via the
> num_manips used as index. And after every increment, we have a
> IP_NF_ASSERT().

yes but my oops was produced with debugging disabled, and IP_NF_ASSERT does
nothing in that case. 

> btw: What compiler are you using?  Since we've had a couple of strange
> reports with gcc-3.x recently, could you try a gcc-2.95?

I am using gcc 2.95.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
