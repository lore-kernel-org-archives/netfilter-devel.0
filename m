From: Hellwolf Misty <hellwolf@seu.edu.cn>
Subject: when I DNAT to local address, the port num seems to be strange.
Date: Thu, 18 Aug 2005 09:36:15 +0800
Message-ID: <1124328975.2701.7.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

# iptables -t nat  -I OUTPUT -d 1.2.3.4 -j DNAT --to 127.0.0.1

# nc -vvv -l  8888 &
[1] 2038
# nc 1.2.3.4 8888&
[2] 2039

# netstat -tn
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address               Foreign Address
State
tcp        0      0 127.0.0.1:8888              222.185.xx.xx:1025
ESTABLISHED
tcp        0      0 222.185.xx.xx:53529         1.2.3.4:8888
ESTABLISHED
...(other line were lognored, and 'xx' for privacy reason)


And why the port num shows 1025? And at the mean time I also can listen
to this port:
# nc -l 1025&
# netstat -tnl
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address
State
tcp        0      0 0.0.0.0:1025                0.0.0.0:*
LISTEN
