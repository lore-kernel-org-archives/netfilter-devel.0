From: pablo neira <pablo@eurodev.net>
Subject: sending event to user space
Date: Wed, 03 Dec 2003 15:23:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCDF1EB.1070803@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi list!

I programmed a dummy module for netfilter which tries to match a packet 
and if it does, it will do nothing (NF_ACCEPT) but I would want it to 
send an event to a program in user space to do something, how can I do that?

So something like:

a) packet gets my hook and do NF_ACCEPT.
b) modules sends an event to user space.
c) program in user space does something.

Thanks!
Pablo

P.S: thanks for this great piece of code!!
