From: Peter Zion <pzion@nit.ca>
Subject: Re: [PATCH] PPTP connection tracking: fixed oops during PPTP connect
 when interface under heavy load
Date: Tue, 01 Feb 2005 10:18:54 -0500
Message-ID: <41FF9DDE.2050401@nit.ca>
References: <41DD887D.6080007@nit.ca>
	<20050201104002.GV6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201104002.GV6878@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Thu, Jan 06, 2005 at 01:50:37PM -0500, Peter Zion wrote:
>  
>
>>Summary:
>>
>>If PPTP connection tracking is running on a machine and certain PPTP
>>packets arrive out of order, or preceding packets never made
>>it to the machine, the PPTP connection tracking code will
>>dereference NULL pointers.  Reproduction steps are to attempt PPTP 
>>connections to the machine on an interface under heavy load.
>>    
>>
>
>That's really strange.  Can you please elaborate more?
>  
>
I'm afraid I can't: I don't pretend to understand exactly what the 
problem is.  In our case we were seeing random kernel oopses under heavy 
load, and once we managed to create the series of reproduction steps 
that I listed in the original email it was exactly the same NULL pointer 
dereference every time.  Simply checking the pointer before 
dereferencing it, as done in my patch, "fixed" the problem in the sense 
that the kernel no longer locks up, and we have not seen any further 
problems under heavy load since applying the patch.

The best I can offer you is help in isolating the problem.  If, for 
instance, you made a patch with debugging output that would help you 
isolate the problem, I would be happy to run it against our reproduction 
steps and tell you what happens.
