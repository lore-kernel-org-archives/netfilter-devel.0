From: Eicke Friedrich <tady@gmx.net>
Subject: conntrack and kernel log
Date: Wed, 07 May 2003 16:03:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EB91241.8070209@gmx.net>
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

Hi,

comparing the kernel messages of two linux boxes I found something 
that I don't understand. Maybe someone can explain it to me?

First box, Pentium 133, 64MB RAM CONNMARK installed:
kernel: ip_conntrack version 2.1 (512 buckets, 4096 max) - 156 bytes 
per conntrack

Second box: Dual PentiumII 266, 192MB RAM, no CONNMARK installed:
kernel: ip_conntrack version 2.1 (1536 buckets, 12288 max) - 292 bytes 
per conntrack

How comes that the size per conntrack is at the first box smaller even 
though CONNMARK is installed? I mean it uses some bytes more per entry 
for the mark= field? Is it due to two CPU's? Sorry for this newbie 
question but googlin' did not gave me an answer.

Thanks for any comments,
Eicke.
