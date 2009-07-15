From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ebtables: Use print_mac instead of own function
Date: Wed, 15 Jul 2009 17:13:00 +0200
Message-ID: <4A5DF1FC.3050404@trash.net>
References: <1247655306-21337-1-git-send-email-klto@zhaw.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: bart.de.schuymer@pandora.be, shemminger@linux-foundation.org,
	davem@davemloft.net, ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Tobias Klauser <klto@zhaw.ch>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1247655306-21337-1-git-send-email-klto@zhaw.ch>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tobias Klauser wrote:
> ebt_log uses its own implementation of print_mac to print MAC addresses.
> This patch converts it to use print_mac from linux/if_ether.h

You can do this even simpler by using %pM as format string.

