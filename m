From: "Sergio C" <sergnut@hotmail.com>
Subject: Defragmentation question
Date: Fri, 10 Sep 2004 20:26:31 +0000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <BAY10-F49ZndN8dtdCV0001bf58@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi all!!

I'm currently developing some IDS sensors that detects the source of an 
attack, for example one of them detects if from the machine where it is 
installed someone is doing IP spoofing, ICMP or UDP Flooding, SYN scan, 
etc... The sensors add a function to NF_IP_LOCAL_OUT.

I thought about the possibility that an intruder uses IP fragmentation for 
evade the sensors, for example, the SYN scan sensor could be evaded if the 
fragmentation cuts the TCP header, same with ICMP header and ICMP flooding 
sensor, etc... I was doing some tests with fragroute and hping2 to see what 
happens if an intruder try to fragment their packets. The results are that 
all the sensors continue working without problems. And my question is... 
Does netfilter apply some kind of defragmentation before NF_IP_LOCAL_OUT?

Someone from #netfilter ask me if I have conntrack loaded but the answer is 
NO... then why they contine working? I suppose that netfilter apply some 
kind of defragmenation even if conntrack is not loaded because in some 
maneer the architecture need to manage the packets, I mean... if no 
defragmentation is applied then no rules for another protocols different 
from IP can be used. Can anyone explain me a little more about that?

Thanx, and sorry if my question is so basic.

_________________________________________________________________
Dale rienda suelta a tu tiempo libre. Encuentra mil ideas para exprimir tu 
ocio con MSN Entretenimiento. http://entretenimiento.msn.es/
