From: Miguel Angel Alvarez <maacruz@usuarios.retecal.es>
Subject: GPL violation by router manufacturer Conceptronic
Date: Thu, 16 Dec 2004 20:37:42 +0100
Message-ID: <200412162037.42367.maacruz@usuarios.retecal.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi all! 

 I have found what may be (it surely seems to be) a GPL violation by 
Conceptronic (it was Tulip computers some years ago).
 They sell a router, actual model is C100BRS4H. Their web page is 
http://www.conceptronic.net, go to products->networking and you'll find it 
here. 
 
 A friend of mine bought one today.
 I first ran nmap against this device, and identified it as running linux 
2.4.18-2.4.20 
 Then I asked my friend to look for GPL notices and source code on the 
documentation and he could find none. 
 So, I went to the manufacturers web to look it myself, and could find no 
reference to linux or GPL code. What I found was and actual update to the 
router's ROM. 
 The download site is 
http://download.tulip.com/support/Conceptronic/Network/C100BRS4H/ 
After i downloaded it (C100BRS4H_2.97.bin) and ran the strings command i found 
the following significative strings: 
 webpages-6104k.bin 
 vmlinux.bin 

 I couldn't dig more since I don't know what proccessor has the device nor 
what compression algorithm they are using. 
 The rest was garbage, so i suposse this are two compressed files. 
 I searched in google, but i couldn't find any reference to this particular 
violation, just another violation in a wireless router from same 
manufacturer.

This is nmap output: 
 Starting nmap 3.50 ( http://www.insecure.org/nmap/ ) at 2004-12-16 16:58 CET 
 Interesting ports on (my friend's IP): 
 (The 1651 ports scanned but not shown below are in state: closed) 
 PORT STATE SERVICE 
 53/tcp filtered domain 
 80/tcp filtered http 
 515/tcp filtered printer 
 631/tcp filtered ipp 
 8080/tcp open http-proxy 
 9100/tcp filtered jetdirect 
 9111/tcp filtered DragonIDSConsole 
 9152/tcp filtered ms-sql2000 
 Device type: general purpose 
 Running: Linux 2.4.X 
 OS details: Linux 2.4.18 - 2.4.20 (X86) 
 Uptime 0.116 days (since Thu Dec 16 14:11:32 2004) 
 
 Nmap run completed -- 1 IP address (1 host up) scanned in 27.013 seconds
-- 
Don't see the world trought a window, be open{source}minded, and be free :-)
