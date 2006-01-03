From: Patrick McHardy <kaber@trash.net>
Subject: Re: [LARTC] ip_queue module issue
Date: Tue, 03 Jan 2006 13:58:37 +0100
Message-ID: <43BA74FD.9030205@trash.net>
References: <002301c61010$3fa46f60$455f030a@askeyrd3>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Salim <salim.si@askey.com.tw>
In-Reply-To: <002301c61010$3fa46f60$455f030a@askeyrd3>
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

Salim wrote:
> Hi All,
>    I am adding ip_queue module for snort inline IDS.
> 
> I am using snort2.4.0
> And iptables-1.3.4.
> 
> Userspace Queuing(queue target) is enabled. It is built-in and not built as
> a module.
> The output of /proc/net/ip_queue is shown below:
> 
> cat /proc/net/ip_queue>
> Peer PID          : 0
> Copy mode         : 0
> Copy range        : 0
> Queue length      : 0
> Queue max. length : 1024
> 
> 
> IPTABLES 1.3.4 is being used and it is built with install-devel option
> And libipq.a is seen in /lib directory.
> 
> SNORT is also built in with following options:
> ./configure --prefix=/usr/local/snort \
> --with-libpcap-includes=/usr/local/snort-lib/include \
> --with-libpcap-libraries=/usr/local/snort-lib/lib \
> --with-libpcre-includes=/usr/local/snort-lib/include \
> --with-libpcre-libraries=/usr/local/snort-lib/lib \
> --with-libnet-includes=/usr/local/snort-lib/include \
> --with-libnet-libraries=/usr/local/snort-lib/lib \
> --with-libipq-includes=/usr/local/iptables/include \
> --with-libipq-libraries=/usr/local/iptables/lib \
> --enable-inline
> 
> cat /proc/net/netlink>
> sk       Eth Pid    Groups   Rmem     Wmem     Dump     Locks
> c11c8040 0   0      00000000 0        0        00000000 2
> c7ec0140 3   0      00000000 0        0        00000000 7
> c11c8780 4   0      00000000 0        0        00000000 2
> c7e74c40 5   0      00000000 0        0        00000000 2
> 
> Starting SNORT now:
> /usr/local/snort/bin/snort -Q -N -l /var/log/snortlog -t
> /var/log/snortlog -s -D>
> Initializing Inline mode
> Reading from iptables
> InitInline: : Failed to send netlink message: Connection refused
> Starting snortd: FAILED
> 
> cat /proc/net/netlink>
> sk       Eth Pid    Groups   Rmem     Wmem     Dump     Locks
> c11c8040 0   0      00000000 0        0        00000000 2
> c7ec0140 3   0      00000000 0        0        00000000 8  >>>Locks
> increasing
> c11c8780 4   0      00000000 0        0        00000000 2
> c7e74c40 5   0      00000000 0        0        00000000 2
> 
> Can anybody please point me as to what could be the issue. As it is the
> ip_queue
> Is built in kernel and it is running as can be seen from cat
> /proc/net/ip_queue

Does it work if you build it as a module? If not please send the output
of strace -s 1000 -f snort ...
