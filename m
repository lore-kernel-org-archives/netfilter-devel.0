From: "Eduard Calvo (B-teljpa) EXP JAN 03" <ecalvo@mat.upc.es>
Subject: SNAT own module
Date: Tue,  3 Dec 2002 16:40:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1038930033.3decd071443b6@wmail-mat.upc.es>
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

  
  Hi gurus,  
  
  I posted a message a few days ago about doing a forced SNAT before routing.  
A good guy (thanks, Peter) answered me that it was impossible to SNAT the  
packet before routing because doing SNAT makes the packet impossible to route.  
  
  What I want to know is if is possible to do this in a raw manner. I mean, I  
have an ethernet card (let it be eth0) which IP address 10.0.0.1, which  
manages the 10.0.0.X network. The problem is that hosts attached to that  
network don't have to have an IP address on that range. I want to "manage" all 
these address doing SNAT the sooner the better when a packet enters my Linux 
box so my machine only sees addresses on that range. I mean, independently of 
what an address a host has, I want my machine to view it as an owner of one of 
the 10.0.0.X's suitables addresses. This has to be done before routing (I also 
run a transparent www proxy) because I want to do MASQUERADING on POSTROUTING. 
The only thing I need is to change the address and update the checksums of the 
packet. My configuration is like this: 
 
 
      x.y.z.t ___               _____ 
      s.u.w.q ___|             |     | 
		 |	       |LINUX| 
                 |    10.0.0.1 |     | a.b.c.d 
               . |-------------| BOX |---------- 
               . |             |_____| 
               . | MY LAN               TO THE ISP's ROUTER  
      g.h.j.k ___| 
 \_______  _______/ 
         \/ 
  I want this addresses to appear as a normal, homogeneus network to my box. 
And I need to do that before routing. I have resolved the routing of the 
packets, but this point worries me a lot. 
 
  Does anyone know the better way to do this? 
  Thanks in advanced, 
 
                                             Eduard. 

-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
