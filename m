From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] TCP window tracking over-window handling
Date: Wed, 2 Feb 2005 08:00:09 -0800
Message-ID: <20050202160009.GB30465@linuxace.com>
References: <20050128234334.GA20713@linuxace.com>
	<Pine.LNX.4.58.0502021017590.24272@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502021017590.24272@blackhole.kfki.hu>
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

On Wed, Feb 02, 2005 at 10:46:01AM +0100, Jozsef Kadlecsik wrote:
> That implies then that the receiver is broken as well, by accepting and
> ack-ing out of window segments. But it is true, we anticipate the
> behaviour of the receiver here, which we shouldn't.

The receiver was a linux 2.6.10 box, so not an uncommon OS ;-)  The original
problem was noted by clients on Win2K and WinXP against the same FTP server.

> The current code follows closely TCP/IP Illustrated vol 2, p. 954: Trim
> Segment so Data is Within Window.
> 
> Do you know the OS of the communicating parties? Weren't window scaling or
> SACK negotiated?

The FTP server was an NT 4.0 box running IIS 3.0 ftp service.  As noted
above, receiver was the Linux firewall itself.  There was no window
scaling or SACK involved.  

> With your proposed patch, we'd actually drop the oow segment. Could you
> check that it won't cause problems (besides more logging generated :-)?

I agree -- the oow segment is dropped, but this at least doesn't break
the communication.  Without this patch, I cannot complete a large (5mb)
download from this server.  With this patch, it never fails.

Reviewing the ipfilter code, it doesn't seem the author included this check.
So what was the rationale for including it in the netfilter version?  I
can't think of what it is protecting us from.

Phil
