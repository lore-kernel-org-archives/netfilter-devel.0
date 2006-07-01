From: Stephen Clark <Stephen.Clark@seclark.us>
Subject: masquerade & ipsec
Date: Sat, 01 Jul 2006 18:57:34 -0400
Message-ID: <44A6FDDE.8050805@seclark.us>
Reply-To: Stephen.Clark@seclark.us
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

I am running kernel 2.6.16-1.2115_FC4 - I have network that looks like this:
                                            
FreeBSD                                           FC-4
10.0.128.0/17 <-> 10.0.254.254-65.162.x.x ipsec tunnel 
24.x.x.x-192.168.2.1 <-> 192.168.2.0/24

Some change recently caused masquerading to happen on my FC-4 box before 
ipsec happens
so my packets from my 192.168.2.0/24 network have the source address 
changed to my external interface address and don't get picked up by the 
SA. If I turn off masquerading
then ipsec works again. I didn't use to have this problem.

Ideas?

TIA,
Steve
I

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)
