From: Patrick Schaaf <bof@bof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 21:00:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607210026.B23410@oknodo.bof.de>
References: <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk> <20020607133300.GD595@morinfr.org> <3D00CDB4.3060605@cs.auc.dk> <20020607183600.GD630@morinfr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020607183600.GD630@morinfr.org>; from guillaume@morinfr.org on Fri, Jun 07, 2002 at 08:36:00PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > The funny thing is that if you have a bad ruleset, you can easily be
> > DOSed by some external people which are just sending random ACK packets.
> > 
> > Those ACKs will create entries in your connection table as ESTABLISHED
> > connections with a time-out of.... 5 days !!!!! 8-)
> 
> Well no, since the concerned box will reply with a RST.

Alternatively, if no answer comes back at all, the conntrack is in the
(extra) state UNREPLIED. When the connection table becomes full, UNREPLIED
connections are recycled preferentially.

The worst kinds of handleable DoS situations in this area, have been dealt
with 1-2 years ago.

best regards
  Patrick
