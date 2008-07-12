From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: REDIRECT in nat OUTPUT
Date: Sat, 12 Jul 2008 10:28:13 +0400
Message-ID: <20080712062812.GA7609@2ka.mipt.ru>
References: <200807120424.56462.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Denys Fedoryshchenko <denys@visp.net.lb>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200807120424.56462.denys@visp.net.lb>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi.

On Sat, Jul 12, 2008 at 04:24:56AM +0300, Denys Fedoryshchenko (denys@visp.net.lb) wrote:
> Always all rules with REDIRECT to local port is dropping speed around 100Kbyte/s. What can be the problem?

Can you run oprofile on this machine?

-- 
	Evgeniy Polyakov
