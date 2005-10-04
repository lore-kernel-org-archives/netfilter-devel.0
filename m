From: Jerry Alexander <jerrya@airmail.net>
Subject: Netfilter ContextID
Date: Tue, 04 Oct 2005 13:26:47 -0500
Message-ID: <4342C967.2050308@airmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Dear Netfilter-devel:

     Working on implementing packetswitching.
     Of course  Iptables/Netfilter looks like the
correct medium to do so.
     Loaded things up and  iptables could
Add(append), subtract(delete) and move(replace) UDP/IP
connections.
     Wrote a base module using nf_register_hook at PREROUTING
to gather packet stats.
     My problem is this.  My manager wants a "ContextId"
generated during the a  add,subtract,move commands.  Of
course this would have to be unique(using a hashing algorithm
which uses the IP address and the Port Number).
     Right now this looks like it would need to be generated in the
kernel module.   But this would require all the Append/delete/Replace
command functions moved to the kernel function also!!
     Hoping someone can point me in the right direction on how
this would be done using Iptables and Netfilter.

                                  Thanks,
                                         Jerry
