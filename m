From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Wed, 15 Oct 2003 20:33:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310152033.02264.bdschuym@pandora.be>
References: <200310122243.38551.bdschuym@pandora.be> <20031014105825.GA3752@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Stephen Hemminger <shemminger@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031014105825.GA3752@obroa-skai.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 14 October 2003 12:58, Harald Welte wrote:
> what about ip6_queue.c ?  Would you need a similar fix for ipv6
> bridging  If yes, could you please merge your changes with ip6_queue.c
> and send me a cumulative patch?

IPv6 isn't currently passed to ip6tables, so that code doesn't need fixing.

cheers,
Bart
