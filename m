From: "XiaoMing Zhu" <zhuxiaoming@hotmail.com>
Subject: how to create masquerade session using the apis of iptables
Date: Mon, 03 Jun 2002 15:15:08 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <F166fPQmfByZZA7ZzQk0000fdad@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

when using kernel 2.2.x and ipchains, we have a linux server which can 
create masquerade sessions dynamically using API: ip_masq_new() and forward 
these udp packets to internal network.
can you tell me if the kernel 2.4.x can finish the same work? any tips is 
appreciated.

_________________________________________________________________
Get your FREE download of MSN Explorer at http://explorer.msn.com/intl.asp.
