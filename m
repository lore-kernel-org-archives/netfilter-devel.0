From: Patrick Schaaf <bof@bof.de>
Subject: Re: MAC address matching. Or other ideas.
Date: Sat, 10 May 2003 15:43:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030510134313.GD28426@oknodo.bof.de>
References: <3EB5A38C.4090606@dev-zone.org> <20030510105942.GB28426@oknodo.bof.de> <Pine.LNX.4.51.0305101521550.1781@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, Daniel <daniel@dev-zone.org>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0305101521550.1781@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 10, 2003 at 03:24:16PM +0200, Maciej Soltysiak wrote:
> > You could, maybe, be lucky to have it in the POSTROUTING table. But I
> > doubt that.
> Hmm, how about an another netfilter hook somewhere in the output code
> path, when the dst mac is known?

There was a proposal for such a thing, some time ago, I think by Don Cohen.
The intent, there, was to have a way to do things after traffic control.
As a personal example, it could be nice to have a way to do accounting
only for those packets that really made it through; customers could
complain that they are billed for dropped packets.

In principle, such a chain would have to sit in the network card driver
output path, just before a packet is really handed over to the hardware.
The destination MAC will surely be resolved, there.

One thing that I find a bit icky, is that there, we are clearly
"out and below" the IPv4 stack, so we have left the native scope of
the iptables tool. Thus, another iptables table could be problematic,
and another clone like arptables or ebtables, maybe called devtables,
would be more appropriate.

best regards
  Patrick
