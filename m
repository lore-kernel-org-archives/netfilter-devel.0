From: "Farshad" <farshadas@excite.com>
Subject: netfilter and packet manipulation
Date: Wed, 26 Mar 2003 16:45:25 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326214525.E5CC9299A8@xmxpita.excite.com>
Reply-To: farshadas@excite.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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


Hi,

I need to choose a tool for packet manipulation. So I wonder if you could give me your comments on the below issues:

- How do you compare Netfilter to Divert Sockets and Netlink?
Two factors are important for me: the below question and the
efficency of communication between user and kernel space
(doing packet processing in user space)

- (just to make sure) Using Netfilter, is it possible to capture a packet on its way to another host while it is being routed, send it to the user space, then create a number of packets (e.g. two packets) in user space, and send them down into the kernel instead of the original packet towards the destination of the original packet?

   thanks very much,
   Farshad


_______________________________________________
Join Excite! - http://www.excite.com
The most personalized portal on the Web!
