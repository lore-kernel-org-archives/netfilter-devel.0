From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: How can I get these packets in the user space application?
Date: Thu, 9 Dec 2004 17:59:22 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412091757470.1688@filer.marasystems.com>
References: <4EE0CBA31942E547B99B3D4BFAB3481125897A@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: kung@uiuc.edu, netfilter-devel@lists.netfilter.org,
	Diego Woitasen <diegows@linux.org.ar>,
	"Mukund JB." <mukundjb@esntechnologies.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Srinivas G." <srinivasg@esntechnologies.co.in>
In-Reply-To: <4EE0CBA31942E547B99B3D4BFAB3481125897A@mail.esn.co.in>
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

On Thu, 9 Dec 2004, Srinivas G. wrote:

> Actually I need to send the packets to user space and then in the user
> space I need to do some calculations on the packet data and then I want
> to send the packet back to kernel space.

Perfect fit for QUEUE.

> I understood that queue the packet for user space handling. Finally we
> can issue 'nf_reinject' to send the packet into the network path again.

ip_queue manages all of this automatically for you. See libipq in the 
iptables package for how to write user-space side of things.

Unless you have very special demands you should not need to make any 
kernel changes, just use iptables as usual and send what you want to 
process in userspace to -j QUEUE

Regards
Henrik
