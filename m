From: Jim Gifford <maillist@jg555.com>
Subject: Re: IPTables 1.3.0 on RaQ2
Date: Tue, 08 Mar 2005 14:59:15 -0800
Message-ID: <422E2E43.1070709@jg555.com>
References: <42292642.6030504@jg555.com>
	<20050305125710.GP30487@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050305125710.GP30487@sunbeam.de.gnumonks.org>
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

I solved the issue, it does happen with 1.3.1 also, the problem is the 
headers, even after fixed the headers it still bombed. Here is the 
message I posted on linux-mips list.

I found the culprit, but don't know what the proper fix is.

File - What to remove or comment out
/usr/src/linux/include/asm/cpu-features.h - #include 
<cpu-feature-overrides.h>
/usr/src/linux/include/asm/addrspace.h -  #include <spaces.h>

But it still fails, because it looks at the headers in /usr/include and 
the ones is /usr/src/linux/include, which is what the problem is. Namely 
socket.h, it tries to include both versions.

What I noticed is some of the mips architectures includes have these 
files and some do not.

A workaround for those who use the linux-libc-headers to build iptables 
with the following commands, but I would still comment out those files 
to prevent other build issues later

make KERNEL_DIR=/usr

But I'm not sure of the stability and the functionality.

-- 
----
Jim Gifford
maillist@jg555.com
