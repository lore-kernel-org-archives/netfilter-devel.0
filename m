From: aso@homeccess.com
Subject: can I map a specific priv. ip to a pub ip? How?
Date: Sun, 11 Apr 2004 10:07:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081674472.40790ae8a9361@mail.homeccess.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
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

   
a client has the following public address on his voip phone, XXX.XXX.13.35.    
 
This address I have given to the voip provider as that of the particular phone 
at which he can reach the client when packets are coming back in (necessary 
for QoS)  
   
however, I want to give the following private ip address to the customer,  
192.168.6.10. This address has to be mapped to XXX.XXX.128.35 both internally 
and externally so as to allow a two way on-going connection. How do I go about 
this?  
   
can I map to a particularly ip:port?  
   
 T.  
 

----------------------------------------------------------------------
Please visit http://www.homeccess.com
