From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] netfilter unclean match extension
Date: Wed, 23 Oct 2002 13:26:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210231323200.20094-100000@dns.toxicfilms.tv>
References: <20021023.040314.88793185.davem@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: laforge@gnumonks.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20021023.040314.88793185.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>    Exerpt from RFC 791: Various Control Flags.  Bit 0: reserved, must be zero
>
> Just to be clear, if a future RFC or ietf working draft defines
> meaning for this field, will we remove this new test from the
> unclean module?
Then, we should update the match to remove the test as it may render some
routers inoperational for some data streams, vide the ECN issue.

Best Regards,
Maciej Soltysiak
