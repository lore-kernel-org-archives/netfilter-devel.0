From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Policy match with a bridge
Date: Sat, 16 Oct 2004 15:30:58 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410161530.58439.bdschuym@pandora.be>
References: <411EAF08.3000401@shorewall.net>
	<200408192010.28417.bdschuym@pandora.be>
	<416DC6EF.9050001@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bridge@osdl.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <416DC6EF.9050001@shorewall.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 14 October 2004 02:23, Tom Eastep wrote:
> Bart De Schuymer wrote:
> > On Monday 16 August 2004 03:31, Patrick McHardy wrote:
> >>The problem is ipv4_sabotage_out in the briding code. It prevents the
> >>packet from hitting the LOCAL_OUT hook while it is still unencrypted.
> >>When it hits the bridging code and its LOCAL_OUT hook it's too late.
> >>Not sure how to handle it yet.
> >
> > I'll have a look at that after I'm finished with the IPv6 bridge
>
> firewalling
>
> > stuff.
>
> Any progress on this?

You should be able to do what you want in the iptables mangle OUTPUT chain 
instead of the one in the filter table.
Patrick, a hack solution would be to temporarily change out->hard_start_xmit 
to something else than br_dev_xmit, that way you fool ipv4_sabotage_out.

cheers,
Bart
