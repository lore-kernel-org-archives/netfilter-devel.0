From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip6_queue.o for 2.4.20 kernel with gcc version 3.2.
Date: Sat, 17 Apr 2004 18:53:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404171849450.22016-100000@filer.marasystems.com>
References: <BAY14-DAV38tc13WOmQ0001b84c@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dev <devietf@hotmail.com>
In-Reply-To: <BAY14-DAV38tc13WOmQ0001b84c@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Apr 2004, Dev wrote:

> Dear netfilter developers
> 
> If any has the ip6_queue.o module compiled in the 2.4.20 kernel ( with
> gcc 3.2.2-5 for red hat)..please let me know
> 
> If any one has can you please send it as an attachment to me

Would be of little use to you as it needs to be compiled for the exact 
same RedHat kernel and architecture as you are using (which you btw did 
not specify).

Just build your own kernel and add the module to your kernel config. See 
the RedHat documentation on how to rebuild the RedHat kernels. It is not a 
complicated thing to do.

I do not think you will find many on this list using standard RedHat
kernels. Compiling modules to a custom kernel is so much easier than to
try to tweak the build process to build additional modules to a original
RedHat kernel RPM.

Regards
Henrik
