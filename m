From: serjio <serjio@tajik.net>
Subject: Is this an ULOG error?
Date: Tue, 01 Feb 2005 11:28:24 +0500
Message-ID: <41FF2188.3040300@tajik.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hello All,

I would like to use ULOG and ULOGD for traffic accounting. But after I 
have installed
these tools on my router I was surprised that I cannot check my traffic 
with 100% accuracy.
I tested this by using a standart iptables counters. And there was 
always much more bytes than
I got in ulogd. 

In addition to this I see that ulogd logfile is flooded by messages like 
this:
ulogd.c:707 ipulog_read == -1! ipulog_errno == 6, errno = 105 strerr=No 
buffer space available

I think that there are some problems in transmit data via kernel socket 
to userspace.
Changing a socket network buffer size up to 4M didn't help me.
sysctl -w net.core.rmem_max=8388608
sysctl -w net.core.rmem_default=4194304
sysctl -w net.core.wmem_max=8388608
sysctl -w net.core.wmem_default=4194304

I would be grateful if anyone can help me.

Thanks,
Sergei
