From: Patrick Schaaf <bof@bof.de>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 15:50:38 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020625155038.A527@oknodo.bof.de>
References: <Pine.LNX.4.33.0206251119260.4927-100000@blackhole.kfki.hu> <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
In-Reply-To: <01ff01c21c45$c90eb2a0$0489cb8a@etbx180>; from jean-michel.hemstedt@alcatel.be on Tue, Jun 25, 2002 at 02:42:36PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> In my opinion, a first step should be to reconsider timeout values but
> also timer mechanisms.

No. A first step MUST be pointing out that the current timeouts become
a problem in REAL LIFE. Right now you are speculating.  On all setups
I personally know, the timeouts are NOT a problem.

Regarding timer _mechanisms_ I have seen no indication at all that the
current mechanism is a problem. If you want to insist, _please_ learn
about kernel profiling, and start posting FACT.

regards
  Patrick
