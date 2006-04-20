From: Massimiliano Hofer <max@nucleus.it>
Subject: =?iso-8859-1?q?na=EFve?= question
Date: Thu, 20 Apr 2006 19:30:49 +0200
Message-ID: <200604201930.49748.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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

Hi,
I noticed in various part of the kernel that there are assignments on live 
kernel structures without locks to protect them (of course there are proper 
memory barriers).

Example from ipt_recent.c:
	curr_table->status_proc->read_proc = ip_recent_get_info;
	curr_table->status_proc->write_proc = ip_recent_ctrl;


I know that on a x86 a 32 bit assignment is atomic (I'm not sure about 386SXs) 
and the same goes for x86_64 and 64 bit pointer, but I'm not sure that it 
really works on other architectures.

I didn't find documentation about it. Is it just a normal practice due to the 
fact that exotic archs with odd bus widths aren't usually SMP or is it 
guaranteed?

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
