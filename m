From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Feasability of Protocol Filtering
Date: 24 Apr 2003 00:37:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051137456.28404.34.camel@tux.rsn.bth.se>
References: <3EA7056F.2050601@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <tady@gmx.net>
In-Reply-To: <3EA7056F.2050601@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2003-04-23 at 23:28, Eicke Friedrich wrote:

> I'm going to test the behavior of my match in a couple of weeks for a 10MBit/sec 
> environment - if someone is interessted i can send the results to the list or put it on a 
> webpage.

I do something similar here, no problem to do two stringmatches on a
100Mbit/s link.

I benchmarked the stringmatch a bit a while ago.
On my pIII it uses ~50k cycles / kB.

If using the Boyer-Moore algorithm instead you get it down to ~3k cycles
/ kB when searching for a 5 byte string (cpu usage decreases with string
length)

The Boyer-Moore patch was sent to this list quite some time ago. I
should update it so it applies.

-- 
/Martin
