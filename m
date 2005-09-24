From: "Giacomo" <delleceste@gmail.com>
Subject: NAT/filtering simple examples
Date: Sat, 24 Sep 2005 15:36:10 +0200
Message-ID: <003501c5c10c$eeb84830$0300a8c0@giacomino>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
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

Good morning.
If anyone in the news was interested, i communicate that i have finished 
developing
a simple ipv4 packet filter with nat/masquerading functionality.

Kernel programming encompasses these topics:

- Netlink sockets for user/kernel communication;
- Netfilter hook registration;
- getsockopt() function registration;
- Kernel module programming;
- Network programming (socket buffers, network functions...)
- /proc interface read/write example;
- kernel linked lists and related timers;
- ....

Userspace programming:

- Netlink communication (a simple netlink interface has been written);
- Pipes/semaphores for communication between parent and son processes;
- Networking functions;
- signals;
- unbuffered Input from terminal;
- ...

If anyone interested visit

http://www.giacomos.it/ipfire/index.html

and then if you find something interesting let me know!

delleceste@gmail.com

Thanks for those in the list who helped! :)

Giacomo S. 
