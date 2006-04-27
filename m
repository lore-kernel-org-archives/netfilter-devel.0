From: "Paolo Cerrito" <paolo.cerrito@tin.it>
Subject: iptables http problems
Date: Thu, 27 Apr 2006 11:38:52 +0200
Message-ID: <op.s8nue2ddextast@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
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

Hi, i'm writing a userspace application, using nfnetlink_queue. Can i  
write a rule for iptables that send on a queue http packets? the problem  
is that i have to distinguish the packets for apllication layer protocols.  
Is there a way for that?

-- 
Creato con il rivoluzionario client e-mail di Opera:  
http://www.opera.com/mail/
