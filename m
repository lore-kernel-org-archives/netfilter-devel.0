From: Denis Ducamp <Denis.Ducamp@groar.org>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: Fri, 13 Dec 2002 15:17:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021213151734.A31607@groar.org>
References: <20021101021236.GA16306@pc.ilinx> <Pine.LNX.4.44.0212120252370.3113-100000@shieldbreaker.l33tskillz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0212120252370.3113-100000@shieldbreaker.l33tskillz.org>; from qralston+ml.netfilter-devel@andrew.cmu.edu on Thu, Dec 12, 2002 at 03:05:33AM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 12, 2002 at 03:05:33AM -0500, James Ralston wrote:
> (My specific need is related to DNS service: namely, in many cases, 30
> seconds to establish a UDP session simply isn't enough time to permit
> a reply to an outstanding DNS query.  I want to be able to up that
> timeout to something closer to 60 or 120 seconds.)

If your DNS servers serve zones then make them send requests from the udp/53
port, then late replies are accepted as requests by the filter.

Denis Ducamp.
