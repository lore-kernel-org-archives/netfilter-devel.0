From: administrator tootai <admin@tootai.net>
Subject: LIST_DELETE ip_conntrack_core
Date: Thu, 11 Dec 2003 18:10:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD8A517.8030503@tootai.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter list <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everybody,

I have 2 servers: one on RH73 another an RH9 Both where with 2.4.22
kernel from kernel.org. I adapt patch 2.4.23 on both. The RH73 is
running like a charm. RH9 freeze after a time which depend on ... I
don't know, has kernel panic, can't eg access localhost
port 110 or 25 through telnet, can't be accessed as samba server and so
on. No need to say that booting with 2.4.22 everything is ok.

I notify below info in log, around 3 mn after computer was
start up:

kernel: LIST_DELETE: ip_conntrack_core.c:302
`&ct->tuplehash[IP_CT_DIR_REPLY'(dbe88d64) not in &ip_conntrack_hash[hr].

Computer is a AMD 1000 Mhz - 512 Mb RAM I even remove patched linux
source and donwload a full one from kernel.org. Just copy the .config
file from 2.4.22 in this tree, make oldconfig followed by make dep clean
bzImage make modules modules_install

What's wrong? Has anyone else got problems?

Thanks for any hint
