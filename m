From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [BUG] yet another icmp reply transition bug
Date: Thu, 31 Oct 2002 10:49:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021031094950.GA2368@balabit.hu>
References: <20021029211506.A26147@sunbeam.de.gnumonks.org> <20021030184457.GA7720@balabit.hu> <20021031101329.K8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20021031101329.K8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Oct 31, 2002 at 10:13:29AM +0100, Harald Welte wrote:
> On Wed, Oct 30, 2002 at 07:44:58PM +0100, Balazs Scheidler wrote:
> 
> > This is exactly the problem I have posted several times now. (I found it
> > during my tproxy development). I have modified ICMP nat so that the inner
> > packet is translated at the same time the outer packet is. I saw no real
> > reasons to NAT ICMP packets in two phases (other than simmetricity). 
> 
> Mh.  Somehow I never really understdood the implications and the significance
> of your findings.  I'm sorry for my ignorance.

no problem.

> 
> > When fixing the problem I came up with two solutions:
> > 
> > 1) fix opposite_hook, and allow many possible points of inner header
> >    translation (e.g. a manip in PREROUTING may mean ICMP reply in
> >    POSTROUTING _or_ LOCAL_IN _or_ LOCAL_OUT)
> 
> This was my initial idea as well.  But it becomes horribly complex and
> looks more like a hack - the kind of code where you need more comments
> than code in order to make it half-way understandable :(

that's what I meant on 'not robust' ;)

> 
> > 2) as the first one doesn't seem too robust to me, I fixed the translation
> >    and did the whole thing in one step. The inner header is translated at
> >    the same time the outer header is translated. I have seen no real use in
> >    having the inconsistent (translated outer, and untranslated inner header)
> >    packet traverse the IP stack.
> 
> This sounds reasonable.  The question is: Do we ever have a case where we
> cannot translate both, but still want the packet to be passed on?  But
> in case of uncertainty, passing less information is preferred than yet another
> information leak (about internal addresses, ...).

The same manip is applied to both the inner and outer headers. So I think
there's no case when we don't know what to do. (once we have that single
manip)

conntrack happens prior to NAT, so the icmp packet is already taken as
related to a session, conntracking will not be affected.

The only possible problem I see is packet confirmation (a quick look shows
that it doesn't care about ICMP though)

PS: I've been running with this fix applied for ages now, and I saw no
problems.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
