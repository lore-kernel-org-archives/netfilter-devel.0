From: Jay Schulist <jschlst@linux-sna.org>
Subject: [PATCH] flow statistic match
Date: Tue, 17 Sep 2002 23:44:38 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0209172337160.10390-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-1463811839-1663971492-1032326430=:10390"
Cc: netfilter-devel@lists.netfilter.org,
	<netfilter@lists.netfilter.org>, Jay Schulist <jschlst@linux-sna.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-ID: <Pine.LNX.4.44L.0209172244331.10390@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463811839-1663971492-1032326430=:10390
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.44L.0209172244332.10390@hunger.screamingdaemon.com>

Hello Harald,
Here is a new match which adds per tuple packet and byte statistics along
with allowing the user to match on the number of bytes and packets for a
flow.

Iptables userspace patch is against a clean iptables-1.2.7a
Kernel patch is against a clean linux-2.4.19

# cat /proc/net/ip_conntrack
tcp      6 432000 ESTABLISHED src=192.168.1.3 dst=192.168.1.100 sport=22
dport=3368 pkts=39 bytes=4024 src=192.168.1.100 dst=192.168.1.3 sport=3368
dport=22 pkts=47 bytes=3512 use=1

flow v1.2.7a options:
   --lt-packet  num             Match on less than 'num' packet.
   --lt-byte    num             Match on less than 'num' byte.
   --gt-packet num              Match on greater than or equal 'num' packet.
   --gt-byte   num              Match on greater than or equal 'num' byte.

Thanks,
jay-s.

---1463811839-1663971492-1032326430=:10390
Content-Type: APPLICATION/octet-stream; name="linux-2.4.19-flow-match-2002091812.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209172344380.10390@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="linux-2.4.19-flow-match-2002091812.diff.gz"

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
rU35mAyhOroeDMeTYbFwdTcq4Pi/mqW3CcIcAAA=
---1463811839-1663971492-1032326430=:10390
Content-Type: APPLICATION/octet-stream; name="iptables-1.2.7a-flow-match-2002091812.diff.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L.0209172344381.10390@hunger.screamingdaemon.com>
Content-Description: 
Content-Disposition: attachment; filename="iptables-1.2.7a-flow-match-2002091812.diff.gz"

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
P6fVUuH7FgAA
---1463811839-1663971492-1032326430=:10390--
