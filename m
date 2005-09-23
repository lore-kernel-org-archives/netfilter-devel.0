From: Nhan Thanh Le <ltnhan@tma.com.vn>
Subject: Netfilter virtual driver
Date: Fri, 23 Sep 2005 10:07:32 +0700
Message-ID: <43337174.9000009@tma.com.vn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Dear All,

   I want to build a application to monitor the network traffic in real 
time and It is designed as shown bellow:
        1. In kernel space, I build a virtual character driver  and hook 
to Netfilter  to capture all packets traffic via my network.
        2. On user space, my application handles all packet that was 
captured by my driver.
                    -----------------------------------------------
                    |    User space - My Application        |
                    -----------------------------------------------
                               /\                           /\
                               ||                            ||
                               \/                           \/
                    -----------------------------------------------
                    |   Kernel space - My Virtual Driver  |
                    -----------------------------------------------

            and my question is:

                a. How can I put all packets  is captured by my virtual  
driver in kernel space to my application on user space?
                b. Does my approach can solve by using ip_queue 
mechanism?  So, if  I use ip_queue mechanism is base on iptables modules 
and iptables is stopped, then we can not monitor packet. it is right?
                c. Should I use libpcap to do it?
                c. Does it exist any open source application base on 
netfilter and do the same my thesis, could you show it for me reference?

        Would you please help me understand it and tell me your 
comments/suggestion. Thank you very much and appreciate it for help.
               
Best Regards,
Nhanle
