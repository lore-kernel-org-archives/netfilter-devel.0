From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Tue, 3 Jan 2006 08:05:54 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0601030804260.23554@yvahk01.tjqt.qr>
References: <4393895D.1020106@trash.net> <20051205004548.GC5617@eychenne.org>
	<439393C9.5020001@trash.net> <439513E1.3060407@milivojevic.org>
	<43951DBF.8050001@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43951DBF.8050001@trash.net>
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

>> From consumer (of your code) point of view, I do care.  The current
>> documentation was clearly encouraging (by example) use of TCPMSS from
>> filter table.  My guess is that majority of production systems using
>> TCPMSS target are using it from filter table.  If the only reason is
>> consistency (nothing is going to be fixed by the change, and nothing is
>> going to be broken by leaving it as is), a warning now (in manual page,
>> right next to the example) and change on next major kernel release (2.7)
>> might be the best approach.  I'd leave things as is for 2.6 series of
>> kernels.
>
> I agree. Just to make it clear, I do not intend to break it for no
> good reason. I was just surprised that when trying to unload it
> after flushing the mangle table there was still one reference left
> (from the debian ppp ip-up script). There is one potential reason
> to change it, packet classification algorithms like nf-hipac have
> an easier job if they can rely on certain conditions, like no
> changing of the packet in the filter table. But for now I've only
> updated the man-page.

Since the Linux kernel does not follow the old stable<->devel 
(2.even<->2.uneven) model, every new version is allowed to
break an older one.

On the way to restrict TCPMSS to -t mangle, the -m state
could also be obsoleted in favor of -m conntrack.




Jan Engelhardt
-- 
