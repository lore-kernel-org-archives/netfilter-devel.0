From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Help required
Date: Fri, 23 Jul 2004 15:46:34 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407231245.i6NCj9MX009254@madinah.ccse.kfupm.edu.sa>
References: <1090537990.3506.6.camel@coati>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Eric Leblond'" <eric@inl.fr>,
   "Netfilter List" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1090537990.3506.6.camel@coati>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

It seems tat I cannot run my fw classifier although when I say lsmod it
shows the module cls_fw there. I also cross-checked packet marking through
the mangle and that is also perfect. All the traffic flows from the 2nd band
of the PRIO queue. These are my commands for the filter

tc filter add dev eth0 parent 1:0 prio 0 protocol ip handle 1 fw flowid 1:1 
tc filter add dev eth0 parent 1:0 prio 1 protocol ip handle 2 fw flowid 1:2 
tc filter add dev eth0 parent 1:0 prio 2 protocol ip handle 3 fw flowid 1:3

This is my 3rd email to the group, can anyone please help me on this one.
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
