From: Davide <tatonet@tiscali.it>
Subject: NAT-PT IPv4<-->IPv6
Date: Wed, 28 Jan 2004 16:40:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401281640.49151.tatonet@tiscali.it>
Reply-To: tatonet@tiscali.it
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
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

Hi,
first of all I want to beg your pardon for my horrible English. I'll try to be 
as clear as possible...

I'm intrested in writing an extension to the linux netfilter. 
Before studying the netfilter code, and hence before I start developing such 
extension, I would be very happy to know if it's possible to extend the linux 
netfilter (the NAT part of it, precisely) to support ipv4<-->ipv6 NAT-PT.
In particular my question,for now, is if it's possible to get a ipv6 datagram 
in input and put a ipv4 datagram in output (and viceversa) without causing 
problem in subsequent netfilter operations.

Thank you very much,
Davide.
