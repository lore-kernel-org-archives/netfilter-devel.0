From: Patrick Schaaf <bof@bof.de>
Subject: Re: REJECT target
Date: Thu, 26 Jun 2003 17:19:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030626151947.GA10045@oknodo.bof.de>
References: <Pine.LNX.4.33.0306260830550.10452-100000@blackhole.kfki.hu> <1012141349.20030626165642@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: DarKRaveR <DarKRaveR@habitat-b.de>
Content-Disposition: inline
In-Reply-To: <1012141349.20030626165642@habitat-b.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Okay, admitted. I would be glad to do that in the filtering table, the
> question is: How can I identify those packets, when the were modified
> in the nat table ?

One approach that I used in some places, and which could be workable
for your scenario, is to use the MARK target at mangle/PREROUTING,
and then use the mark match both in the NAT decision, and in the
filter table. The firewall mark stays with the packet, regardless
of application of a NAT action.

The CONNMARK stuff may be even more useful / cover more cases.

best regards
  Patrick
