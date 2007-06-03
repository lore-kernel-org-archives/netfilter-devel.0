From: Dmitry Mishin <dim@openvz.org>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Sun, 3 Jun 2007 10:47:44 +0400
Message-ID: <200706031047.44848.dim@openvz.org>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr> <465CA950.403@trash.net> <4661687F.6040302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <4661687F.6040302@trash.net>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Saturday 02 June 2007 16:54, Patrick McHardy wrote:
> Patrick McHardy wrote:
> > Jan Engelhardt wrote:
> >>This is fixed in 2.6.21, thanks.
> >
> > Yes, the hashlimit compat issue is. But the underlying problem still
> > persists, I'll send you a patch for testing soon.
>
> Here it is, could you please test whether it fixes the crash by
> backing out the hashlimit compat patch and triggering the size
> error again? Thanks.
Patrick, 
it looks like translate_compat_table() should be fixed also.

-- 
Thanks,
Dmitry.
