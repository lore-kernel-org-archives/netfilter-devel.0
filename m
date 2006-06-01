From: varun <varun@rocsys.com>
Subject: Prob with hook reg in iptables
Date: Thu, 01 Jun 2006 11:32:54 +0530
Message-ID: <447E830E.8000606@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

Hi all,

            I have a setup where iam using iptables. I have squid 
running on my statem. Now the scenario is that this sytem is my router. 
I have eth0 connected to LAN, eth1 to Wan 1 and eth2 to Wan2. In the 
same box i also have a propratery FW which has Load Balancing feature.  
Now my intention is i start iptables first so that it registers with 
netfilter hook first.
So policy is like this
      iptables -t nat -D PREROUTING -i eth0 -p tcp -j REDIRECT --to-port 
8080
 In the port 8080 i have squid running.
 As far as filtering of iptables is concerned it is allow all.

     So my basic FW functionality is concerned it is taken care by My 
Propratery FW. It will do  the natting for both wan interfaces in Load 
balance.

  Now what i expect is that iptables will get all the packets first and 
then packet will go to my firewall and might get dropped if ACL matches 
else it is success. Once success i expect the packet to be redirected to 
port 8080 where squid can take control.

 Now my problem is that even though iptables is registered first when i 
log the packets using iptables for the above rule i find that no packets 
are comming to iptables there by no packets are going to proxy. I get 
only some multicast packets.

 From lan iam able to browse well and all my traffic is going tru my FW 
rather that first through iptables. Why?

As far as my knowledge first registered module get the packet first and 
if the action is NF_ACCEPT the the next registered module to the hook 
gets it right? If yes why is it not happening? Another thing is what 
exactly does redirect do does it mangel the packet?

Please help me in this?

Varun
