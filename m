From: James Ralston <qralston+ml.netfilter-devel@andrew.cmu.edu>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: Fri, 13 Dec 2002 03:14:03 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212130311130.2834-100000@shieldbreaker.l33tskillz.org>
References: <Pine.LNX.4.33.0212120955290.14108-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.33.0212120955290.14108-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 12 Dec 2002, Jozsef Kadlecsik wrote:

> Please note, that the timeout settings via /proc introduced in the
> tcp-window-tracking patch are global.  You cannot raise the UDP
> timeout values just for DNS.

That's true.  But on dedicated nameservers (the situation I care
about), I don't care if all UDP connections on the system receive the
higher limit.

> Also, we have to handle the backward compatibility issue of
> /proc/sys/net/ipv4/ip_conntrack_max, if the introduction of
> /proc/sys/net/ipv4/netfilter/ is accepted.

True.

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA
