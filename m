From: Stephen Lee <mukansai@emailplus.org>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Sat, 29 Nov 2003 04:55:53 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031129042551.A460.MUKANSAI@emailplus.org>
References: <20031126174943.0AA5.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031126174943.0AA5.MUKANSAI@emailplus.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephen Lee <mukansai@emailplus.org> wrote:
> Harald Welte wrote:
> > 
> > unfortunately there is no fix yet.  I seem to be unable to reproduce
> > that effect on my system :(
> 
> I'm having the same problem with 2.6.0-test10.  Just loading
> ip_conntrack (no rule in table) slows outbound speed to a crawl.  I am
> using e1000 as well (tried both with or without NAPI), on a 1000/MT
> Desktop Adaptor.
> 
> This seems to only affect traffic out of the host itself, I do not
> notice slow-down of traffic route through the box, but I didn't really
> stress test that.
> 
> FWIW, I was on 2.5.72 and it had the same behaviour, but ip_conntrack
> was not compiled as a module so I couldn't check if it is at fault.

I compiled lots of kernels :-( and narrowed it down to between 2.5.26
and 2.5.46.  2.5.26 oopses if I load certain progs like apache, but at
least ftp does not slow down in either direction.  2.5.46 has the same
problem as 2.6.0-test10 (and -test11, I tested that too).

Moreover, I borrowed an i865 chipset machine (which was running the
Fedora kernel) with CSA LAN that uses a different Intel chip (82547EI),
but the same e1000 driver, and it doesn't exhibit the problem with
2.6.0-test11.  I plugged a Pro1000/MT Desktop Adapter (82540EM chip)
into that i865 machine, and it DOES exhibit the problem.

To put it more clearly,

Kernel version		Chip		Problem?
2.4.22			82540EM		N
2.5.26			82540EM		N
2.5.46			82540EM		Y
2.6.0-test10		82540EM		Y
2.6.0-test11		82540EM		Y
2.6.0-test11		82547EI		N
2.4.22nptlsmp		82547EI		N

I'll keep on trying to isolate the problem, but need to get some sleep
first :-)  Please suggest which patch you think would have caused the
problem.  I was going by the ChangeLogs but not every kernel version
compiled cleanly. Your suggestions would cut down the number of kernels
to compile.

Regards,
Stephen
