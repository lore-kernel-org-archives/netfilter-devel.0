From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Thu, 2 Jan 2003 10:31:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102103126.A32302@linux.karinthy.hu>
References: <20030101171654.B25870@linux.karinthy.hu> <20030102085734.GL9467@sunbeam.de.gnumonks.org> <20030102.010953.113716640.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laforge@gnumonks.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030102.010953.113716640.davem@redhat.com>; from davem@redhat.com on Thu, Jan 02, 2003 at 01:09:53AM -0800
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 02, 2003 at 01:09:53AM -0800, David S. Miller wrote:
>    From: Harald Welte <laforge@gnumonks.org>
>    Date: Thu, 2 Jan 2003 09:57:34 +0100
> 
>    Unfortunately we will never get netfilter-specific code into the
>    sys_sparc32.c file (and we also really don't want it to be there).
>    
>    Is there no solution which only touches iptables userspace and kernel
>    code? (net/ipv4/netfilter/* as well as libiptc.c in userspace)?
>    
> It is the only way to translate socket options that include user
> pointers or other types that are not identical in the 32-bit
> and 64-bit environment.
> 
> It is always a bad idea to pass pointers and other non-hardcoded
> types (ie. something other than u8, u16 etc.) via APIs.

Either we change the way of data exchange, or we have to use similar
thunking functions. We could cosmetically beautify it by moving the
actual implementation from sys_sparc32.c into some other source file
(maybe net/ipv4/netfilter/nf_sparc32.c?) and call it from sys_sparc32.c,
this however provides only a maintenance ease. I see that this is
an important aspect, too.

Laszlo
e-mail: <valko@linux.karinthy.hu>
