From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: compiling netfilter modules outside of kernel tree
Date: Sat, 11 Oct 2003 22:37:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310112236050.14382-100000@filer.marasystems.com>
References: <3F7DB22E.6080505@cs.ucsb.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Krishna Ramachandran <krishna@cs.ucsb.edu>
In-Reply-To: <3F7DB22E.6080505@cs.ucsb.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 3 Oct 2003, Krishna Ramachandran wrote:

>       I am facing a sort of a deployment issue ... I need to install a 
> netfilter module i developed on several Linux systems. I understand that 
> it is easiest to compile a netfilter module inside the kernel tree. 
> However, it'd be impossible for me to ask each of the users to install 
> the kernel source and then compile my module. I am hoping that there is 
> a better way to do this. I'd appreciate any help you can provide.

Compiling kernel modules outside of the kernel is a little tricky. To
correctly compile a kernel module for a kernel you must have access to the
exact same kernel headers after "make dep" as when the kernel was built.

Regards
Henrik
