From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Trivial space char fix for --log-prefix
Date: Fri, 12 Dec 2003 00:03:21 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312120001440.4649-100000@filer.marasystems.com>
References: <20031211130633.GB22826@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Michael Rash <mbr@cipherdyne.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031211130633.GB22826@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Dec 2003, Harald Welte wrote:

> We have received such a patch numerous times.  However, we felt that
> changing the behaviour now is bad - everybody knows about the old
> behaviour by now, and all the scripts that have been written in the last
> couple of years assume it to _not_ automatically add the space.

Please note that the proposed patch only adds a space if there was none. I
do not think anyone with a working mind is intentionally using the fact
that the --log-prefix can be used without a space to separate it from the
rest of the log result today.

Regards
Henrik
