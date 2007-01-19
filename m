From: "Mark Ryden" <markryde@gmail.com>
Subject: Changing packets with netfilter nf_hooks: can I avoid the forward
	hook?
Date: Fri, 19 Jan 2007 09:30:06 -0500
Message-ID: <dac45060701190630w24758b39j6bb9be99e086c5fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,
  I had read the netfilter hacking HOWTO in:

  (http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-3.html).
I want to use the nf_hooks API for a simple purpose:

My goal is to catch all packets which are sent to machine A to some
specified, known UDP port.
I want to send all these packets to a different machine, which we will
call B; the IP of that machine is
also known beforehand. I also want to change that UDP port to a known port.
I use successfully the PR_ROUTING hook to capture all packets which
are destined to that UDP
specified port on machine A. Now, I can change the destination IP
address of these captured packets to
machine B address (in the PRE_ROUTING hook function) and then catch
them in a forward hook
,set the source IP address in the fw hook , and return NF_ACCPET so
the packet will be sent.
My question is : is the forward hook a must? because as I understand ,
if I will set the
src address in the PRE_ROUTING hook to that of machine A (instead of
the real source IP address)
and the destination address to the IP address of machine B, then it
will enter the TCP/IP kernel stack, and this I want to avoid if
possible (because we are talking about a very high load server and
entering
the stack for a lot of packets has a high performance cost). So is there
a way to send the packet out on the wire in the PRE_ROUTING hook so
that it will not enter
the linux kernel networking stack?
Any help will be appreciated.

Mark
