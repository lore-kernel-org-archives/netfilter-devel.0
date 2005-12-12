From: Juergen Kreileder <jk@blackdown.de>
Subject: Re: ipt_recent needs a maintainer!
Date: Mon, 12 Dec 2005 19:21:27 +0100
Message-ID: <439DBFA7.7000506@blackdown.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

> ipt_recent was merged into the mainline kernel quite some time ago, but
> unfortunately the original author doesn't seem to be compelled to
> maintain it.  There's nothing wrong with that, after all we do this
> voluntarily!  But we have to deal with the consequences.
> 
> Some people from the netfilter community have indicated that it's coding
> style rectifies a re-write, but that's something I don't want to address
> now.
> 
> What we need as a short-term solution is somebody maintaining this
> beast, somebody looking into bug reports, etc.

I'm using ipt_recent, so I'm interested in keeping it in shape.
I'm familiar with the code and its current issues (see
http://blog.blackdown.de/2005/05/09/fixing-the-ipt_recent-netfilter-module/)

So I'd like to volunteer for maintaining it.

> There are a number of bug reports coming in, and nobody really takes
> care of them.  The latest one seems to be
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=415

This is exactly the bug described on my site.

> but there are more, like
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=369

That bug is fixed since 2.6.12. The code in earlier kernels wasn't
64-bit safe.


	Juergen

-- 
Juergen Kreileder, Blackdown Java-Linux Team
http://blog.blackdown.de/
