From: Patrick Schaaf <bof@bof.de>
Subject: Re: Fwd: Re: Interesting request. block x.x.0.0
Date: Fri, 24 Jan 2003 00:17:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030123231732.GA13498@oknodo.bof.de>
References: <200301231642.40937.danielf@supportteam.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Daniel F. Chief Security Engineer -" <danielf@supportteam.net>
Content-Disposition: inline
In-Reply-To: <200301231642.40937.danielf@supportteam.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I do not want to block every IP on say 45.208.0.0/16 just the ips ending in
> 0.0 as the last two octets.

Ahem.

Everything under 45.208.x.x with 0.0 as the last two octets:

	iptables -A INPUT -s 45.208.0.0 -j DROP

Everything from everywhere with 0.0 as the last two octets:

	iptables -A INPUT -s 0.0.0.0/0.0.255.255 -j DROP

Did I misunderstand something?

best regards
  Patrick
