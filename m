From: Duncan Godfrey <d.j.godfrey@reading.ac.uk>
Subject: Libipq: ipq_get_msgerr Error message
Date: Tue, 17 May 2005 17:11:15 +0100
Message-ID: <428A17A3.7070002@reading.ac.uk>
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

Hello,

Would someone be able to help me understand this error code which is 
being returned from ipq_get_msgerr (after a NLMSG_ERROR is returned 
from  ipq_read).  It is returning an error code  2, which I looked up 
in  errno.h and it translates to ENOENT "No such file or directory".

I really have no idea what this means, is it coming from the handle? I 
wasn't having this problem until I added a queue in user space for the 
packets, so I'm not sure if this has caused a problem.

Thanks in advance for any help,

Duncan
