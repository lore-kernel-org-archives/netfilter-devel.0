From: "Song Wang" <song_wang@msn.com>
Subject: Netbios problem with NAT
Date: Tue, 22 Jul 2003 00:00:25 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY5-F38OUbYAGeZNeH00001598@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi,

I found a problem with netbios when 2 Windows PCs behind a NAT router try to 
access
the same shared directory on the Windows server sitting on the other side of 
the NAT router.
(kernel 2.4.17 w/ iptables 1.2.7a)

For example

4.3.2.1--------<NAT router>---------PC1 192.168.1.2
                                       |-------PC2 192.168.1.3

Windows XP PC1 and PC2 got private IP address from the DHCP server on the 
NAT router.
When PC1 alone accesses the shared directory on the Windows XP server (or 
PC) 4.3.2.1 using
\\4.3.2.1, there is no problem. However, when PC2 also accesses the same 
directory via
\\4.3.2.1, problem arises. You can reproduce the problem in this way

Copy a file from \\4.3.2.1 to PC1, when the copying is ongoing, do a refresh 
(F5) or copy a file
on the same \\4.3.2.1 from PC2, you will see a dialog pop up on PC1

"The specified network name is not available"

The copying process got stuck.

Strangely, the problem seems to happen only when the two PC get the IP 
address
via DHCP. If one of the two PCs use the static IP address, the problem seems 
to go away.

Could this be a problem of netbios with connection tracking? Maybe we need 
to write
a nat helper module for netbios?

_________________________________________________________________
Protect your PC - get McAfee.com VirusScan Online  
http://clinic.mcafee.com/clinic/ibuy/campaign.asp?cid=3963
