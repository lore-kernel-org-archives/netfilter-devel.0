From: Null Device <nulldevice83@yahoo.com>
Subject: limiting connection rate
Date: Thu, 22 Apr 2004 13:17:32 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040422201732.60347.qmail@web41906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Helloo list,

I am new here. 
I am working on a firewall, as an LKM on 2.4.22
kernel. (still stateless filtering) at the network
layer + i have the following features in it.
-> shellcode filtering ( very basic)
-> snort rules supports.( alil proggie to convert
those rules to my firewall rules)
-> HTTP request control method.
-> Anti -( XSS and SQL Injection) measures.

just the imp ones.....as ur sites says keep the mails
short.

i am using netfilter hooks only.
is there a way i can limit the no of connections per
second per ip using certail iptable or netfilter
modules.
i was unable to find any documentation on it.

As my firewall is stateless, if i want to implement,
firstly i will have to make it stateful filtering and
then add the code to get the job done...so i was
looking for something which can same my work.

any guidance in the regard will prove a great help.

thx in advanve to everyone.

ND


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
