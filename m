From: Krishna Ramachandran <krishna@cs.ucsb.edu>
Subject: compiling netfilter modules outside of kernel tree
Date: Fri, 03 Oct 2003 10:30:22 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7DB22E.6080505@cs.ucsb.edu>
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
      I am facing a sort of a deployment issue ... I need to install a 
netfilter module i developed on several Linux systems. I understand that 
it is easiest to compile a netfilter module inside the kernel tree. 
However, it'd be impossible for me to ask each of the users to install 
the kernel source and then compile my module. I am hoping that there is 
a better way to do this. I'd appreciate any help you can provide.

Thanks in advance,
Krishna
