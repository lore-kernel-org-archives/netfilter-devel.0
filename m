From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Policy match with a bridge
Date: Thu, 19 Aug 2004 20:10:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408192010.28417.bdschuym@pandora.be>
References: <411EAF08.3000401@shorewall.net> <411F7B87.7060303@shorewall.net> <41200E80.2000005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bridge@osdl.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	Tom Eastep <teastep@shorewall.net>
In-Reply-To: <41200E80.2000005@trash.net>
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

On Monday 16 August 2004 03:31, Patrick McHardy wrote:
> The problem is ipv4_sabotage_out in the briding code. It prevents the
> packet from hitting the LOCAL_OUT hook while it is still unencrypted.
> When it hits the bridging code and its LOCAL_OUT hook it's too late.
> Not sure how to handle it yet.

I'll have a look at that after I'm finished with the IPv6 bridge firewalling 
stuff.

cheers,
Bart
