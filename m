From: Willy TARREAU <willy@w.ods.org>
Subject: Re: faster way to read conntrack state than /proc ?
Date: Sat, 18 Oct 2003 11:04:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031018090420.GA1150@pcw.home.local>
References: <20031018074256.GA29942@alpha.home.local> <1066467318.12167.80.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1066467318.12167.80.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Oct 18, 2003 at 10:55:19AM +0200, Martin Josefsson wrote:
 
> We have something called nfnetlink and ctnetlink. ctnetlink has the
> ability to dump all connections via netlink (unless someone, possibly
> me, broke it).

Thank you very much Martin for all these details. I will take a look at all
this soon. Don't worry, I won't complain about the bugs (though I may report
them), and I understand that this is not production-ready. My first goal was to
be able to report statistics about number of established, syn_recv, close_wait
and time_wait connections without killing the machine.

Cheers,
Willy
