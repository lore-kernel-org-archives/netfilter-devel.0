From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Error message while using libipq
Date: Sun, 25 Jul 2004 00:40:10 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407242138.i6OLcMMX029289@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "MPLS Linux List" <mpls-linux-general@lists.sourceforge.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am trying to QUEUE packets to the userspace using libipq at my MPLS egress
router. But I always get the error message stating "Received error message".
Is this because the libipq program requires IP packet but I have QUEUED
packet on all the chains and got the same error. Can anyone help me as to
why I am getting this error message and how to get rid of it? I am doing the
same at the ingress and that works fine.

Regards,

 

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami

 
