From: Andreas Steinmetz <ast@domdv.de>
Subject: Re: mss to pmtu clamping partially broken?
Date: Mon, 02 Jul 2007 19:02:15 +0200
Message-ID: <46892F97.9060400@domdv.de>
References: <4684E853.20900@domdv.de> <4684EF6A.7070109@trash.net> <4684F3D8.1080800@domdv.de> <4684F4FB.9070807@trash.net> <4684F5D3.8020506@domdv.de> <4684F75E.90304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754930AbXGBRCa@vger.kernel.org>
In-Reply-To: <4684F75E.90304@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Its possible that one of your ISPs is doing clamping. You could
> check on ppp0 if thats the case. Or maybe for some reason the
> PMTU value for the internal host is smaller than 1500. You can
> check that by doing "ip route get <internal host>".
> 
> 

Oh well, thew fun with ISPs. Same provider, clamping on one line but not
the other. This is fun :-(

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
