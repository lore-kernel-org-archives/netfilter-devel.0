From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [2.6] Nonsense-messages from iptables + co.
Date: Fri, 14 Nov 2003 20:08:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0311142004510.10963@dns.toxicfilms.tv>
References: <20031114132054.GA646@merlin.emma.line.org>
 <20031114151004.GE2395@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20031114151004.GE2395@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > This is IMHO a MUST-FIX before 2.6.0.
>
> It is even in 2.4.x, where it could have been fixed throughout the last
> couple of years.  Nobody else has yet complained.
Well, I have noticed an increased amount of these 2 weeks ago, and I
belive it was Patrick McHardy, who found a bug that could cause these
to show, when no root process was creating any invalid packets.

AFAIK, it has been fixed in 2.6.0-test9-bk16 or around that.

The message stays though :-)

Maciej.
