From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Sat, 29 Jun 2002 12:03:20 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629120320.K4136@oknodo.bof.de>
References: <3D1D81F8.9080309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3D1D81F8.9080309@trash.net>; from kaber@trash.net on Sat, Jun 29, 2002 at 11:46:32AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> After not receiving a response for two weeks second try:

Sorry. Here we go:

> The attached patch adds a new option --terminate to the MARK target 
> which lets the user choose if MARK should return IPT_CONTINUE
> (normal behaviour) or NF_ACCEPT (to terminate further rule processing).
[...]
> A CONNMARK patch will follow

Will you also add this to LOG, ULOG, and any other IPT_CONTINUE target
that may come up in the future? In my opinion, this is misguided, because
it leads to much code duplication in target modules.

There is already a flexible, but somewhat ugly, way to do what you want:
create a user defined chain that first MARKs then ACCEPTs (or does whatever
else one may want to be done after MARK). Obviously, this is a bit ugly
because you need one such chain per MARK value.

The good way to do it, in my opinion, would be to permit more than one
target per iptables rule. You could then write

	iptables -A somewhere -m something -j MARK --mark 1 -j ACCEPT

Note that I do _not_ oppose adding your --terminate option to MARK, as a
stopgap measure. If that is helpful now, it should be done, IMHO.

However, I'd like to hear people's opinions on the multitarget approach.

best regards
  Patrick
