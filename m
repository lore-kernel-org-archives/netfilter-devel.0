From: "liu zixing" <liuzixing@hotmail.com>
Subject: how to count byte flow of a host in iptables
Date: Wed, 13 Aug 2003 17:46:44 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-F28y3JdZZzxTS200013084@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312; format=flowed
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

hello all,

    I am a fresh user to iptables. And I want to use iptables on my LAN 
gateway.

    I know that in ipchains byte flow is how to be counted:
         A counter rule is insert to chain FORWARD with specified $ip and 
without target.
         Packets whose source ip equals to $ip will match the rule, and its 
byte flow 
         will be recorded.
         Then we can read out the record from /proc/net/ip_fwchains.
   
   But in iptables there is no file  as /proc/net/ip_fwchains.
   And I do not know which chain to insert the rule in , filter/FORWARD or 
chains in table   
   nat/mangle?
   And if I had the counter rule, how can I get the flow record out? ( I 
mean by code , maybe I 
    can copy  the source code of iptables :-)).
   
   thanks.
                                              Hugh.Liu

_________________________________________________________________
享用世界上最大的电子邮件系统— MSN Hotmail。  http://www.hotmail.com  
