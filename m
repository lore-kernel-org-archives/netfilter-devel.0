From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: [Bug] limit match not working on Sparc64
Date: Sun, 25 May 2003 22:28:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED1275B.3000705@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

The limit match seems to be broken on sparc64 arch. It works on i386.

#iptables -A INPUT -m limit --limit 1/second --limit-burst 3 -j ACCEPT
iptables: Invalid argument

ipt_limit module is loaded.

#uname -a
Linux fw 2.4.21-rc2 #1 Tue May 20 20:14:39 CEST 2003 sparc64 unknown 
unknown GNU/Linux

#iptaiptables v1.2.7a
iptbles --version

More information available on request.

I guess that its the 64bit kernel/32bit user-space that is making the 
module break. If anyone has some pointers on how to fix this, I would be 
glad to try and fix it - Maybe we can get a patch into 2.4.21.

Regards
Anders Fugmann
