From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: oops in replace_in_hashes
Date: Fri, 25 Jul 2003 12:41:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725104107.GA6015@balabit.hu>
References: <20030725085731.GA5776@balabit.hu> <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 25, 2003 at 11:08:16AM +0200, Martin Josefsson wrote:
> On Fri, 25 Jul 2003, Balazs Scheidler wrote:
> > In our situation we do not have _any_ helpers loaded, only TPROXY generates
> > dynamic NAT mappings as they are needed. Is it possible that the reference
> > counting problem affects us?
> 
> Shouldn't be. This problem exists in 2.4.19 and 2.4.21 with
> submitted/pending patches from pom.
> 
> And it shouldn't be the TPROXY stuff either since it's seen without that
> stuff as well.
> 
> I'm a bit short on time but I hope I'll be able to look at it next week.
> Maybe someone else feels like going on a bughunt during the weekend?

I'm definitely interested in hunting this bug down before next week. 

The problem is that it is very difficult to reproduce it, and I can't put
any debug patches to where it happens.

I've already checked out the hashtable locking, and it seems to be correct
to me, e.g. all NAT hash table manipulation is protected by the ip_nat_lock
lock. As the oops happens during the list manipulation in replace_in_hashes,
I think this is some reference counting problem again (e.g. the conntrack is
freed while it is still in the NAT hash)

I'm going to validate conntrack reference counting, similarly to what I've
done with locking. I'd be grateful for further hints you might have.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
