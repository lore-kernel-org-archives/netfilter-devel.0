From: Mike Smith <mikesmith1@btconnect.com>
Subject: Re: Oops in replace_in_hashes (ip_net_core.c) 2.4.19
Date: Mon, 21 Jul 2003 14:08:57 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E19eaLc-0004WN-Kz@kashyyyk.netfilter.org>
References: <S261808AbTGAJfh/20030701093537Z+14616@vger.kernel.org> <20030721084011.8347162D3E@wlug.westbo.se> <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: linux-net@vger.kernel.org,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.52.0307211319260.16207@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
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
