From: Sumit <sumit@elitecore.com>
Subject: ipt_unclean query
Date: Sat, 08 Apr 2006 13:36:41 +0530
Message-ID: <44376F11.4000804@elitecore.com>
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

Hi Devs,
	After making an unclean DROP ruleset I got "not-working" complains form 
some of my clients who using specific stock-trading application.
	Simply looking to dmesg I found there are few message states that
ipt_unclean: TCP flags bad: 0x0015
	This message mean unclean match is dropping tcp packet with ACK,RST, 
and FIN flags. This I confirm with ipt_unclean.c code
	As per RFC793 (TCP)
...	...	...
In all states except SYN-SENT, all reset (RST) segments are validated by 
checking their SEQ-fields.  A reset is valid if its sequence number is 
in the window.
...	...	...
	Then is there any significance of dropping ACK+RST+FIN combination?

Happy Netfiltering,
--
  _____     __    __    ____   ____    __    ______
/\  ___\  /\  \ /\  \ /\  \ \/ /\  \ /\  \ /\__   _\
\ \ ____\ \ \  \\_|  \\ \  \_ /\ \  \\ \  \\__ \  \/
  \//\___ \ \ \______ / \ \__\   \ \__\\ \__\  \ \__\
   \/_____/  \/_____ /   \/__/    \/__/ \/__/   \/__/
