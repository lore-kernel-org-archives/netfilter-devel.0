From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] tcp-window-tracking patch
Date: Tue, 9 Dec 2003 17:15:15 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312091713500.26124-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0312091410570.5228-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0312091410570.5228-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 9 Dec 2003, Jozsef Kadlecsik wrote:

> Yes, that's true. The original value was 60 secs. That was increased to 3
> days in the window tracking code, which was surely excessive: there might
> be no resent traffic to detect and thus long dead connections could stay
> in the hash table. Hard to choose the proper value, which does not break
> either way.

Would it be possible to classify these as "junk" somehow with the
intention to keep them around in the connection table longer when not
under pressure?

Regards
Henrik
