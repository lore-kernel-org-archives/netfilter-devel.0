From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: Fixed proken MARK target in POM.
Date: Sun, 12 Jan 2003 20:58:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E21C8CA.3070207@fugmann.dhs.org>
References: <3E1D7419.1060502@fugmann.dhs.org> <20030110140024.GU1353@sunbeam.de.gnumonks.org> <3E1EE68C.7030004@fugmann.dhs.org> <3E1EF712.8000100@fugmann.dhs.org> <20030111191647.GD24488@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030111191647.GD24488@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
>>Are defines tolerated? Something like:
>>#define MARK_BITOPS
>>
>>and then in the userspace do a:
>>#ifdef MARK_BITOPS
>>Whenever the new fileds in the structure is used.
> 
> 
> I don't understand how this could solve the problem.  #defines are about
> compile time.  We need one runtime iptables that copes with old and new
> kernels (and vice-versa).
I can see a way to make it somewhat compatible.

Kernel:
   Make a totally new structure (Keep the old one for compability)
   When checkentry is called, examine the size of argument:
	If it equals the old size, set a module-global variable
	meaning that the module should run in compability mode.	
   Othervice use the new structure.

This should sort out kernel compability with whatever iptables version.

Userspace:
   This is a bit more tricky, as compability is defined by compile time. 
That is, if iptables is compiled against 2.4.21 with the new MARK 
target, it will not work with a kernel without the MARK target. If this 
is acceptable, then a #define MARK_BITOPS can help solve the userspace 
compability. Something like

#ifdef MARK_BITOPS
   Accept --or-mark and --and-mark, and use the new structure.
#else
   Only accept --set-mark and usethe old structure.
#endif

Is this acceptable (no backward compability with iptables - it only 
works with the kernel its compiled against and newer, but not older)?
	
> 
> We have quite a couple of other cases where we have the same problem -
> without any solution :((  But during a stable kernel series, we cannot
> put compatibility aside.  People are not supposed to upgrade their
> iptables after they upgraded their kernel...
If the above procedure is acceptable, then it migh be a template for 
such updates in the stable kernel series. It is important that the old 
structures are removed for 2.6 though.

Regards
Anders Fugmann
