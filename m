From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipq_get_msgerr: No such file or directory
Date: Sun, 03 Apr 2005 19:12:02 +0200
Message-ID: <425023E2.30703@trash.net>
References: <bfbae0cc011856c1dbdca5bedf862015@axentra.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert Scott <rbscott@axentra.net>
In-Reply-To: <bfbae0cc011856c1dbdca5bedf862015@axentra.net>
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

Robert Scott wrote:
> I am receiving this error code from ipq_get_msgerr.  The read is 
> successful, and returns a non-zero positive number, but when I call 
> ipq_message_type on the buffer used to read the packet, I get 
> NLMSG_ERROR, and then, when I call strerror( ipq_get_msgerr( buffer ))  
> where "buffer" is the second argument to ipq_read, I receive the error 
> message "No such file or directory".
> 
> This has occurred on a Linux 2.6.8.1 kernel with version 1.2.9 of 
> iptables.  The box where this occurred is acting as a bridge, and this 
> started happening when the internet connection on one of its interfaces 
> went down for a few hours.
> 
> Any ideas as to why this may be happening?

There is only a single place where ip_queue returns -ENOENT, which is
when in ipq_set_verdict when the entry can't be found.

Regards
Patrick
