From: Stephen Lee <mukansai@emailplus.org>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Sun, 30 Nov 2003 07:54:37 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130074532.0105.MUKANSAI@emailplus.org>
References: <20031126174943.0AA5.MUKANSAI@emailplus.org> <20031129042551.A460.MUKANSAI@emailplus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20031129042551.A460.MUKANSAI@emailplus.org>
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
> 
> I compiled lots of kernels :-( and narrowed it down to between 2.5.26
> and 2.5.46.
> 
> Kernel version	Chip		Problem?
> 2.4.22		82540EM		N
> 2.5.26		82540EM		N
> 2.5.46		82540EM		Y
> 2.6.0-test10		82540EM		Y
> 2.6.0-test11		82540EM		Y
> 2.6.0-test11		82547EI		N
> 2.4.22nptlsmp		82547EI		N

I narrowed it down to patch-2.5.44.  e1000 is updated, but I backed out
the driver to the 2.5.43 version and it didn't fix the problem. 
Besides, 2.4.23 has a newer version of the driver and it doesn't have
this problem.

As far as I see netfilter was not updated in that patch, was it? I tried
insmod -f ip_conntrack.o from 2.5.43 into the 2.5.44 kernel and it
didn't stop the problem from happening, either.

Please advice.  If you don't think this is a netfilter problem I'll go
check with linux-kernel.

Regards,
Stephen
