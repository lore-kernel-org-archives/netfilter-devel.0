From: levsky@rave.iinet.net.au
Subject: Re: [PATCH] Add C99 initializers to a few ipv6/netfilter files
Date: Sat, 8 Mar 2003 19:12:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030308111256.GA13132@rave.iinet.net.au>
References: <20030307164305.GE2247@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Art Haas <ahaas@airmail.net>
Content-Disposition: inline
In-Reply-To: <20030307164305.GE2247@debian>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 07, 2003 at 10:43:05AM -0600, Art Haas wrote:
> Hi.
> 
> Here is a set of two patches that add C99 initializers to files in the
> subject directory. A similar patch for ipv4 files will follow.
> 
> There are some giant structures in the netfilter code that would benefit
> from named initializers. I'll try to tackle them later.
> 

Hi Art,

I've actually converted the ipv4/netfilter and ipv6/netfilter directories
over to c99 style initialisers, including the giant structs that you
were talking about.  I've sent the patches off to Harald a week or so
ago, so he should be able to roll them in at some point when his
workload gets a little lower.  

The patches are pretty large, but if you want a copy, drop me a line.

Cheers

Mark
> 
