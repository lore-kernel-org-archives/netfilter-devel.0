From: Mike Smith <mikesmith1@btconnect.com>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19
Date: Mon, 21 Jul 2003 14:08:57 +0000
Sender: linux-net-owner@vger.kernel.org
Message-ID: <S270013AbTGUMtz/20030721124955Z+1316@vger.kernel.org>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org> <20030721084011.8347162D3E@wlug.westbo.se> <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-net@vger.kernel.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
List-Id: netfilter-devel.vger.kernel.org

On Monday 21 Jul 2003 11:22 am, Martin Josefsson wrote:
> I'll look over it again later tonight, in the mean time could you switch
> to 2.4.21? And apply everything from submitted and pending in
> patch-o-matic from cvs (cvs instructions can be found on
> http://netfilter.org). Any eventual debugging-patches will be against that
> kernel and those patches.
>
> /Martin

Martin,

thanks for taking an interest in this. I've now switched to 2.4.21.
I'll wait for a bit before taking the patch-o-matic plunge,
(to double-check that 'vanilla' 2.4.21 is stable).

--Mike
