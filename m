From: Patrick Schaaf <bof@bof.de>
Subject: Re: Changing the Ethernet header
Date: Thu, 17 Feb 2005 09:34:03 +0100
Message-ID: <20050217083403.GA464@oknodo.bof.de>
References: <7DC268DDBA95E14D8572DF824F92789E03EE2B@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Gil Shai <GilS@GoNetworks.com>
Content-Disposition: inline
In-Reply-To: <7DC268DDBA95E14D8572DF824F92789E03EE2B@gn-ex01.Go80211.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Anyone has ideas as to why or what are the possible reasons to this
> phenomenon?

You are messing with stuff that is not to be messed with. iptables
operates at a layer above Ethernet, and THE KERNEL (the core network
stack's destination, neighbour, and hard header cache components),
manages the ethernet headers.

There is a fullblown VLAN support infrastructure in the kernel.
What are you trying to do, that cannot be done using that infrastructure?

best regards
  Patrick
