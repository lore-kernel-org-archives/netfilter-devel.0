From: Francisco Javier Cabello Torres <fjcabello@visual-tools.com>
Subject: http&rtsp kernel 'proxy'
Date: Thu, 2 Oct 2003 11:45:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310021145.10243.fjcabello@visual-tools.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
I'm new with kernel development. 
I would like to implement a http&rtsp port as a kernel module.
First, I will try to explain what I want to develop. I have two servers, one 
of then a HTTP server, listening on port 80, and the second one a RTSP 
server, listening on port 554. My system is besides a firewall which only 
allow traffic in port 80. Because of that I need a 'proxy' listen on port 80 
which redirect traffic to RTSP server (still listen on 554) or HTTP server 
(now listen on 8080). This 'proxy' should  analyze incoming packets and 
depending of contents redirect it to one of the servers.  If packet contents 
belongs to rtsp protocol, it will be redirect to port 554, however if it's a 
http packet, it will be redirect to 8080.

I have been reading some documentation, and it think it would be possible to 
implement a iptables 'match' for rtsp and http packets, modify iptables to 
accept new match and then, with my modified iptables, specify rules to send 
packets to correct servers.
Any ideas? Am I going crazy?  ;)

Thanks.

Paco

--
Stop software patents!
examples: http://www.base.com/software-patents/examples.html
stop it, see http://petition.eurolinux.org & http://petition.ffii.org/eubsa/en

 11:44:07 up 1 day, 19:11,  1 user,  load average: 0.09, 0.07, 0.04
