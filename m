From: Willy Tarreau <willy@w.ods.org>
Subject: Re: Possible problem with tcp-window-tracking
Date: Tue, 22 Jun 2004 06:46:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040622044606.GB21406@alpha.home.local>
References: <Pine.LNX.4.33.0406212105040.1107-100000@blackhole.kfki.hu> <1087848492.10514.10.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1087848492.10514.10.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On Mon, Jun 21, 2004 at 10:08:12PM +0200, Martin Josefsson wrote:
 
> Yup, only logging the first 96 bytes per packet (default tcpdump
> snaplength it seems).

If disk space becomes a problem, you can compress on the fly (I always
do this now for long captures and it helps) :

# tcpdump -w - | gzip -c9 > capture.gz

and to stop it and flush the output buffer through gzip :

# killall -INT tcpdump

I've already done this to get several gigabytes of traffic.

Cheers,
Willy
