From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Wed, 3 Jul 2002 13:36:45 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020703133645.A10560@oknodo.bof.de>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com> <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu>; from kadlec@blackhole.kfki.hu on Wed, Jul 03, 2002 at 01:24:46PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

For the record:

> match module:
> 	pro: no naming issue, current well known concepts can be kept
> 	pro: couple of modules can be unified
> 	con: ordering issue

I strongly prefer this solution, with the added requirement that order
issues should be defined clearly, and have a clear relationship to the
order given on the command line. If this is not the case now, this is
the time to fix it, IMHO.

best regards
  Patrick
