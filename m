From: Patrick Schaaf <bof@bof.de>
Subject: Re: Fun for netfilter developers :)
Date: Tue, 6 May 2003 20:48:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030506184824.GG23689@oknodo.bof.de>
References: <20030506161515.GH14822@sunbeam.de.gnumonks.org> <20030506171550.GD23689@oknodo.bof.de> <20030506183223.GJ14822@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick Schaaf <bof@bof.de>,
  Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030506183223.GJ14822@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Please _do not_ [XXX]

Of course. Sorry for the outburst, and thanks JF for the rpm2cpio snippet.

> At least they did care about T/TCP.

I wonder whether they had a need, or whether it was a completely
academic exercize.

In any case, I'd be wary of LOCAL_IN PRI_FILTER, as that should be
prone to module load order weirdness.

And, isn't the "functionality" already in UNCLEAN (if sane)?

all the best
  Patrick
