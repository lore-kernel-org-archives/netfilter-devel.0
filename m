From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: netfilter on solaris?
Date: Sat, 15 Jun 2002 15:37:25 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020615133725.GC13464@balabit.hu>
References: <20020614100540.GA6399@balabit.hu> <20020615145212.S2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020615145212.S2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 15, 2002 at 02:52:12PM +0200, Harald Welte wrote:
> On Fri, Jun 14, 2002 at 12:05:40PM +0200, Balazs Scheidler wrote:
> > Hi,
> > 
> > It is a strange idea I know, but I'd be interested in what the opinion of
> > the core netfilter developers is on porting the whole netfilter subsystem to
> > Solaris?
> 
> After my netfilter presentation at linuxtag, somebody was asking me exactly
> this question.

And your answer was?

> > Apart from the technical issues, would there be any problems? Does the GPL
> > allow this kind of usage? (it would be implemented as a module)
> 
> This is basically the same question like binary-only kernel modules. 

I think it is more similar to Gimp plugins under Photoshop case.

> 
> Having netfilter within a different kernel, is technically the same: 
> GPL'd netfilter/iptables code is called from a binary-only kernel.  

Under binary-only you mean propriatery, or something nonGPLd? Solaris kernel
source _is_ available, though it doesn't use the GPL.

> Thus, my conclusion would be: Without the explicit permission of the authors,
> it is legally not possible to use netfilter/iptables within a proprietary
> OS kernel.  But of coursel, I am not a lawyer.
> 
> I for myself are somewhat undecided, but I tend to share Rusty's view:
> I haven't ever given permission for using my code by binary only kernel
> modules.  All new code I'm working on wil export GPLONLY to make sure
> about that.

I think while disallowing binary only modules restrict the vendors who
release propriatery software relying on free software, disallowing netfilter
on propriatery platforms restrict users who would like to use free software
on their platform. Even the GPL makes difference between propriatery system
and non-system libraries.

While it is a possibility to dump the native OS, and replace it with Linux,
most non-x86 platforms work with their native OS best (be it HP-UX, Solaris
or Tru64).

This argument is worthless anyway. The task is tedious, and without support
of the original developers it would die immediately.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
