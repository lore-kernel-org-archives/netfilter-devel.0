From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables userspace build patch (CLASSIFY & NETMAP extensions)
Date: Sat, 13 Sep 2003 09:39:30 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309130938520.25469-100000@filer.marasystems.com>
References: <20030912212651.GG4398@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030912212651.GG4398@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Sep 2003, Harald Welte wrote:

> Both of the targets fall in category three.  This means that if the
> kernel headers are missing, they need to be committed to the CVS
> repository (which I seem to have forgotten).

Ok.

In such case the test for NETMAP should be deleted from the CVS.

Regards
Henrik
