From: Patrick Schaaf <bof@bof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sun, 9 Jun 2002 10:29:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020609102928.F23410@oknodo.bof.de>
References: <3D007D73.9030609@cs.auc.dk> <3D016699.9010301@cs.auc.dk> <20020608102140.C23410@oknodo.bof.de> <200206081402.17562@henrik.marasystems.com> <3D02FDBF.6070005@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <3D02FDBF.6070005@cs.auc.dk>; from fleury@cs.auc.dk on Sun, Jun 09, 2002 at 09:03:27AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Thanks a lot for pointing ip_conntrack_core.c and explain all this !

Agreed. Thanks, Henrik.

> The problem is that the definition of the HOWTO states that NEW match:
> 
>      A packet which creates a new connection.
> 
> That's not true if you consider this from the protocol point of view

I think you are correct here; there's an ambiguity here, and I'd wish
connection tracking would be called flow tracking or something. However,
it's too late for that, now.

Realistically, I think that the docs would be best augmented by an extra
chapter on "why does the man-in-the-middle say connection to different
things than the protocols". Bad title, I know, but instead of explaining
the difference partially and clumsily everywhere it matters, a lucid extra
part of the docs would be preferrable (and then reference that where it
matters).

> > Of these, only ASSURED is directly dependent on the TCP connection 
> > tracking state, the others are only dependent on the ability of 
> > identifying which connection the packet may belong to.
> 
> Actually, ASSURED seems to be related to all the protocols which
> expect a confirmation from the receiver before establishing the
> connection (but in your case only TCP need a confirmation. UDP and
> ICMP does not need this). Right ?

Right, I think. If another protocol parallel to TCP comes along which has
such a setup phase (SCTP comes to mind), it could be handled likewise.
Also, I could imagine special TCP conntrack helpers to go even further,
and defer the ASSURED marking to a point where more of the connection
is known, e.g. real data has been seen in one direction, and correctly
acked.

best regards
  Patrick
