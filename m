From: Robert Scott <rbscott@axentra.net>
Subject: ipq_get_msgerr: No such file or directory
Date: Mon, 21 Mar 2005 15:40:25 -0800
Message-ID: <963d7646d4ad76f6f7603e16e1e760c9@axentra.net>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
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

I am receiving this error code from ipq_get_msgerr.  The read is 
successful, and returns a non-zero positive number, but when I call 
ipq_message_type on the buffer used to read the packet, I get 
NLMSG_ERROR, and then, when I call strerror( ipq_get_msgerr( buffer ))  
where "buffer" is the second argument to ipq_read, I receive the error 
message "No such file or directory".

This has occurred on a Linux 2.6.8.1 kernel with version 1.2.9 of 
iptables.  The box where this occurred is acting as a bridge, and this 
started happening when the internet connection on one of its interfaces 
went down for a few hours.

Any ideas as to why this may be happening?

thanks,
--robert
