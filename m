From: Patrick Schaaf <bof@bof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Sat, 8 Jun 2002 10:21:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020608102140.C23410@oknodo.bof.de>
References: <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk> <20020607133300.GD595@morinfr.org> <3D00CDB4.3060605@cs.auc.dk> <20020607183600.GD630@morinfr.org> <20020607210026.B23410@oknodo.bof.de> <3D016699.9010301@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3D016699.9010301@cs.auc.dk>; from fleury@cs.auc.dk on Sat, Jun 08, 2002 at 04:06:17AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > Alternatively, if no answer comes back at all, the conntrack is in the
> > (extra) state UNREPLIED. When the connection table becomes full, UNREPLIED
> > connections are recycled preferentially.
> 
> Hey, this is not fair !!!!!

The behaviour is as fair as it can be, IMO.

> This behaviour is not described in ip_conntrack_proto_tcp.c.
> Where is it coded ????

Mostly in ip_conntrack_core.c. The early_drop() and unreplied() functions
implement the checking, based on the IPS_ASSURED bit in conntrack->status.
Use "grep" to see where that bit is set.

best regards
  Patrick
