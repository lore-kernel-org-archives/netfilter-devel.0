From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [Bug 5147] New: missing file linux/netfilter_ipv4/lockhelp.h
Date: Mon, 29 Aug 2005 18:29:22 +0200
Message-ID: <431337E2.4000607@trash.net>
References: <20050829091448.56bd2ed0@dxpl.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20050829091448.56bd2ed0@dxpl.pdx.osdl.net>
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

Stephen Hemminger wrote:
> 
> Begin forwarded message:
> 
> Date: Mon, 29 Aug 2005 03:40:03 -0700
> From: bugme-daemon@kernel-bugs.osdl.org
> To: shemminger@osdl.org
> Subject: [Bug 5147] New: missing file linux/netfilter_ipv4/lockhelp.h
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=5147
> 
>            Summary: missing file linux/netfilter_ipv4/lockhelp.h
>     Kernel Version: 2.6.13
>             Status: NEW
>           Severity: normal
>              Owner: shemminger@osdl.org
>          Submitter: nmalykh@bilim.com
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution: kernel source
> Hardware Environment: 
> Software Environment:
> Problem Description:
> 
> Steps to reproduce: add missed file linux/netfilter_ipv4/lockhelp.h
> 
> ------- You are receiving this mail because: -------
> You are the assignee for the bug, or are watching the assignee.

All in-kernel users got converted to use regular locking functions,
out-of-tree stuff needs to be changed as well.
