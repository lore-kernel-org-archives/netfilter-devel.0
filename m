From: Patrick Schaaf <bof@bof.de>
Subject: Re: MAC Filtering
Date: Wed, 5 Jan 2005 17:22:12 +0100
Message-ID: <20050105162212.GA12584@oknodo.bof.de>
References: <200501051425.36450.erwin.vandevelde@gmail.com>
	<17648.213.236.112.75.1104937880.squirrel@213.236.112.75>
	<200501051712.18817.erwin.vandevelde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Content-Disposition: inline
In-Reply-To: <200501051712.18817.erwin.vandevelde@gmail.com>
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

> if it can filter on source MAC addresses, why can't it filter on destination
> MAC addresses?

Destination MAC addresses are potentially unknown until after an ARP reply
has been received. All iptables processing has already been done before
an ARP request is even sent...

best regards
  Patrick
