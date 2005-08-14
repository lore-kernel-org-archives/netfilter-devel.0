From: Abhishek Misra <abhishekm@cdac.in>
Subject: error : unable to register queue handler
Date: Sun, 14 Aug 2005 15:41:27 +0530 (IST)
Message-ID: <twig.1124014287.15909@cdac.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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


hello,

I am having problem with inserting a module . It has compiled well but on
insertion (insmod) error message "failed to register queue handler" is
displayed.

the functiong call used is
nf_register_queue_handler(PF_INET,ipq_enquepacket,NULL);

i expect that the code is corect as it was working earlier . recently my
system had crashed and i had to reinstall linux. I have tried a lot with
kernel configuration (make menuconfig) but it did not help. 


please let me know to fix this.

Thank You
Abhishek Misra
