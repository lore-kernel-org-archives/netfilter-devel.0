From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: linux packet forwarding rate
Date: Thu, 06 Mar 2003 14:53:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E66F084.3F396F59@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all

I want to forward 1Gbps at line rate. Has anyone successfully used linux
to forward 1Gbps (assuming 1500 byte packet length, that is equivalent
to 80kpps) on gigabit ethernet?

If yes, how to configure the kernel? remove all the unnecessary modules?
Is FAST_SWITCHING useful?

If no, why? what is the upper bound?

Thank you very much.

Regards,
philip
Hong Kong IP Multicast Initiative (HKIPMI)
Department of Information Engineering
The Chinese University of Hong Kong
Phone : 2603 5240
Fax : 2603 5032
