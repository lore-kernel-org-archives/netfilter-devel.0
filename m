From: Patrick Schaaf <bof@bof.de>
Subject: Re: default behavior & skb_linearize
Date: Fri, 15 Aug 2003 20:28:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030815182851.GB3190@oknodo.bof.de>
References: <200308151756.h7FHus514738@p2.parker.boston.ma.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Parker <brad@parker.boston.ma.us>
Content-Disposition: inline
In-Reply-To: <200308151756.h7FHus514738@p2.parker.boston.ma.us>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I want to so some work with iptables in a 2.4.20 kernel.

Try a current kernel. Apply patch-o-matic/pending from CVS.

> aside: I am assuming that if I turn on netfilter and connection tracking
> the "default" (i.e. no external rules loaded via iptables) should pass
> everything and the kernel nfs client should continue to work.  This is
> true, yes?

An emphatic YES: that's how it _should_ be.

> I can send the interesting parts of my .config if needed.

Only with a current kernel, I fear. 2.4.20, as far as I remember,
is supposed to be broken in the iptables area.

best regards
  Patrick
